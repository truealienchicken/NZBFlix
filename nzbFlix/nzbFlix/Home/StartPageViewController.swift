import UIKit

class StartPageViewController: UIViewController {
    
    private let searchMoviesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search Movies", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchTVShowsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search TV Shows", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let newMoviesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New Movies", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let trendingMoviesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Trending Movies", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let trendingTVShowsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Trending TV Shows", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadProgressButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download Progress", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Settings", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let savedNzbGeekApiKey = UserDefaults.standard.string(forKey: "nzbGeekApiKey")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .black : .white
        } // Adapt background color based on light/dark mode
        
        setupActions()
        setupLayout()
    }
    
    private func setupActions() {
        newMoviesButton.addTarget(self, action: #selector(didTapNewMovies), for: .primaryActionTriggered)
        searchMoviesButton.addTarget(self, action: #selector(didTapSearchMovies), for: .primaryActionTriggered)
        searchTVShowsButton.addTarget(self, action: #selector(didTapSearchTVShows), for: .primaryActionTriggered)
        trendingMoviesButton.addTarget(self, action: #selector(didTapTrendingMovies), for: .primaryActionTriggered)
        trendingTVShowsButton.addTarget(self, action: #selector(didTapTrendingTVShows), for: .primaryActionTriggered)
        downloadProgressButton.addTarget(self, action: #selector(didTapDownloadProgress), for: .primaryActionTriggered)
        settingsButton.addTarget(self, action: #selector(didTapSettings), for: .primaryActionTriggered)
    }
    
    private func setupLayout() {
        view.addSubview(searchMoviesButton)
        view.addSubview(searchTVShowsButton)
        view.addSubview(newMoviesButton)
        view.addSubview(trendingMoviesButton)
        view.addSubview(trendingTVShowsButton)
        view.addSubview(downloadProgressButton)
        view.addSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            searchMoviesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchMoviesButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -250),
            
            searchTVShowsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTVShowsButton.topAnchor.constraint(equalTo: searchMoviesButton.bottomAnchor, constant: 20),
            
            newMoviesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newMoviesButton.topAnchor.constraint(equalTo: searchTVShowsButton.bottomAnchor, constant: 20),
            
            trendingMoviesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trendingMoviesButton.topAnchor.constraint(equalTo: newMoviesButton.bottomAnchor, constant: 20),
            
            trendingTVShowsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trendingTVShowsButton.topAnchor.constraint(equalTo: trendingMoviesButton.bottomAnchor, constant: 20),
            
            downloadProgressButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadProgressButton.topAnchor.constraint(equalTo: trendingTVShowsButton.bottomAnchor, constant: 20),
            
            settingsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingsButton.topAnchor.constraint(equalTo: downloadProgressButton.bottomAnchor, constant: 20)
        ])
    }
    
    @objc private func didTapDownloadProgress() {
        let downloadProgressVC = DownloadProgressViewController()
        downloadProgressVC.title = "Download Progress"
        navigationController?.pushViewController(downloadProgressVC, animated: true)
    }
    
    @objc private func didTapSettings() {
        let settingsVC = SettingsViewController()
        settingsVC.title = "Settings"
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc private func didTapSearchMovies() {
        print("Search Movies button tapped")
        let searchVC = SearchMediaResultsViewController()
        searchVC.isRadarr = true
        searchVC.isSonarr = false
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc private func didTapSearchTVShows() {
        print("Search TV Shows button tapped")
        let searchVC = SearchMediaResultsViewController()
        searchVC.isRadarr = false
        searchVC.isSonarr = true
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc private func didTapNewMovies() {
        print("New Movies button tapped")
        let nzbgeekVC = nzbgeekViewController()
        nzbgeekVC.radarr = true
        nzbgeekVC.url = "https://api.nzbgeek.info/rss?t=new_movies&limit=100&r=\(savedNzbGeekApiKey ?? "")"
        navigationController?.pushViewController(nzbgeekVC, animated: true)
    }
    
    @objc private func didTapTrendingMovies() {
        print("Trending Movies button tapped")
        let nzbgeekVC = nzbgeekViewController()
        nzbgeekVC.radarr = true
        nzbgeekVC.url = "https://api.nzbgeek.info/rss?t=trending_movies&limit=100&r=\(savedNzbGeekApiKey ?? "")"
        navigationController?.pushViewController(nzbgeekVC, animated: true)
    }
    
    @objc private func didTapTrendingTVShows() {
        print("Trending TV Shows button tapped")
        let nzbgeekVC = nzbgeekViewController()
        nzbgeekVC.sonarr = true
        nzbgeekVC.url = "https://api.nzbgeek.info/rss?t=trending_shows&limit=100&r=\(savedNzbGeekApiKey ?? "")"
        navigationController?.pushViewController(nzbgeekVC, animated: true)
    }
}
