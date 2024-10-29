import UIKit

protocol NftCollectionViewProtocol: AnyObject {
    func setLoadingViewVisible(_ visible: Bool)
    func displayLoadedData()
    func reloadData()
}

final class NftCollectionViewController: UIViewController, NftCollectionViewProtocol, LoadingView, ErrorView  {
    
    //MARK: - Public Prioperties
    
    lazy var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Private Properties
    
    private let presenter: NftCollectionPresenterProtocol?
    
    private lazy var collection = presenter?.getCollection()
    
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
        cover.contentMode = .scaleAspectFill
        cover.layer.masksToBounds = true
        cover.layer.cornerRadius = 12
        return cover
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.backward")?.withTintColor(.ypBlack ?? .black).withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapBackButton),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textAlignment = .left
        textView.dataDetectorTypes = [.link]
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private lazy var nftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NftCollectionViewCell.self, forCellWithReuseIdentifier: NftCollectionViewCell.reuseIdentifier)
        
        return collectionView
    }()
    
    //MARK: - Init
    
    init(presenter: NftCollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Public Methods
    
    func reloadData() {
        updateCollectionViewHeight()
        nftCollectionView.reloadData()
    }
    
    func displayLoadedData() {
        guard let collection = collection else {
            print("LOG ERROR NftCollectionViewController: collection for UI is nil")
            return
        }
        
        cover.kf.setImage(with: collection.cover)
        setDescription(
            title: collection.name,
            author: collection.authorName,
            description: collection.description
        )
    }
    
    func setLoadingViewVisible(_ visible: Bool) {
        DispatchQueue.main.async { [weak self] in
            visible ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        
        let views = [cover, descriptionTextView, nftCollectionView, activityIndicator]
        
        view.backgroundColor = .ypWhite
        
        view.addSubview(mainScrollView)
        view.addSubview(backButton)
        mainScrollView.addSubview(mainStackView)
        
        setupMainStackView(for: views)
        setupLayout(for: views)
    }
    
    private func setupMainStackView(for views: [UIView]) {
        views.forEach {
            mainStackView.addArrangedSubview($0)
        }
    }
    
    private func setupLayout(for views: [UIView]) {
        let window = UIApplication.shared.windows.first
        let windowSafeAreaTopInset = window?.safeAreaInsets.top ?? 50
        backButton.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            
            mainScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainStackView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor, constant: -windowSafeAreaTopInset),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),
            
            cover.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            cover.heightAnchor.constraint(equalToConstant: 310),
            cover.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            cover.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: cover.bottomAnchor, constant: 16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 136),
            descriptionTextView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            
            nftCollectionView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            nftCollectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
            nftCollectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setDescription(title: String, author: String, description: String) {
        let authorString = "Автор коллекции: "
        let descriptionText = "\(title)\n\n\(authorString)\(author)\n\(description)"
        
        let attributedText = NSMutableAttributedString(string: descriptionText)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.16
        
        let descriptionTextRange = (descriptionText as NSString).range(of: descriptionText)
        attributedText.addAttribute(.kern, value: -0.08, range: descriptionTextRange)
        
        let titleRange = (descriptionText as NSString).range(of: title)
        attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 22), range: titleRange)
        
        let authorStringRange = (descriptionText as NSString).range(of: authorString)
        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .regular), range: authorStringRange)
        
        let authorRange = (descriptionText as NSString).range(of: author)
        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: authorRange)
        attributedText.addAttribute(.link, value: "https://practicum.yandex.ru/ios-developer/", range: authorRange)
        attributedText.addAttribute(.foregroundColor, value: UIColor.blue, range: authorRange)
        attributedText.addAttribute(.kern, value: 0.2, range: authorRange)
        
        let descriptionRange = (descriptionText as NSString).range(of: description)
        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 13, weight: .regular), range: descriptionRange)
        
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        descriptionTextView.attributedText = attributedText
    }
    
    private func updateCollectionViewHeight()  {
        let itemsCount = presenter?.getNftsCount() ?? 0
        let itemsPerRow = 3
        let cellHeight: CGFloat = 192
        let minimumLineSpacing: CGFloat = 9
        let numberOfRows = ceil(Double(itemsCount) / Double(itemsPerRow))
        let totalHeight = CGFloat(numberOfRows) * cellHeight + CGFloat(numberOfRows - 1) * minimumLineSpacing
        
        nftCollectionView.constraints.forEach {
            if $0.firstAttribute == .height {
                $0.isActive = false
            }
        }
        
        NSLayoutConstraint.activate([
            nftCollectionView.heightAnchor.constraint(equalToConstant: totalHeight)
        ])
    }
    
    //MARK: - Actions
    
    @objc private func didTapBackButton(){
        self.dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension NftCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.getNftsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard  let nftsForView = presenter?.getNftsForView().sorted(by: { $0.name < $1.name } ),
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NftCollectionViewCell.reuseIdentifier, for: indexPath) as? NftCollectionViewCell else {
            return .init()
        }
        
        let nft = nftsForView[indexPath.row]
        
        cell.configureCell(
            cover: nft.cover,
            name: nft.name,
            isLiked: nft.isLiked,
            raitng: nft.raiting,
            price: nft.price,
            isInCart: nft.isInCart
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //согласно макету имеем сумму расстояния между ячейками 19, вычитаем из общей ширины collectionView и делим на количество ячеек
        let allSpacing: CGFloat = 19
        let width = (collectionView.bounds.width - allSpacing) / 3
        return CGSize(width: width, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
}
