import UIKit

final class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    private let backgroundImage: UIImage?
    private let titleText: String
    private let buttonTitle: String
    var onButtonTap: (() -> Void)?
    
    // MARK: - Initialization
    init(backgroundImage: UIImage?, titleKey: String, buttonTitleKey: String) {
        self.backgroundImage = backgroundImage
        self.titleText = NSLocalizedString(titleKey, comment: "")
        self.buttonTitle = NSLocalizedString(buttonTitleKey, comment: "")
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Constants
    private enum Constants {
        static let titleFontSize: CGFloat = 32
        static let buttonFontSize: CGFloat = 16
        static let buttonCornerRadius: CGFloat = 16
        static let buttonHeight: CGFloat = 60
        static let buttonHorizontalMargin: CGFloat = 20
        static let buttonWidth: CGFloat = 335
        static let horizontalPadding: CGFloat = 16
        static let titleTopOffset: CGFloat = 24
        static let buttonBottomOffset: CGFloat = -50
        
        static let buttonContentInsets = UIEdgeInsets(top: 19, left: 32, bottom: 19, right: 32)
    }
    
    // MARK: - UI Elements
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = backgroundImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleText
        label.font = UIFont.systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        label.textColor = UIColor(resource: .ypBlackDay)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        
        if let paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle {
            paragraphStyle.lineSpacing = 0
            paragraphStyle.alignment = .center
            label.attributedText = NSAttributedString(
                string: titleText,
                attributes: [.paragraphStyle: paragraphStyle]
            )
        } else {
            label.text = titleText
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .ypBlackDay
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.buttonFontSize, weight: .medium)
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.layer.masksToBounds = true
        
        button.addAction(UIAction { [weak self] _ in
            self?.buttonTapped()
        }, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(backgroundImage: UIImage?, title: String, buttonTitle: String) {
        self.backgroundImage = backgroundImage
        self.titleText = title
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            // Background image constraints
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Title label constraints
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.horizontalPadding),
            titleLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: Constants.titleTopOffset),
            
            // Action button constraints
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonHorizontalMargin),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.buttonHorizontalMargin),
            actionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.buttonBottomOffset)
        ])
    }
    
    // MARK: - Actions
    private func buttonTapped() {
        onButtonTap?()
    }
}
