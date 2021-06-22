//
//  AuthViewController.swift
//  vk-api
//
//  Created by Илья Лебедев on 22.06.2021.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //oauthAuthorizationToVK
        authorizeToVK()
    }
    
    //TODO: - Пожелание -- оформить сервис AuthService
    
    func authorizeToVK() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7822904"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "270342"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "revoke", value: "1"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
    }
    
    //MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html",
              let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        //TODO: Расписать этот код
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        //TODO: Отслеживать протухание токена
        if  let token = params["access_token"], let userId = params["user_id"] {
            print("TOKEN = ", token as Any)
            Session.shared.token = token
            Session.shared.userId = userId
            
            showMainTabBar()
            
            
        }
        
        decisionHandler(.cancel)
    }
    
    //MARK:
    func showMainTabBar(){
        performSegue(withIdentifier: "showFriendsSegue", sender: nil)
    }
    
}
extension AuthViewController: WKNavigationDelegate {
    
}
