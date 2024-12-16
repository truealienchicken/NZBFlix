import UIKit

class DownloadProgressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private var downloads: [NZBGetDownload] = []
    private var timer: Timer? // Timer to refresh data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Download Progress"
        
        setupTableView()
        fetchDownloadQueue()
        startAutoRefresh()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DownloadProgressCell.self, forCellReuseIdentifier: DownloadProgressCell.identifier)
        
        // Disable cell selection
        tableView.allowsSelection = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func fetchDownloadQueue() {
        NZBGetAPIManager.shared.fetchDownloads { [weak self] downloads, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showError(error)
                    return
                }
                self?.downloads = downloads ?? []
                self?.tableView.reloadData()
            }
        }
    }
    
    private func startAutoRefresh() {
        // Timer updates every 1 second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.fetchDownloadQueue()
        }
    }
    
    private func stopAutoRefresh() {
        timer?.invalidate()
        timer = nil
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoRefresh() // Stop the timer when view disappears
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DownloadProgressCell.identifier, for: indexPath) as? DownloadProgressCell else {
            return UITableViewCell()
        }
        let download = downloads[indexPath.row]
        cell.configure(with: download)
        
        // Disable selection style
        cell.selectionStyle = .none
        
        return cell
    }
    
}

