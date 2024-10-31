import UIKit
import WebKit

final class NftCollectionWebViewViewController: UIViewController {
    
    //MARK: - Public Properties
    
    private let url: URL
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        
        return webView
    } ()
    
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
    
    // MARK: - Init
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url))
        setupUI()
    }
    
    //MARK: - Private Methods
    
    private func setupUI() {
        view = webView
        view.addSubview(backButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55)
        ])
    }
    
    @objc private func didTapBackButton() {
        self.dismiss(animated: true)
    }
    
}
