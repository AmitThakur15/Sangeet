//
//  AuthViewController.swift
//  Spotify_Tut
//
//  Created by Aniket Kumar Thakur on 10/07/21.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    public var completionHandler: ((Bool) -> Void)?
    
    let theWebView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        theWebView.navigationDelegate = self
        setupWebView()
    }
    
    func setupWebView()  {
        view.addSubview(theWebView)
        theWebView.translatesAutoresizingMaskIntoConstraints = false
        theWebView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        theWebView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        theWebView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        theWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        guard let signInUrl = AuthManager.shared.signInURL else {
            return
        }
        theWebView.load(URLRequest(url: signInUrl))
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        //exchange code for the access token
        
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: {$0.name == "code"})?.value else {
            return
        }
        webView.isHidden = true
        print("The exchange code is --> \(code)")
        AuthManager.shared.exchangeTheCodeForToken(code: code) {[weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
           
            
        }
    }


}
