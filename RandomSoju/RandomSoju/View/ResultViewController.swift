//
//  SelectedPlaceViewController.swift
//  RandomSoju
//
//  Created by 원준연 on 2023/09/02.
//

import UIKit
import WebKit
import SnapKit

class ResultViewController: UIViewController {
    
    var containerView: UIView!
    var webViewGroup: UIView!
    var webView: WKWebView!
    var cancelButton: UIButton!
    var findWayButton: UIButton!
    
    var viewModel: ResultViewModel!
    
    weak var dismissDelegate: DismissDelegate?
    
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
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        webViewGroup.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        webView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.webViewGroup)
            make.height.equalTo(self.webViewGroup.snp.height).multipliedBy(0.9)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(self.webView.snp.bottom)
            make.leading.equalTo(self.webViewGroup.snp.leading)
            make.width.equalTo(self.webViewGroup.snp.width).multipliedBy(0.5)
            make.height.equalTo(self.webViewGroup.snp.height).multipliedBy(0.1)
        }
        
        findWayButton.snp.makeConstraints { make in
            make.top.equalTo(self.webView.snp.bottom)
            make.trailing.equalTo(self.webViewGroup.snp.trailing)
            make.width.equalTo(self.webViewGroup.snp.width).multipliedBy(0.5)
            make.height.equalTo(self.webViewGroup.snp.height).multipliedBy(0.1)
        }
        
        
        
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
        
        self.findWayButton.addTarget(self, action: #selector(findWayButtonTapped(sender:)), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped(sender:)), for: .touchUpInside)
        
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        
    }
    
    private func setupWebView() {
        guard let placeURL = self.viewModel.place?.placeURL else { return }
        let url = URL(string: placeURL)
        let urlRequst = URLRequest(url: url!)
        webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        webView.load(urlRequst)
        
        
    }
    
    @objc func cancelButtonTapped(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func findWayButtonTapped(sender: UIButton) {
        self.viewModel.findWayButtonTapped()
        self.dismissDelegate?.dismissAllViewControllers()
//        self.dismiss(animated: true)
    }
}

extension ResultViewController: WKNavigationDelegate, WKUIDelegate{
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Provisional Error: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Navigation Error: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")

    }
}

protocol DismissDelegate: AnyObject {
    func dismissAllViewControllers()
}
