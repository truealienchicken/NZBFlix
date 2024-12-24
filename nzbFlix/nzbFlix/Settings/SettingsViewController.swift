import UIKit

class SettingsViewController: UIViewController {
    
    private let ipAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "IP Address"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ipAddressField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter IP Address"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let sonarrApiKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "Sonarr API Key"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sonarrApiKeyField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Sonarr API Key"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let radarrApiKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "Radarr API Key"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let radarrApiKeyField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Radarr API Key"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let nzbGeekApiKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "Nzb Geek API Key"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nzbGeekApiKeyField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Nzb Geek API Key"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let sabnzbdApiKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "SABnzbd API Key"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sabnzbdApiKeyField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter SABnzbd API Key"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
        setupLayout()
        setupActions()
        loadSettings()
    }
    
    private func setupLayout() {
        view.addSubview(ipAddressLabel)
        view.addSubview(ipAddressField)
        view.addSubview(sonarrApiKeyLabel)
        view.addSubview(sonarrApiKeyField)
        view.addSubview(radarrApiKeyLabel)
        view.addSubview(radarrApiKeyField)
        view.addSubview(nzbGeekApiKeyLabel)
        view.addSubview(nzbGeekApiKeyField)
        view.addSubview(sabnzbdApiKeyLabel)
        view.addSubview(sabnzbdApiKeyField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            ipAddressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ipAddressLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            ipAddressLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            ipAddressField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ipAddressField.topAnchor.constraint(equalTo: ipAddressLabel.bottomAnchor, constant: 8),
            ipAddressField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            sonarrApiKeyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sonarrApiKeyLabel.topAnchor.constraint(equalTo: ipAddressField.bottomAnchor, constant: 20),
            sonarrApiKeyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            sonarrApiKeyField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sonarrApiKeyField.topAnchor.constraint(equalTo: sonarrApiKeyLabel.bottomAnchor, constant: 8),
            sonarrApiKeyField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            radarrApiKeyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            radarrApiKeyLabel.topAnchor.constraint(equalTo: sonarrApiKeyField.bottomAnchor, constant: 20),
            radarrApiKeyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            radarrApiKeyField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            radarrApiKeyField.topAnchor.constraint(equalTo: radarrApiKeyLabel.bottomAnchor, constant: 8),
            radarrApiKeyField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            nzbGeekApiKeyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nzbGeekApiKeyLabel.topAnchor.constraint(equalTo: radarrApiKeyField.bottomAnchor, constant: 20),
            nzbGeekApiKeyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),

            nzbGeekApiKeyField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nzbGeekApiKeyField.topAnchor.constraint(equalTo: nzbGeekApiKeyLabel.bottomAnchor, constant: 8),
            nzbGeekApiKeyField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            sabnzbdApiKeyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sabnzbdApiKeyLabel.topAnchor.constraint(equalTo: nzbGeekApiKeyField.bottomAnchor, constant: 20),
            sabnzbdApiKeyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),

            sabnzbdApiKeyField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sabnzbdApiKeyField.topAnchor.constraint(equalTo: sabnzbdApiKeyLabel.bottomAnchor, constant: 8),
            sabnzbdApiKeyField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: sabnzbdApiKeyField.bottomAnchor, constant: 40)

        ])
    }
    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(didTapSave), for: .primaryActionTriggered)
    }
    
    private func loadSettings() {
        // Load saved values from UserDefaults
        let savedIpAddress = UserDefaults.standard.string(forKey: "ipAddress")
        let savedSonarrApiKey = UserDefaults.standard.string(forKey: "sonarrApiKey")
        let savedRadarrApiKey = UserDefaults.standard.string(forKey: "radarrApiKey")
        let savedSabnzbdApiKey = UserDefaults.standard.string(forKey: "sabnzbdApiKey")
        
        // Populate text fields with saved values if they exist
        ipAddressField.text = savedIpAddress
        sonarrApiKeyField.text = savedSonarrApiKey
        radarrApiKeyField.text = savedRadarrApiKey
        sabnzbdApiKeyField.text = savedSabnzbdApiKey
        
        let savedNzbGeekApiKey = UserDefaults.standard.string(forKey: "nzbGeekApiKey")
        nzbGeekApiKeyField.text = savedNzbGeekApiKey
    }
    
    @objc private func didTapSave() {
        // Save the input values to UserDefaults
        let ipAddress = ipAddressField.text ?? ""
        let sonarrApiKey = sonarrApiKeyField.text ?? ""
        let radarrApiKey = radarrApiKeyField.text ?? ""
        let sabnzbdApiKey = sabnzbdApiKeyField.text ?? ""
        let nzbGeekApiKey = nzbGeekApiKeyField.text ?? ""
        
        
        
        UserDefaults.standard.set(ipAddress, forKey: "ipAddress")
        UserDefaults.standard.set(sonarrApiKey, forKey: "sonarrApiKey")
        UserDefaults.standard.set(radarrApiKey, forKey: "radarrApiKey")
        UserDefaults.standard.set(sabnzbdApiKey, forKey: "sabnzbdApiKey")
        UserDefaults.standard.set(nzbGeekApiKey, forKey: "nabGeekApiKey")
        
        // Show confirmation dialog
        let alert = UIAlertController(title: "Settings Saved", message: "Your settings have been saved successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
