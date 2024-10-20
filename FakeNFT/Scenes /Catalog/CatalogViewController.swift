import UIKit

protocol CatalogViewProtocol: AnyObject {
    func reloadData()
}

final class CatalogViewController: UIViewController, CatalogViewProtocol {
    
    // MARK: - Private Properties
    
    private let presenter: CatalogPresenterProtocol
    
    lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        var image = UIImage(named: "filter.button")?.withTintColor(.ypBlack ?? .black, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var nftCollectionTableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        return table
    }()
    
    //MARK: - Init
    
    init(presenter: CatalogPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nftCollectionTableView.delegate = self
        nftCollectionTableView.dataSource = self
        nftCollectionTableView.register(CatalogTableCell.self, forCellReuseIdentifier: CatalogTableCell.reuseIdentifier)
        
        presenter.onViewDidLoad()
        setupUI()
    }
    
    // MARK: - Public Methods
    
    func reloadData() {
        nftCollectionTableView.reloadData()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        let views =  [filterButton, nftCollectionTableView]
        
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
            filterButton.heightAnchor.constraint(equalToConstant: 44),
            
            nftCollectionTableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 18),
            nftCollectionTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            nftCollectionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftCollectionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getCollectionCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        187
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cover = presenter.getCollectionCover(at: indexPath.row)
        let label = presenter.getCollectionLabel(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableCell.reuseIdentifier, for: indexPath) as? CatalogTableCell
        
        cell?.setupCell(cover: cover, label: label)
        
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionPresenter = NftCollectionPresenter(view: nil)
        let collectionViewController = NftCollectionViewController(presenter: collectionPresenter)
        collectionPresenter.setView(collectionViewController)
    
        collectionViewController.modalPresentationStyle = .fullScreen
        present(collectionViewController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
