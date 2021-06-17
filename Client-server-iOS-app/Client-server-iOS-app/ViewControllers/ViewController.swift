//
//  ViewController.swift
//  Client-server-iOS-app
//
//  Created by Илья Лебедев on 17.06.2021.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var vkImage: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let session = Session.instance //синглтон для хранения данных о текущей сессии

    override func viewDidLoad() {
        super.viewDidLoad()
        //делегаты для переноса фокуса на следующее поле ввода
        self.loginTextField.delegate = self
        self.passwordTextField.delegate = self
        // клик по любому месту scrollView для скрытия клавиатуры - Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // Присваиваем его UIScrollVIew
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Подпишемся на появление/ пропадание клавиатуры
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - функции
    // Когда клавиатура появляется
    @objc func keyboardWillShow (notification: Notification) {
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let keyboardSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        scrollView?.contentInset = contentInset
        scrollView?.scrollIndicatorInsets = contentInset
    }
    
    // Убираем отступ, когда клавиатура исчезает
    @objc func keyboardWasHide(notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        scrollView?.contentInset = contentInset
    }
    
    //клик по любому месту для скрытия клавиатуры (scrollView)
    @objc func hideKeyboard() {
        scrollView.endEditing(true)
    }
    
    // переход на следующий textField
    func textFieldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            pressLoginButton(self)
        }
        return true
    }
    
    //MARK: - Action
    @IBAction func pressLoginButton(_ sender: Any) {
        //кнопка авторизации
        guard loginTextField.text == "" && passwordTextField.text == "" else {
            //создадим контроллер для ошибки
            let alert = UIAlertController(title: "Error!", message: "Incorrect login or password", preferredStyle: .alert)
            //добавим кнопку для UIAlertController
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            //Покажем UIAlerController
            present(alert, animated: true, completion: nil)
            return
        }
        performSegue(withIdentifier: "loginAutorizationSegue", sender: nil)
    }
}
    //MARK: - Extension
extension ViewController: UITextFieldDelegate {
    
}
