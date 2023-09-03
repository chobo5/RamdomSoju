//
//  SelectedPlaceViewController.swift
//  RandomSoju
//
//  Created by 원준연 on 2023/09/02.
//

import UIKit
import WebKit

class ResultViewController: UIViewController {
    
    var containerView: UIView!
    var webViewGroup: UIView!
    var webView: WKWebView!
    var cancelButton: UIButton!
    var findWayButton: UIButton!
    
    var viewModel: ResultViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupWebView()
        
    }
    
    private func setupView() {
        self.containerView = UIView()
        self.webViewGroup = UIView()
        self.webView = WKWebView()
        self.cancelButton = UIButton()
        self.findWayButton = UIButton()
        
        self.view.addSubview(containerView)
        self.view.addSubview(webViewGroup)
        self.webViewGroup.addSubview(webView)
        self.webViewGroup.addSubview(cancelButton)
        self.webViewGroup.addSubview(findWayButton)
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.webViewGroup.translatesAutoresizingMaskIntoConstraints = false
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.findWayButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.webViewGroup.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.webViewGroup.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.webViewGroup.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            self.webViewGroup.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6)
        ])
        
        NSLayoutConstraint.activate([
            self.webView.topAnchor.constraint(equalTo: self.webViewGroup.topAnchor),
            self.webView.leadingAnchor.constraint(equalTo: self.webViewGroup.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.webViewGroup.trailingAnchor),
            self.webView.heightAnchor.constraint(equalTo: self.webViewGroup.heightAnchor, multiplier: 0.9)
        ])
        
        NSLayoutConstraint.activate([
            self.cancelButton.topAnchor.constraint(equalTo: self.webView.bottomAnchor),
            self.cancelButton.leadingAnchor.constraint(equalTo: self.webViewGroup.leadingAnchor),
            self.cancelButton.widthAnchor.constraint(equalTo: self.webViewGroup.widthAnchor, multiplier: 0.5),
            self.cancelButton.heightAnchor.constraint(equalTo: self.webViewGroup.heightAnchor, multiplier: 0.1)
        ])
        
        NSLayoutConstraint.activate([
            self.findWayButton.topAnchor.constraint(equalTo: self.webView.bottomAnchor),
            self.findWayButton.trailingAnchor.constraint(equalTo: self.webViewGroup.trailingAnchor),
            self.findWayButton.widthAnchor.constraint(equalTo: self.webViewGroup.widthAnchor, multiplier: 0.5),
            self.findWayButton.heightAnchor.constraint(equalTo: self.webViewGroup.heightAnchor, multiplier: 0.1)
        ])
        
        self.containerView.backgroundColor = .black
        self.containerView.alpha = 0.5
        
        self.webViewGroup.layer.cornerRadius = 20
        self.webViewGroup.clipsToBounds = true
        
        self.cancelButton.backgroundColor = UIColor.rouletteBlue4 ?? UIColor.gray
        self.cancelButton.setTitle("취소", for: .normal)
        self.cancelButton.setTitleColor(.black, for: .normal)
        
        self.findWayButton.backgroundColor = UIColor.rouletteBlue ?? UIColor.blue
        self.findWayButton.setTitle("길찾기", for: .normal)
        self.findWayButton.setTitleColor(.black, for: .normal)
        
        
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped(sender:)), for: .touchUpInside)
        
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        
    }
    
    private func setupWebView() {
        guard let placeURL = self.viewModel.place?.placeURL else { return }
        let safePlaceURL = placeURL.replacingOccurrences(of: "http", with: "https")

        let url = URL(string: placeURL)
        print("fasdf",url)
        let urlRequst = URLRequest(url: url!)
        webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        webView.load(urlRequst)
        
        
    }
    
    @objc func cancelButtonTapped(sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension ResultViewController: WKNavigationDelegate, WKUIDelegate{
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Provisional Error: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Navigation Error: \(error.localizedDescription)")
    }
}
