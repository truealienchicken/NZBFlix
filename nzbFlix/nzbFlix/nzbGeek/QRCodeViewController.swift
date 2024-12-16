import UIKit
import CoreImage.CIFilterBuiltins

class QRCodeViewController: UIViewController {
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8) // Dim background

        // Container view for all content
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        // Title label
        let titleLabel = UILabel()
        titleLabel.text = "Watch Trailer"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)

        // Description label
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Scan this QR code on your phone to open YouTube."
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .black
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)

        // QR code image view
        let qrCodeImageView = UIImageView()
        if let qrCode = generateQRCode(from: urlString ?? "") {
            qrCodeImageView.image = qrCode
        }
        qrCodeImageView.contentMode = .scaleAspectFit
        qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(qrCodeImageView)

        // Layout Constraints
        NSLayoutConstraint.activate([
            // Container constraints
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 340),

            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // Description label constraints
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // QR code image view constraints
            qrCodeImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            qrCodeImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            qrCodeImageView.widthAnchor.constraint(equalToConstant: 200),
            qrCodeImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .ascii)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            return UIImage(ciImage: scaledImage)
        }
        return nil
    }
}
