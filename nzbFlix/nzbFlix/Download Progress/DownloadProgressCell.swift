import UIKit

class DownloadProgressCell: UITableViewCell {
    
    static let identifier = "DownloadProgressCell"
    
    private let nameLabel = UILabel()
    private let statusLabel = UILabel()
    private let progressLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let grayColor = UIColor.systemGray

        // Apply gray text color
        nameLabel.textColor = grayColor
        statusLabel.textColor = grayColor
        progressLabel.textColor = grayColor

        // Optional font settings
        nameLabel.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        progressLabel.textAlignment = .center

        // Use a container stack view
        let stackView = UIStackView(arrangedSubviews: [nameLabel, statusLabel, progressLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.distribution = .fillProportionally

        // Add the stack view to contentView
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Set proportional widths for each label
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        statusLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        progressLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        // Constraints for stack view
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with download: NZBGetDownload) {
        // Calculate progress
        let progress = Double(download.downloadedSizeMB) / Double(download.fileSizeMB) * 100
        let progressText = String(format: "%.2f%%", progress)
        
        // Assign values to labels
        nameLabel.text = download.name
        statusLabel.text = download.status
        progressLabel.text = progressText
    }
}
