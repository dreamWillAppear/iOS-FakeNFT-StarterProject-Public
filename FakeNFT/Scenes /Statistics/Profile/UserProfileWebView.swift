//
//  ProfileWebView.swift
//  FakeNFT
//
//  Created by Александр  Сухинин on 24.10.2024.
//

import UIKit
import WebKit

final class UserProfileWebView: UIViewController, WKNavigationDelegate {
    private let backButtonImageName = "backwardButton"
    private let webView = WKWebView()
    private let urlString: String
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(url: String) {
        urlString = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        urlString = ""
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(webView)
        
        webView.navigationDelegate = self
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        backButton.setImage(UIImage(named: backButtonImageName), for: .normal)
        backButton.addTarget(self, action: #selector(closeWebView), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc func closeWebView() {
        dismiss(animated: true, completion: nil)
    }
}
