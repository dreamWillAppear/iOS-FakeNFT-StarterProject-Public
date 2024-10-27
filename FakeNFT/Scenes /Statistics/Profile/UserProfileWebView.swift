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

    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()

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
        setupView()
        setupWebView()
        setupConstraints()
        setupNavBar()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.white

        view.addSubview(webView)
        view.addSubview(progressView)
    }
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.translatesAutoresizingMaskIntoConstraints = false

        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func setupNavBar() {
        backButton.setImage(UIImage(named: backButtonImageName), for: .normal)
        backButton.addTarget(self, action: #selector(closeWebView), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    @objc private func closeWebView() {
        dismiss(animated: true, completion: nil)
    }

    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}
