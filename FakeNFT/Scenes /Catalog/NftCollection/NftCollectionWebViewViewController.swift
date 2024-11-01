import UIKit
import WebKit

final class NftCollectionWebViewViewController: UIViewController {
    
    //MARK: - Public Properties
    
    private let url: URL
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        
        return webView
    } ()
    
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
        view.addSubview(webView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward")?.withTintColor(.ypBlackUniversal ?? .black).withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton)
        )
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func didTapBackButton() {
        self.dismiss(animated: true)
    }
    
}
