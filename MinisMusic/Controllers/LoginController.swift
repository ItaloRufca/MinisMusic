//
//  LoginController.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 26/08/2018.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//


import UIKit
import Firebase

class LoginController: UIViewController, UITextFieldDelegate {
    
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let imageView: UIImageView = {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        let iv = UIImageView(frame: frame)
        iv.image = UIImage(named: "Fundo")?.withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    lazy var emailTextField: UITextField = {
        let screen = UIScreen.main.bounds
        let width = screen.width - 100
        let height: CGFloat = 45
        let x = screen.width / 2 - width / 2
        let y = screen.height / 2 - 2 * height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let tf = UITextField()
        tf.frame = frame
        tf.placeholder = "E-mail"
        tf.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.returnKeyType = .next
        tf.keyboardType = .emailAddress
        tf.tag = 0
        tf.textContentType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let screen = UIScreen.main.bounds
        let width = screen.width - 100
        let height: CGFloat = 45
        let x = screen.width / 2 - width / 2
        let y = screen.height / 2 + 8 - height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let tf = UITextField()
        tf.frame = frame
        tf.placeholder = "Password"
        tf.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.returnKeyType = .go
        tf.isSecureTextEntry = true
        tf.tag = 1
        tf.textContentType = .emailAddress
        return tf
    }()
    
    let logInButton: UIButton = {
        let screen = UIScreen.main.bounds
        let width = screen.width - 100
        let height: CGFloat = 45
        let x = screen.width / 2 - width / 2
        let y = screen.height / 2 + 16
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let btn = UIButton(type: .custom)
        btn.frame = frame
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.setTitle("Sign In / Sign Up", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        btn.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        btn.addTarget(self, action: #selector(touchDown), for: .touchDown)
        btn.addTarget(self, action: #selector(cancelTouch), for: .touchUpOutside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        _ = Auth.auth()
        
        view.addSubview(imageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(logInButton)
        
        toolbar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -80, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: nil)
    }
    
    @objc func keyboardWillHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func toolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton,doneButton], animated: false)
    
        emailTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
        
        
    }
    
    func loadingSpinner(){
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.style = .whiteLarge
        view.addSubview(spinner)
        
        self.emailTextField.isHidden = true
        self.passwordTextField.isHidden = true
        self.logInButton.isHidden = true
        self.dismissKeyboard()
        
        spinner.startAnimating()
    }
    
    func stopSpinner(){
        self.emailTextField.isHidden = false
        self.passwordTextField.isHidden = false
        self.logInButton.isHidden = false
        
        spinner.stopAnimating()
    }
    
    @objc func logIn(){
        UIView.animate(withDuration: 0.1, animations: {
            self.logInButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.logInButton.alpha = 0.7
        })
        
        self.loadingSpinner()
        
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            if error != nil {
                let alertController = UIAlertController(title: "E-mail or password is not correct.", message:
                    "Do you want create a new user?", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                alertController.addAction(UIAlertAction(title: "SignUp", style: UIAlertAction.Style.default, handler: self.register))
                self.present(alertController, animated: true, completion: nil)
                self.stopSpinner()
            }
            if user != nil {
                UserDefaults.standard.setIsLoggedIn(value: true)
                let homeController = MainNavigationController()
                self.present(homeController, animated: true, completion: nil)
            }
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.logInButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.logInButton.alpha = 1
        })
        
    }
    
    func register(alert: UIAlertAction){
        let createUser = CreateUserController()
        self.present(createUser, animated: true, completion: nil)
    }
    
    @objc func cancelTouch(){
        UIView.animate(withDuration: 0.1, animations: {
            self.logInButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.logInButton.alpha = 1
        })
    }
    @objc func touchDown(){
        UIView.animate(withDuration: 0.1, animations: {
            self.logInButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.logInButton.alpha = 0.7
        })
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            logIn()
        }
        return false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    
}
