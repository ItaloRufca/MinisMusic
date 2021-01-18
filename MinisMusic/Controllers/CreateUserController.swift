//
//  CreateUserControllerViewController.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 28/08/2018.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CreateUserController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let datePicker = UIDatePicker()
    var skils = [Int]()
    var store: Firestore? = nil
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    var mySkils = [String]()
    
    let userImage: UIImageView = {
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = 50
        } else {
            y = 30
        }
        let screen = UIScreen.main.bounds
        let size = screen.width / 3
        let x = screen.width / 2 - size / 2
        let frame = CGRect(x: x, y: y, width: size, height: size)
        let iv = UIImageView(frame: frame)
        iv.image = UIImage(named: "User Image")
        iv.layer.cornerRadius = size / 2
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var nameTextField: UITextField = {
        let screen = UIScreen.main.bounds
        let width = (screen.width - 24) / 2
        let height: CGFloat = 30
        let x: CGFloat = 8
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = 50 + (screen.width / 3) + 8
        } else {
            y = 30 + (screen.width / 3) + 8
        }
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let tf = UITextField()
        tf.frame = frame
        tf.placeholder = "Name"
        tf.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.tag = 0
        tf.returnKeyType = .next
        tf.textContentType = .name
        return tf
    }()
    
    lazy var lastNameTextField: UITextField = {
        let screen = UIScreen.main.bounds
        let width = (screen.width - 24) / 2
        let height: CGFloat = 30
        let x: CGFloat = 16 + width
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = 50 + (screen.width / 3) + 8
        } else {
            y = 30 + (screen.width / 3) + 8
        }
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let tf = UITextField()
        tf.frame = frame
        tf.placeholder = "Last Name"
        tf.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.tag = 1
        tf.returnKeyType = .next
        tf.textContentType = .familyName
        return tf
    }()

    lazy var emailTextField: UITextField = {
        let screen = UIScreen.main.bounds
        let width = 3 * (screen.width - 24) / 5
        let height: CGFloat = 30
        let x: CGFloat = 8
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = 50 + (screen.width / 3) + 8 + 30 + 8
        } else {
            y = 30 + (screen.width / 3) + 8 + 30 + 8
        }
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let tf = UITextField()
        tf.frame = frame
        tf.placeholder = "E-mail"
        tf.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.tag = 2
        tf.returnKeyType = .next
        tf.keyboardType = .emailAddress
        tf.textContentType = .emailAddress
        return tf
    }()
    
    lazy var birthdayTextField: UITextField = {
        let screen = UIScreen.main.bounds
        let width = 2 * (screen.width - 24) / 5
        let height: CGFloat = 30
        let x: CGFloat = 16 + (width * 3 / 2)
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = 50 + (screen.width / 3) + 8 + 30 + 8
        } else {
            y = 30 + (screen.width / 3) + 8 + 30 + 8
        }
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let tf = UITextField()
        tf.frame = frame
        tf.placeholder = "Birthday"
        tf.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.tag = 3
        tf.returnKeyType = .next
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let screen = UIScreen.main.bounds
        let width = (screen.width - 24) / 2
        let height: CGFloat = 30
        let x: CGFloat = 8
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = 50 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8
        } else {
            y = 30 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8
        }
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let tf = UITextField()
        tf.frame = frame
        tf.placeholder = "Password"
        tf.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.tag = 4
        tf.returnKeyType = .next
        tf.textContentType = .emailAddress
        return tf
    }()
    
    lazy var celNumberTextField: UITextField = {
        let screen = UIScreen.main.bounds
        let width = (screen.width - 24) / 2
        let height: CGFloat = 30
        let x: CGFloat = 16 + width
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = 50 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8
        } else {
            y = 30 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8
        }
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let tf = UITextField()
        tf.frame = frame
        tf.placeholder = "Cel Number"
        tf.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.tag = 5
        tf.returnKeyType = .done
        tf.keyboardType = .phonePad
        tf.textContentType = .telephoneNumber
        return tf
    }()
    
    let yourSkillLabel: UILabel = {
        let screen = UIScreen.main.bounds
        let width = screen.width - 16
        let height: CGFloat = 15
        let x: CGFloat = 8
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = 50 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8 + 30 + 8
        } else {
            y = 30 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8 + 30 + 8
        }
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let lb = UILabel(frame: frame)
        lb.text = "Your Skill"
        lb.textAlignment = .left
        lb.font = UIFont.boldSystemFont(ofSize: 14.0)
        return lb
    }()
    
    let singButton: CustomButton = {
        let screen = UIScreen.main.bounds
        let width = (screen.width - 32) / 3
        let height = width
        let x: CGFloat = 8
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = 50 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8 + 30 + 8 + 15 + 8
        } else {
            y = 30 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8 + 30 + 8 + 15 + 8
        }
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let btn = CustomButton(type: .custom)
        btn.frame = frame
        btn.setTitle("Sing", for: UIControl.State.normal)
        btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        btn.setBackgroundImage(UIImage(named : "Sing"), for: UIControl.State.normal)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.tagNumber = 0
        btn.addTarget(self, action: #selector(touchAction(_:)), for: .touchUpInside)
        btn.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btn.addTarget(self, action: #selector(cancelTouch(_:)), for: .touchUpOutside)
        return btn
    }()
    
    let guitarButton: CustomButton = {
        let screen = UIScreen.main.bounds
        let width = (screen.width - 32) / 3
        let height = width
        let x: CGFloat = 16 + width
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = 50 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8 + 30 + 8 + 15 + 8
        } else {
            y = 30 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8 + 30 + 8 + 15 + 8
        }
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let btn = CustomButton(type: .custom)
        btn.frame = frame
        btn.setTitle("Guitar", for: UIControl.State.normal)
        btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        btn.setBackgroundImage(UIImage(named : "Guitar"), for: UIControl.State.normal)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.tagNumber = 1
        btn.addTarget(self, action: #selector(touchAction(_:)), for: .touchUpInside)
        btn.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btn.addTarget(self, action: #selector(cancelTouch(_:)), for: .touchUpOutside)
        return btn
    }()
    
    let electricGuitarButton: CustomButton = {
        let screen = UIScreen.main.bounds
        let width = (screen.width - 32) / 3
        let height = width
        let x: CGFloat = 24 + 2 * width
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = 50 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8 + 30 + 8 + 15 + 8
        } else {
            y = 30 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8 + 30 + 8 + 15 + 8
        }
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let btn = CustomButton(type: .custom)
        btn.frame = frame
        btn.setTitle("Electric Guitar", for: UIControl.State.normal)
        btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        btn.setBackgroundImage(UIImage(named : "ElectricGuitar"), for: UIControl.State.normal)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.tagNumber = 2
        btn.addTarget(self, action: #selector(touchAction(_:)), for: .touchUpInside)
        btn.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btn.addTarget(self, action: #selector(cancelTouch(_:)), for: .touchUpOutside)
        return btn
    }()
    
    let keyboardButton: CustomButton = {
        let screen = UIScreen.main.bounds
        let width = (screen.width - 32) / 3
        let height = width
        let x: CGFloat = 8
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = 50 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8 + 30 + 8 + 15 + 8 + width + 8
        } else {
            y = 30 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8 + 30 + 8 + 15 + 8 + width + 8
        }
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let btn = CustomButton(type: .custom)
        btn.frame = frame
        btn.setTitle("Keyboard", for: UIControl.State.normal)
        btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        btn.setBackgroundImage(UIImage(named : "Keyboard"), for: UIControl.State.normal)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.tagNumber = 3
        btn.addTarget(self, action: #selector(touchAction(_:)), for: .touchUpInside)
        btn.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btn.addTarget(self, action: #selector(cancelTouch(_:)), for: .touchUpOutside)
        return btn
    }()
    
    let drumButton: CustomButton = {
        let screen = UIScreen.main.bounds
        let width = (screen.width - 32) / 3
        let height = width
        let x: CGFloat = 16 + width
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = 50 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8 + 30 + 8 + 15 + 8 + width + 8
        } else {
            y = 30 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8 + 30 + 8 + 15 + 8 + width + 8
        }
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let btn = CustomButton(type: .custom)
        btn.frame = frame
        btn.setTitle("Drum", for: UIControl.State.normal)
        btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        btn.setBackgroundImage(UIImage(named : "Drum"), for: UIControl.State.normal)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.tagNumber = 4
        btn.addTarget(self, action: #selector(touchAction(_:)), for: .touchUpInside)
        btn.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btn.addTarget(self, action: #selector(cancelTouch(_:)), for: .touchUpOutside)
        return btn
    }()
    
    let cajonButton: CustomButton = {
        let screen = UIScreen.main.bounds
        let width = (screen.width - 32) / 3
        let height = width
        let x: CGFloat = 24 + 2 * width
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = 50 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8 + 30 + 8 + 15 + 8 + width + 8
        } else {
            y = 30 + (screen.width / 3) + 8 + 30 + 8 + 30 + 8 + 30 + 8 + 15 + 8 + width + 8
        }
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let btn = CustomButton(type: .custom)
        btn.frame = frame
        btn.setTitle("Cajon", for: UIControl.State.normal)
        btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        btn.setBackgroundImage(UIImage(named : "Cajon"), for: UIControl.State.normal)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.tagNumber = 5
        btn.addTarget(self, action: #selector(touchAction(_:)), for: .touchUpInside)
        btn.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btn.addTarget(self, action: #selector(cancelTouch(_:)), for: .touchUpOutside)
        return btn
    }()

    let cancelButton: UIButton = {
        let screen = UIScreen.main.bounds
        let width = (screen.width - 24) / 2
        let height: CGFloat = 30
        let x: CGFloat = 8
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = screen.height - 34 - 30
        } else {
            y = screen.height - 30
        }
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let btn = UIButton(type: .custom)
        btn.frame = frame
        btn.setTitle("Cancel", for: UIControl.State.normal)
        btn.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return btn
    }()
    
    let createButton: UIButton = {
        let screen = UIScreen.main.bounds
        let width = (screen.width - 24) / 2
        let height: CGFloat = 30
        let x: CGFloat = 16 + width
        var y: CGFloat = 0
        if UIScreen.main.bounds.height >= 812 {
            y = screen.height - 34 - 30
        } else {
            y = screen.height - 30
        }
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let btn = UIButton(type: .custom)
        btn.frame = frame
        btn.setTitle("Create", for: UIControl.State.normal)
        btn.setTitleColor(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        btn.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        return btn
    }()
    
    let grayView: UIView = {
        let uv = UIView()
        uv.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        uv.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        uv.alpha = 0.75
        return uv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(userImage)
        view.addSubview(nameTextField)
        view.addSubview(lastNameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(birthdayTextField)
        view.addSubview(celNumberTextField)
        view.addSubview(yourSkillLabel)
        view.addSubview(singButton)
        view.addSubview(guitarButton)
        view.addSubview(electricGuitarButton)
        view.addSubview(keyboardButton)
        view.addSubview(drumButton)
        view.addSubview(cajonButton)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseType)))
        
        self.skils.append(0)
        self.skils.append(0)
        self.skils.append(0)
        self.skils.append(0)
        self.skils.append(0)
        self.skils.append(0)
        
        showDatePicker()
        toolbar()
        
    }
    
    @objc func chooseType(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                picker.cameraCaptureMode = .photo
                
        
                self.present(picker, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Camera not available.", message:
                    nil, preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler:{ (action:UIAlertAction) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
    }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func cancelAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func createAction(){
        
        if self.nameTextField.text == "" || self.lastNameTextField.text == "" || self.emailTextField.text == "" || self.birthdayTextField.text == "" || self.passwordTextField.text == "" || self.celNumberTextField.text == "" {
            
            let alertController = UIAlertController(title: "Missing data!", message:
                "Please, complete your profile.", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            self.loadingSpinner()
            Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if user != nil {
                    UserDefaults.standard.setIsLoggedIn(value: true)
                }
                if error != nil {
                    print(error!)
                }
                
                
                let allSkils = ["Sing","Guitar","Electric Guitar","Keyboard","Drum","Cajon"]
                
                for i in 0...self.skils.count - 1 {
                    if self.skils[i] == 1 {
                        self.mySkils.append(allSkils[i])
                        print(self.mySkils)
                    }
                }
                
                self.store = Firestore.firestore()
                self.uploadImageProfile()
            }
        }
    }
    
    func uploadImageProfile(){
        let storageRef = Storage.storage().reference().child(Auth.auth().currentUser!.uid)
        if let uploadImage = self.userImage.image!.jpegData(compressionQuality: 0.05) {
            storageRef.putData(uploadImage, metadata: nil, completion:{ (metadata, error) in
                if error != nil {
                    print("Error upload userImage. Detail: \(error!)")
                    return
                }
//                UserDefaults.standard.set(uploadImage, forKey: "userImage")
                storageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print(error)
                    } else {
                        self.updateData(url!)
                    }
                })
            })
        }
    }
    
    func updateData(_ url: URL){
        self.store?.collection("users").document(Auth.auth().currentUser!.uid).setData([
            "name": self.nameTextField.text!,
            "lastName": self.lastNameTextField.text!,
            "birthday": self.birthdayTextField.text!,
            "email": self.emailTextField.text!,
            "celNumber": self.celNumberTextField.text!,
            "mySkils": self.mySkils,
            "username": "\(self.nameTextField.text!).\(self.lastNameTextField.text!)",
            "uid": Auth.auth().currentUser!.uid,
            "profileImageUrl": "\(url)",
            "usersUid": []
        ]) { err in
            if let err = err {
                print("Deu tilti em alguma coisa. Apareceu isso: \(err)")
            } else {
                let homeController = MainNavigationController()
                self.present(homeController, animated: true, completion: nil)
            }
        }
    }
    
    @objc public func touchAction(_ sender: UIButton){
        let tag: Int = (sender as! CustomButton).tagNumber
        
        if skils[tag] == 0 {
            UIView.animate(withDuration: 0.1, animations: {
                sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                sender.alpha = 0.7
            })
            
            self.skils[tag] = 1
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                sender.transform = CGAffineTransform(scaleX: 1, y: 1)
                sender.alpha = 1
            })
            
            self.skils[tag] = 0
        }
    }
    @objc func cancelTouch(_ button: UIButton){
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 1, y: 1)
            button.alpha = 1
        })
    }
    @objc func touchDown(_ button: UIButton){
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            button.alpha = 0.7
        })
    }
    
    func loadingSpinner(){
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.style = .whiteLarge
        
        view.addSubview(grayView)
        view.addSubview(spinner)
        
        spinner.startAnimating()
    }
    
    func stopSpinner(){
        spinner.stopAnimating()
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        birthdayTextField.inputAccessoryView = toolbar
        birthdayTextField.inputView = datePicker
        
    }
    
    func toolbar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([spaceButton,doneButton], animated: false)
        
        nameTextField.inputAccessoryView = toolbar
        lastNameTextField.inputAccessoryView = toolbar
        emailTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
        celNumberTextField.inputAccessoryView = toolbar
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        birthdayTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        celNumberTextField.resignFirstResponder()
        birthdayTextField.resignFirstResponder()
    }
}

class CustomButton : UIButton {
    
    var tagNumber : Int = 0
    var customObject : Any? = nil
    
    convenience init(tagNumber: Int, object: Any) {
        self.init()
        self.tagNumber = tagNumber
        self.customObject = object
    }
}
