import Foundation

struct SABnzbdResponse: Decodable {
    let queue: SABnzbdQueue
}

struct SABnzbdQueue: Decodable {
    let slots: [SABnzbdDownload]
    let status: String
    let speedlimit: String
    let speed: String
    let timeleft: String
    let mbleft: String
    let mb: String
}

struct SABnzbdDownload: Decodable {
    let id: String
    let filename: String
    let status: String
    let sizeLeft: String
    let size: String
    let mbleft: String
    let mb: String
    let percentage: String
    let timeleft: String
    let priority: String
    let category: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "nzo_id"
        case filename
        case status
        case sizeLeft = "sizeleft"
        case size
        case mb
        case mbleft
        case percentage
        case timeleft
        case priority
        case category = "cat"
    }
}

class SABnzbdAPIManager {
    static let shared = SABnzbdAPIManager()
    
    private var baseURL: String {
        guard let ipAddress = UserDefaults.standard.string(forKey: "ipAddress") else {
            fatalError("SABnzbd IP Address not set in UserDefaults.")
        }
        return "http://\(ipAddress):8080/sabnzbd/api"
    }
    
    private var apiKey: String {
        guard let key = UserDefaults.standard.string(forKey: "sabnzbdApiKey") else {
            fatalError("SABnzbd API key not set in UserDefaults.")
        }
        return key
    }
    
    func fetchDownloads(completion: @escaping ([SABnzbdDownload]?, Error?) -> Void) {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "mode", value: "queue"),
            URLQueryItem(name: "output", value: "json"),
            URLQueryItem(name: "apikey", value: apiKey)
        ]
        
        guard let url = components?.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(SABnzbdResponse.self, from: data)
                completion(response.queue.slots, nil)
            } catch {
                print("Decoding error: \(error)")
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
