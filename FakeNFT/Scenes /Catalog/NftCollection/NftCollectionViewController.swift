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
        let views = [cover, descriptionTextView, nftCollectionView]
        
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
            nftCollectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            nftCollectionView.heightAnchor.constraint(equalToConstant: 592)
        ])
    }
    
    //MARK: - Actions
    
    @objc private func didTapBackButton(){
        self.dismiss(animated: true)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegate

extension NftCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        15
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
