import UIKit
import CoreImage.CIFilterBuiltins

struct Movie {
    let title: String
    let description: String
    let imageURL: String
    let year: String
}

class nzbgeekViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var collectionView: UICollectionView!
    var movies: [Movie] = []
    var url = ""
    var radarr = false
    var sonarr = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        print("MoviesViewController")
        //view.backgroundColor = .black
        view.backgroundColor = .black

        // Set up the collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 500)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16

        // Initialize collection view
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(nzbgeekCell.self, forCellWithReuseIdentifier: "nzbgeekCell")
        collectionView.dataSource = self
        collectionView.delegate = self

        // Add the collection view to the view hierarchy
        view.addSubview(collectionView)

        // Set up constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Load movies from RSS
        fetchMovies()
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nzbgeekCell", for: indexPath) as! nzbgeekCell
        let movie = movies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        
        // Create an alert controller
        let alertController = UIAlertController(title: "Options", message: "What would you like to do?", preferredStyle: .actionSheet)
        
        // Add 'Trailer' action
        let trailerAction = UIAlertAction(title: "YouTube", style: .default) { _ in
            self.showTrailer(for: movie)
        }
        alertController.addAction(trailerAction)
        
        // Add 'Download Now' action
        let downloadAction = UIAlertAction(title: "Download Now", style: .default) { _ in
            self.downloadMovie(movie)
        }
        alertController.addAction(downloadAction)
        
        // Add 'Cancel' action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

    // Helper functions for actions
    private func showTrailer(for movie: Movie) {
        // Add a year property to Movie and use it in the query if available
        let searchQuery = movie.year.isEmpty ? movie.title : "\(movie.title) \(movie.year)"
        
        guard let query = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failed to encode movie title and year: \(searchQuery)")
            return
        }

        let youtubeWebURLString = "https://www.youtube.com/results?search_query=\(query)"

        // Present the QRCodeViewController modally
        let qrCodeViewController = QRCodeViewController()
        qrCodeViewController.urlString = youtubeWebURLString
        qrCodeViewController.modalPresentationStyle = .overFullScreen // Ensure modal presentation
        present(qrCodeViewController, animated: true, completion: {
            print("QRCodeViewController presented successfully") // Debug log
        })
    }
    
    private func downloadMovie(_ movie: Movie) {
        let searchResultsVC = SearchMediaResultsViewController()
        searchResultsVC.query = movie.title
        searchResultsVC.isRadarr = radarr
        searchResultsVC.isSonarr = sonarr
        searchResultsVC.searchHide = true
        
        // Push the SearchResultsViewController onto the navigation stack
        navigationController?.pushViewController(searchResultsVC, animated: true)
    }
    
    func fetchMovies() {
        let rssURL = URL(string: url)!

        let task = URLSession.shared.dataTask(with: rssURL) { data, response, error in
            if let error = error {
                print("Failed to fetch RSS: \(error)")
                return
            }

            guard let data = data else {
                print("No data received from RSS feed")
                return
            }

            // Parse the RSS feed
            let parser = RSSParser()
            let fetchedMovies = parser.parse(data: data)
            //print("fetchedMovies")
            //print(fetchedMovies)

            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.movies = fetchedMovies
                self.collectionView.reloadData()
            }
        }
        task.resume()
    }



}
