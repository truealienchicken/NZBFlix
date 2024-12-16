import UIKit

struct MediaResult: Decodable {
    let id: Int? // Add this property to store the media ID
    let title: String
    let overview: String?
    let year: Int?
    let images: [Image]?
    let tmdbId: Int? // Radarr-specific ID
    let tvdbId: Int? // Sonarr-specific ID
    
    struct Image: Decodable {
        let coverType: String
        let remoteUrl: String
    }
}

class SearchMediaResultsViewController: UITableViewController, UITextFieldDelegate{
    var query: String = ""
    var isRadarr: Bool = false
    var isSonarr: Bool = false
    var results: [MediaResult] = []
    var searchHide: Bool = false { // Observe changes to this property
        didSet {
            configureTableHeaderView()
        }
    }
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search for media..."
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Results"
        
        // Configure the text field
        searchTextField.delegate = self
        configureTableHeaderView()
        
        // Register the custom cell
        tableView.register(MediaTableViewCell.self, forCellReuseIdentifier: "MediaCell")
        tableView.rowHeight = 170
        
        searchForMedia()
    }
    
    private func configureTableHeaderView() {
        if searchHide {
            tableView.tableHeaderView = nil // Hide the search text field
        } else {
            let headerView = UIView()
            headerView.addSubview(searchTextField)
            headerView.frame.size.height = 50
            
            // Add constraints for the text field
            NSLayoutConstraint.activate([
                searchTextField.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
                searchTextField.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
                searchTextField.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
                searchTextField.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
            ])
            
            tableView.tableHeaderView = headerView // Show the search text field
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Dismiss the keyboard
        if let text = textField.text, !text.isEmpty {
            query = text
            searchForMedia() // Call the search function with the new query
        }
        return true
    }
    
    private func searchForMedia() {
        guard !query.isEmpty else { return }
        
        // Retrieve IP address and API key from UserDefaults
        guard let ipAddress = UserDefaults.standard.string(forKey: "ipAddress") else {
            print("IP Address not found in UserDefaults")
            return
        }
        
        let apiEndpoint: String
        let apiKey: String?
        
        if isRadarr {
            apiEndpoint = "http://\(ipAddress):7878/api/v3/movie/lookup?term=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            apiKey = UserDefaults.standard.string(forKey: "radarrApiKey")
        } else if isSonarr {
            apiEndpoint = "http://\(ipAddress):8989/api/v3/series/lookup?term=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            apiKey = UserDefaults.standard.string(forKey: "sonarrApiKey")
        } else {
            print("Neither Radarr nor Sonarr selected")
            return
        }
        
        guard let finalApiKey = apiKey else {
            print("API Key not found in UserDefaults")
            return
        }
        
        // Create the request
        var request = URLRequest(url: URL(string: apiEndpoint)!)
        request.httpMethod = "GET"
        request.timeoutInterval = 30 // Increase timeout
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(finalApiKey, forHTTPHeaderField: "X-Api-Key")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Search API error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data returned from search API")
                return
            }
            
            // Parse the response
            do {
                let searchResults = try JSONDecoder().decode([MediaResult].self, from: data)
                DispatchQueue.main.async {
                    self.results = searchResults
                    //print(searchResults)
                    self.tableView.reloadData()
                }
            } catch {
                print("Error parsing search results: \(error)")
            }
        }
        task.resume()
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath) as? MediaTableViewCell else {
            return UITableViewCell()
        }
        
        let result = results[indexPath.row]
        cell.configure(with: result)
        return cell
    }
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = results[indexPath.row]
        
        // Determine if the media is for Radarr or Sonarr
        addMediaToQueue(selectedItem, isRadarr: isRadarr) { [weak self] success, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if success {
                    self.showConfirmation(message: "\(selectedItem.title) has been added to downloads.")
                    // Navigate back to StartPageViewController
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    self.showError(message: error ?? "Failed to add \(selectedItem.title) to downloads.")
                }
            }
        }
    }
    
    private func addMediaToQueue(_ media: MediaResult, isRadarr: Bool, completion: @escaping (Bool, String?) -> Void) {
        guard let ipAddress = UserDefaults.standard.string(forKey: "ipAddress") else {
            completion(false, "IP Address not found.")
            return
        }
        
        let apiKey = isRadarr
        ? UserDefaults.standard.string(forKey: "radarrApiKey")
        : UserDefaults.standard.string(forKey: "sonarrApiKey")
        
        guard let finalApiKey = apiKey else {
            completion(false, "API Key not found.")
            return
        }
        
        let rootFolderEndpoint = isRadarr
        ? "http://\(ipAddress):7878/api/v3/rootfolder"
        : "http://\(ipAddress):8989/api/v3/rootfolder"
        
        fetchRootPaths(from: rootFolderEndpoint, apiKey: finalApiKey) { [weak self] rootPaths, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(false, "Failed to fetch root paths: \(error)")
                return
            }
            
            guard let rootPaths = rootPaths, !rootPaths.isEmpty else {
                completion(false, "No root paths found.")
                return
            }
            
            let selectedRootPath = rootPaths[0] // Use the first root path for simplicity
            let path = "\(selectedRootPath)\\\(media.title.replacingOccurrences(of: " ", with: "-"))"
            
            var body: [String: Any] = [
                "title": media.title,
                "qualityProfileId": 1, // Assuming 1 for "Any" profile
                "titleSlug": media.title.replacingOccurrences(of: " ", with: "-").lowercased(),
                "monitored": true
            ]
            
            if isRadarr {
                // Radarr-specific payload
                body["year"] = media.year ?? 0
                body["tmdbId"] = media.tmdbId ?? 0
                body["path"] = path
                body["addOptions"] = ["searchForMovie": true]
            } else {
                // Sonarr-specific payload
                body["tvdbId"] = media.tvdbId ?? 0
                body["rootFolderPath"] = selectedRootPath
                body["addOptions"] = ["searchForMissingEpisodes": true]
            }
            
            let apiEndpoint = isRadarr
            ? "http://\(ipAddress):7878/api/v3/movie"
            : "http://\(ipAddress):8989/api/v3/series"
            
            var request = URLRequest(url: URL(string: apiEndpoint)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(finalApiKey, forHTTPHeaderField: "X-Api-Key")
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(false, "Network error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(false, "Invalid response from server.")
                    return
                }
                
                if httpResponse.statusCode == 201 {
                    self.triggerSearch(media: media, isRadarr: isRadarr, completion: completion)
                } else {
                    let errorMessage = "Failed with status code: \(httpResponse.statusCode) - \(String(data: data ?? Data(), encoding: .utf8) ?? "No response body")"
                    completion(false, errorMessage)
                }
            }.resume()
        }
    }
    
    private func triggerSearch(media: MediaResult, isRadarr: Bool, completion: @escaping (Bool, String?) -> Void) {
        guard let ipAddress = UserDefaults.standard.string(forKey: "ipAddress"),
              let apiKey = isRadarr
                ? UserDefaults.standard.string(forKey: "radarrApiKey")
                : UserDefaults.standard.string(forKey: "sonarrApiKey") else {
            completion(false, "IP Address or API Key not found.")
            return
        }
        
        let apiEndpoint = isRadarr
        ? "http://\(ipAddress):7878/api/v3/command"
        : "http://\(ipAddress):8989/api/v3/command"
        
        let commandType = isRadarr ? "MoviesSearch" : "SeriesSearch"
        let idField = isRadarr ? "movieIds" : "seriesIds"
        
        guard let mediaId = isRadarr ? media.id ?? media.tmdbId : media.id ?? media.tvdbId else {
            completion(false, "Media ID not found.")
            return
        }
        
        let body: [String: Any] = [
            "name": commandType,
            idField: [mediaId]
        ]
        
        var request = URLRequest(url: URL(string: apiEndpoint)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Search failed: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Invalid response from server.")
                return
            }
            
            if httpResponse.statusCode == 201 {
                completion(true, "Search started successfully.")
            } else {
                let errorMessage = "Search failed with status code: \(httpResponse.statusCode) - \(String(data: data ?? Data(), encoding: .utf8) ?? "No response body")"
                completion(false, errorMessage)
            }
        }
        task.resume()
    }
    
    private func fetchRootPaths(from url: String, apiKey: String, completion: @escaping ([String]?, String?) -> Void) {
        guard let endpoint = URL(string: url) else {
            completion(nil, "Invalid URL.")
            return
        }
        
        var request = URLRequest(url: endpoint)
        request.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(nil, "No data received.")
                return
            }
            
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                let paths = jsonArray?.compactMap { $0["path"] as? String }
                completion(paths, nil)
            } catch {
                completion(nil, "Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func showConfirmation(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
