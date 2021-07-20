//
//  AuthViewController.swift
//  vk-api
//
//  Created by Илья Лебедев on 22.06.2021.
//

import UIKit
import WebKit
import FirebaseDatabase

class AuthViewController: UIViewController {
    
    var session = Session.shared
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
    
    func removeCookie() {
        let cookieStore = webView.configuration.websiteDataStore.httpCookieStore
        
        cookieStore.getAllCookies { cookies in
            for cookie in cookies {
                cookieStore.delete(cookie)
            }
        }
    }
    
    //MARK: - WKNavigationDelegate
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//
//        guard let url = navigationResponse.response.url, url.path == "/blank.html",
//              let fragment = url.fragment  else {
//            decisionHandler(.allow)
//            return
//        }
//
//        //TODO: Расписать этот код
//        let params = fragment
//            .components(separatedBy: "&")
//            .map { $0.components(separatedBy: "=") }
//            .reduce([String: String]()) { result, param in
//                var dict = result
//                let key = param[0]
//                let value = param[1]
//                dict[key] = value
//                return dict
//            }
//        //TODO: Отслеживать протухание токена
//        if  let token = params["access_token"], let userId = params["user_id"], let expiresIn = params["expires_in"] {
//            print("TOKEN = ", token as Any)
//            self.session.token = token
//            self.session.userId = Int(userId) ?? 0
//            self.session.expiredDate = Date(timeIntervalSinceNow: TimeInterval(Int(expiresIn) ?? 0))
//
//            showMainTabBar()
//
//
//        }
//
//        decisionHandler(.cancel)
//    }
//
//    //MARK:
//    func showMainTabBar(){
//        performSegue(withIdentifier: "showFriendsSegue", sender: nil)
//    }
//
}

//MARK: - extension

extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        // проверка на полученый адрес и получение данных из урла
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        //print(fragment)
        
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
        
        //DispatchQueue.main.async {
            if let token = params["access_token"], let userID = params["user_id"], let expiresIn = params["expires_in"] {
                self.session.token = token
                self.session.userId = Int(userID) ?? 0
                self.session.expiredDate = Date(timeIntervalSinceNow: TimeInterval(Int(expiresIn) ?? 0))
                
//                showMainTabBar()
                
                decisionHandler(.cancel)
                 
                writeUserToFirebase(userID)
                //testWriteFireBase(userID)
                
                // переход на контроллер с логином и вход в приложение при успешной авторизации
                self.performSegue(withIdentifier: "AuthVKSuccessful", sender: nil)
//            } else {
//                decisionHandler(.allow)
//                // просто переход на контроллер с логином при неуспешной авторизации
//                self.performSegue(withIdentifier: "AuthVKUnsuccessful", sender: nil)
//            }
        }
    }
    
//    func showMainTabBar(){
//        performSegue(withIdentifier: "showFriendsSegue", sender: nil)
//    }
    //MARK: - Firebase
    private func writeUserToFirebase(_ userID: String){
        // работаем с Firebase
        let database = Database.database()
        let ref: DatabaseReference = database.reference(withPath: "All logged users")
        
        // чтение из Firebase
        ref.observe(.value) { snapshot in
            let users = snapshot.children.compactMap { $0 as? DataSnapshot }
            let keys = users.compactMap { $0.key }
            
            // проверка, что пользователь уже записан в Firebase
            guard keys.contains(userID) == false else {
                ref.removeAllObservers() // отписываемся от уведомлений, чтобы не происходила запись  при изменении базы
                
                let user = snapshot.childSnapshot(forPath: userID).value
                //let user = snapshot.children
                print("Текущий пользователь с ID \(userID) добавил следующие группы:\n\(user ?? "")")
                
    //                let value = users.compactMap { $0.value }
    //                print("Пользователь: \(userID) добавил следующие группы: \(value)")
                return
            }
            
            // пишем нового пользователя если его нет в Firebase
            ref.child(userID).setValue("нет добавленных групп")
            print("В Firebase записан новый пользователь, ID: \(userID)")
        }
    }
}
