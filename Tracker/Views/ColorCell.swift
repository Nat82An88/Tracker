import UIKit

final class ColorCell: UICollectionViewCell {
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with colorName: String, isSelected: Bool) {
        colorView.backgroundColor = UIColor(named: colorName)
        
        if isSelected {
            contentView.layer.borderWidth = 3
            contentView.layer.borderColor = UIColor(named: colorName)?.withAlphaComponent(0.3).cgColor
            contentView.layer.cornerRadius = 8
        } else {
            contentView.layer.borderWidth = 0
            contentView.layer.cornerRadius = 0
        }
    }
}
