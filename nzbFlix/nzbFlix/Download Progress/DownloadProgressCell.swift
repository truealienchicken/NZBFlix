import UIKit

class DownloadProgressCell: UITableViewCell {
    static let identifier = "DownloadProgressCell"
    
    private let nameLabel = UILabel()
    private let statusLabel = UILabel()
    private let progressLabel = UILabel()
    private let etaLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let grayColor = UIColor.systemGray
        
        [nameLabel, statusLabel, progressLabel, etaLabel].forEach { label in
            label.textColor = grayColor
        }
        
        nameLabel.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        progressLabel.textAlignment = .center
        etaLabel.textAlignment = .right
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, statusLabel, progressLabel, etaLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        statusLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        progressLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        etaLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with download: SABnzbdDownload) {
        nameLabel.text = download.filename
        statusLabel.text = download.status
        progressLabel.text = "\(download.percentage)%"
        etaLabel.text = download.timeleft
    }
}
