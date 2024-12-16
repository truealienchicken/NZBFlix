import Foundation

// Root response matching the JSON structure
struct NZBGetResponse: Decodable {
    let result: [NZBGetDownload]
}

// Individual download item
struct NZBGetDownload: Decodable {
    let id: Int
    let name: String
    let status: String
    let remainingSizeMB: Int
    let downloadedSizeMB: Int
    let fileSizeMB: Int
    let downloadTimeSec: Int
    let remainingFileCount: Int
    let health: Int
    let failedArticles: Int
    let successArticles: Int
    let category: String
    let unpackStatus: String
    let parStatus: String
    let scriptStatus: String
    let downloadedSizeLo: Int
    let downloadedSizeHi: Int
    let nzbFilename: String
    let messageCount: Int
    let downloadRate: Double? // Make this optional

    enum CodingKeys: String, CodingKey {
        case id = "NZBID"
        case name = "NZBName"
        case status = "Status"
        case remainingSizeMB = "RemainingSizeMB"
        case downloadedSizeMB = "DownloadedSizeMB"
        case fileSizeMB = "FileSizeMB"
        case downloadTimeSec = "DownloadTimeSec"
        case remainingFileCount = "RemainingFileCount"
        case health = "Health"
        case failedArticles = "FailedArticles"
        case successArticles = "SuccessArticles"
        case category = "Category"
        case unpackStatus = "UnpackStatus"
        case parStatus = "ParStatus"
        case scriptStatus = "ScriptStatus"
        case downloadedSizeLo = "DownloadedSizeLo"
        case downloadedSizeHi = "DownloadedSizeHi"
        case nzbFilename = "NZBFilename"
        case messageCount = "MessageCount"
        case downloadRate = "DownloadRate"
    }
}

class NZBGetAPIManager {
    static let shared = NZBGetAPIManager()
    
    private var baseURL: String {
        guard let ipAddress = UserDefaults.standard.string(forKey: "ipAddress") else {
            fatalError("NZBGet IP Address not set in UserDefaults.")
        }
        return "http://\(ipAddress):6789/jsonrpc"
    }
    
    private let username = "x" // Replace with your NZBGet username.
    private let password = "1234" // Replace with your NZBGet password.
    
    func fetchDownloads(completion: @escaping ([NZBGetDownload]?, Error?) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let authString = "\(username):\(password)"
        let authData = Data(authString.utf8).base64EncodedString()
        request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonBody: [String: Any] = [
            "method": "listgroups",
            "params": [],
            "id": 1
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
        } catch {
            completion(nil, error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(NZBGetResponse.self, from: data)
                completion(response.result, nil)
            } catch {
                print("Decoding error: \(error)")
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
}
