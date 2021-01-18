//
//  HomeController.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 26/08/2018.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

private let reuseIdentifier = "Cell"

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let musicCellId = "musicCellId"
    let listCellId = "listCellId"
    let chatCellId = "chatCellId"
    let calendarCellId = "calendarCellId"
    
    var store: Firestore? = nil
    let user = Auth.auth().currentUser?.uid
    var userImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        
        setUpMenuBar()
        setUpCollectionView()
        setUpProfileImage()
        registerCells()
        
        
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    
    fileprivate func registerCells() {
        collectionView.register(MusicCell.self, forCellWithReuseIdentifier: musicCellId)
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: listCellId)
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: chatCellId)
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: calendarCellId)
    }
    
    private func setUpMenuBar(){
        let myView = ["menuBar" : menuBar]
        view.addSubview(menuBar)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[menuBar]|", options: [] , metrics: nil, views: myView))
        
        if UIScreen.main.bounds.height >= 812 {
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[menuBar(84)]|", options: [] , metrics: nil, views: myView))
        } else {
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[menuBar(50)]|", options: [] , metrics: nil, views: myView))
        }
        
        
    }
    
    let userButton: UIButton = {
        let frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        let btn = UIButton(type: .custom)
        btn.frame = frame
        btn.setImage(UIImage(named: "miniUserImage"), for: .normal)
        
        return btn
    }()
    
    func setupNavBarButtons(_ url: URL) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userButton)
        userButton.widthAnchor.constraint(equalToConstant: 34.0).isActive = true
        userButton.heightAnchor.constraint(equalToConstant: 34.0).isActive = true
        userButton.addTarget(self, action: #selector(openUserView), for: .touchUpInside)
        userButton.sd_setImage(with: url, for: .normal, completed: nil)
        userButton.imageView?.contentMode = .scaleAspectFill
        userButton.imageView?.layer.masksToBounds = true
        userButton.imageView?.layer.cornerRadius = 17
        
    }
    
    @objc func showChatForUser(_ user: UsersModel) {
//        let chatLogController = ChatLogController(collectionViewLayout: StickyHeaders())
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func setUpProfileImage() {
        self.store = Firestore.firestore()
        var url: URL? = nil
        store?.collection("users").document(self.user!)
            .getDocument { (document, err) in
                if let document = document {
                    if document.exists {
                        let profileImage = document.data()!["profileImageUrl"]
                        url = URL(string: profileImage as! String)
                        self.setupNavBarButtons(url!)
                    } else {
                        print("Document does not exist")
                }
            }
        }
    }
    
    @objc func openUserView(){
        UserDefaults.standard.setIsLoggedIn(value: false)
        print(UserDefaults.standard.isLoggedIn())
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    func setUpCollectionView(){
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        
    }
    
    func scrollToMenuIndex(_ menuIndex: Int){
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let musicCell = collectionView.dequeueReusableCell(withReuseIdentifier: musicCellId, for: indexPath)
            return musicCell
        } else if indexPath.item == 1 {
            let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: listCellId, for: indexPath)
            return listCell
        } else if indexPath.item == 2 {
            let chatCell = collectionView.dequeueReusableCell(withReuseIdentifier: chatCellId, for: indexPath)
            return chatCell
        } else {
            let calendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarCellId, for: indexPath)
            return calendarCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var index = targetContentOffset.pointee.x / UIScreen.main.bounds.width
        
        if index >= 2 {
            index += 1
            let indexPath = IndexPath(item: Int(index), section: 0)
            menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        } else {
            let indexPath = IndexPath(item: Int(index), section: 0)
            menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }
        
        
    }
    
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as? UIViewController
            }
        }
        return nil
    }
}
