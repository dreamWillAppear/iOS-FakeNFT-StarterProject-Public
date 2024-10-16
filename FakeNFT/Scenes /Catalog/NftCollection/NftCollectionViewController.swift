import UIKit

protocol NftCollectionViewProtocol: AnyObject {
    func reloadData()
    func setCover(image: UIImage)
    func setName(_ name: String)
    func setAuthorName(_ name: String)
    func setDescription(_ text: String)
}

final class NftCollectionViewController: UIViewController, NftCollectionViewProtocol {
    
    // MARK: - Private Properties
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var cover: UIImageView = {
        let cover = UIImageView()
        cover.image = UIImage(named: "MokeCoverPink")
        cover.contentMode = .scaleAspectFill
        cover.layer.masksToBounds = true
        cover.layer.cornerRadius = 12
        return cover
    }()
        
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Public Methods
    
    func reloadData() {
        
    }
    
    func setCover(image: UIImage) {
        
    }
    
    func setName(_ name: String) {
        
    }
    
    func setAuthorName(_ name: String) {
        
    }
    
    func setDescription(_ text: String) {
        
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        let views = [cover]
        
        view.backgroundColor = .ypWhite
        
        view.addSubview(mainStackView)
        
        setupMainStackView(for: views)
        setupLayout(for: views)
    }
    
    private func setupMainStackView(for views: [UIView]) {
        views.forEach {
            mainStackView.addSubview($0)
        }
    }
    
    private func setupLayout(for views: [UIView]) {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cover.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            cover.heightAnchor.constraint(equalToConstant: 310),
            cover.leadingAnchor.constraint(equalTo:mainStackView.leadingAnchor),
            cover.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
        ])
    }
    
}
