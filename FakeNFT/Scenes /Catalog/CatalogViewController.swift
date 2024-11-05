import UIKit

protocol CatalogViewProtocol: AnyObject {
    func reloadData()
    func setLoadingViewVisible(_ visible: Bool)
    func showNetworkError()
}

final class CatalogViewController: UIViewController, CatalogViewProtocol, LoadingView, ErrorView {
    
    // MARK: - Public Properties
    
    lazy var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Private Properties
    
    private let presenter: CatalogPresenterProtocol
    
    lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        var image = UIImage(named: "filter.button")?.withTintColor(.ypBlack ?? .black, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
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
    
    func  setLoadingViewVisible(_ visible: Bool) {
        visible ? showLoading() : hideLoading()
    }
    
    func showNetworkError() {
        let error = ErrorModel(
            message: "Не удалось получить данные",
            actionText: "Повторить",
            action: presenter.onViewDidLoad
        )
        showError(error)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        let views =  [filterButton, nftCollectionTableView, activityIndicator]
        
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
            nftCollectionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showSelectFilterAlert()  {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let sortByNameAction = UIAlertAction(title: "По названию", style: .default) { [weak presenter] _ in
            presenter?.sortByName()
        }
        
        let sortByCountAction = UIAlertAction(title: "По количеству NFT", style: .default) { [weak presenter] _ in
            presenter?.sortByCount()
        }
        
        let closeAlertAction =  UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        
        [sortByNameAction, sortByCountAction, closeAlertAction].forEach {
            alert.addAction($0)
        }
        
        present(alert, animated: true)
    }
    
    //MARK: - Actions
    
    @objc private func didTapFilterButton() {
        showSelectFilterAlert()
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
        let coverURL = presenter.getCollectionCoverURL(at: indexPath.row)
        let label = presenter.getCollectionLabel(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableCell.reuseIdentifier, for: indexPath) as? CatalogTableCell
        
        cell?.setupCell(coverURL: coverURL, label: label)
        
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionId = presenter.getCollectionId(at: indexPath.row)
        let collectionPresenter = NftCollectionPresenter(view: nil, collectionId: collectionId)
        let collectionViewController = NftCollectionViewController(presenter: collectionPresenter)
        collectionPresenter.setView(collectionViewController)
        
        collectionViewController.modalPresentationStyle = .fullScreen
        present(collectionViewController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
