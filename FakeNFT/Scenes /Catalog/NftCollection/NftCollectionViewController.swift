import UIKit

protocol NftCollectionViewProtocol: AnyObject {
    func reloadData()
    func setCover(image: UIImage)
    func setDescription(title: String, author: String, description: String)
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
    
    private lazy var nftCollecionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 9
        layout.itemSize = CGSize(width: 108, height: 192)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NftCollectionViewCell.self, forCellWithReuseIdentifier: NftCollectionViewCell.reuseIdentifier)
        
        return collectionView
    }()
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDescription(title: "Peach", author: "John Doe", description: "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей.")
        
        setupUI()
    }
    
    // MARK: - Public Methods
    
    func reloadData() {
        
    }
    
    func setCover(image: UIImage) {
        
    }
    
    func setDescription(title: String, author: String, description: String) {
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
    
    // MARK: - Private Methods
    
    private func setupUI() {
        let views = [cover, descriptionTextView, nftCollecionView]
        
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
            
            descriptionTextView.topAnchor.constraint(equalTo: cover.bottomAnchor, constant: 16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 136),
            descriptionTextView.leadingAnchor.constraint(equalTo:mainStackView.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            
            nftCollecionView.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            nftCollecionView.leadingAnchor.constraint(equalTo:mainStackView.leadingAnchor, constant: 16),
            nftCollecionView.trailingAnchor.constraint(equalTo:mainStackView.trailingAnchor, constant: -16),
            nftCollecionView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegate

extension NftCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NftCollectionViewCell.reuseIdentifier, for: indexPath) as? NftCollectionViewCell else {
            return .init()
        }
        
        cell.configureCell(
            cover: UIImage(named: "MokeCellArchie")!,
            name: "Archie",
            isLiked: false,
            raitng: 2,
            price: 22.56,
            isInCart: false
        )
        
        return cell
    }
}
