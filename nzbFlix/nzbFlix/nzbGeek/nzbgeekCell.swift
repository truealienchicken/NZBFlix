import UIKit

class nzbgeekCell: UICollectionViewCell {
    let imageView = UIImageView()
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .darkGray
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        // Configure image view
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        // Configure title label
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 3 // Allow up to 3 lines
        titleLabel.lineBreakMode = .byTruncatingTail // Truncate if text exceeds 3 lines
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        // Add constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -4)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: Movie) {
        // Use a regular expression to remove years (e.g., "2023")
        let modifiedTitle = movie.title.replacingOccurrences(of: "\\b\\d{4}\\b", with: "", options: .regularExpression)
        titleLabel.text = modifiedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let url = URL(string: movie.imageURL) {
            // Load image asynchronously
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }

    // Handle focus updates
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if isFocused {
            // Apply focus visual changes
            contentView.layer.borderWidth = 5
            contentView.layer.borderColor = UIColor.systemYellow.cgColor
            contentView.backgroundColor = .darkGray
        } else {
            // Revert to default appearance
            contentView.layer.borderWidth = 0
            contentView.backgroundColor = .darkGray
        }
    }
}
