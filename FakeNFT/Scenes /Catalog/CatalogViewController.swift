import UIKit

protocol CatalogViewProtocol: AnyObject {
    func reloadData()
    func setFooter(text: String)
    func setCover(image: UIImage)
}

final class CatalogViewController: UIViewController, CatalogViewProtocol {
    
    // MARK: - Private Properties
    
    lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        var image = UIImage(named: "filter.button")?.withTintColor(.ypBlack ?? .black, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Public Methods
    
    func reloadData() {
        
    }
    
    func setFooter(text: String) {
        
    }
    
    func setCover(image: UIImage) {
        
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        let views =  [filterButton]
        
        view.backgroundColor = .ypWhite
        
        views.forEach {
            view.addSubview($0)
        }
        
        setupLayout(for: views)
    }
    
    private func setupLayout(for views: [UIView]) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 46),
            filterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12.5),
            filterButton.widthAnchor.constraint(equalToConstant: 44),
            filterButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
