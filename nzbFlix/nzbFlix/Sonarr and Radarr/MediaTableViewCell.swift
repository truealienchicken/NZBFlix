import UIKit
import SDWebImage

class MediaTableViewCell: UITableViewCell {
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let yearLabel = UILabel()
    let posterImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Configure image view
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        contentView.addSubview(posterImageView)
        
        // Configure title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18) // Bigger font size
        titleLabel.numberOfLines = 2 // Allow multiline for longer titles
        titleLabel.textColor = .gray
        contentView.addSubview(titleLabel)
        
        // Configure description label
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 16) // Bigger font size
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 3 // Allow multiline for descriptions
        contentView.addSubview(descriptionLabel)
        
        // Configure year label
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.font = UIFont.systemFont(ofSize: 16) // Bigger font size
        yearLabel.textColor = .gray
        contentView.addSubview(yearLabel)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // Poster image constraints
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.widthAnchor.constraint(equalToConstant: 100), // Increased width
            posterImageView.heightAnchor.constraint(equalToConstant: 150), // Increased height
            
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            // Description label constraints
            descriptionLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            // Year label constraints
            yearLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 15),
            yearLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            yearLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with media: MediaResult) {
        titleLabel.text = media.title
        descriptionLabel.text = media.overview ?? "No description available."
        yearLabel.text = media.year != nil ? "\(media.year!)" : "Year unknown"
        
        // Load the image using SDWebImage
        if let imageUrl = media.images?.first(where: { $0.coverType == "poster" })?.remoteUrl {
            posterImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
        } else {
            posterImageView.image = UIImage(named: "placeholder") // Optional placeholder image
        }
    }
}
