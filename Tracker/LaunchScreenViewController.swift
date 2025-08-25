import UIKit

final class LaunchScreenViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLogo()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "YP_Blue")
        view.addSubview(logoImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            logoImageView.widthAnchor.constraint(equalToConstant: 91),
            logoImageView.heightAnchor.constraint(equalToConstant: 94)
        ])
    }
    
    private func animateLogo() {
        logoImageView.alpha = 0
        logoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut) {
            self.logoImageView.alpha = 1
            self.logoImageView.transform = .identity
        }
    }
}
