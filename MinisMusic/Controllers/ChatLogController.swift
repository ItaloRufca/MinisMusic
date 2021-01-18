//
//  ChatLogController.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 20/09/2018.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var messagesUid = [String]()
    var allMessages: Array<Messages> = []
    
    
    var user: UsersModel? {
        didSet {
            navigationItem.title = user?.name
            
        }
    }
    
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter message..."
        tf.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        return tf
    }()
    
    var store: Firestore? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        store = Firestore.firestore()
        collectionView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView?.keyboardDismissMode = .interactive

        getMessages(Auth.auth().currentUser!.uid, (user?.uid)!)
//        setupInputComponents()
        setUpKeyboardObserves()
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        if UIScreen.main.bounds.height >= 812 {
            containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        } else {
            containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        }
        containerView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerView.addSubview(self.inputTextField)
        
        self.inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLine)
        
        separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLine.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        return inputContainerView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    
    func setUpKeyboardObserves() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
//        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//        containerViewBottonAnchor?.constant = -keyboardFrame.height
//        containerViewHeightAnchor?.constant = 50
        inputContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//        containerViewBottonAnchor?.constant = 0
//        inputContainerView.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        if UIScreen.main.bounds.height >= 812 {
            inputContainerView.heightAnchor.constraint(equalToConstant: 84).isActive = true
        } else {
            inputContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        

        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    var containerViewBottonAnchor: NSLayoutConstraint?
    var containerViewHeightAnchor: NSLayoutConstraint?
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerViewBottonAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottonAnchor?.isActive = true
        if UIScreen.main.bounds.height >= 812 {
            containerViewHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: 84)
            containerViewHeightAnchor?.isActive = true
        } else {
            containerViewHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: 50)
            containerViewHeightAnchor?.isActive = true
        }
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLine)
        
        separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLine.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        separatorLine.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
    }
    
    @objc func handleSend() {
          myInfo()
    }
    
    func getMessages(_ fromUid: String, _ toUid: String) {
        
        self.store?.collection("users").document(fromUid).getDocument() { (document, error) in
            if let document = document {
                var usersArray: Array<String> = []
                usersArray = document.data()!["usersUid"] as! Array
                var check = false
                for uid in usersArray {
                    if uid == toUid {
                        check = true
                    }
                }
                if check {
                    let uid = Auth.auth().currentUser!.uid
                    let userMessages = self.store?.collection("userMessages").document(uid)
                    userMessages?.getDocument() { (document, error) in
                        if let document = document {
                            self.messagesUid = document.data()![(self.user?.uid)!] as! Array
                            self.observeMessages()
                        }
                    }
                }
            }
        }
    }
    
    func observeMessages() {
        for uid in self.messagesUid {
            let userMessages = self.store?.collection("messages").document(uid)
            userMessages?.addSnapshotListener({ documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }

                
                
                let fromName = document.data()!["fromName"] as? String
                let fromUid = document.data()!["fromUid"] as? String
                let text = document.data()!["text"] as? String
                let toName = document.data()!["toName"] as? String
                let toUid = document.data()!["toUid"] as? String
                let time = document.data()!["time"] as? NSNumber

                self.allMessages.append(Messages(fromName!, fromUid!, text!, toName!, toUid!, time!))
                self.allMessages.sort { ($0.time as NSNumber).compare($1.time) == .orderedAscending }
                self.collectionView.reloadData()
            })
        }
        
    }
    
    func putText(_ cell: UITextView, _ text: String) {
        cell.text = text
    }
    
    func saveMessage(_ name: String, _ lastName: String, _ fromUid: String) {
        
        let toUid = user?.uid
        let toFirstName = user!.name
        let toLastName = user!.lastName
        let timeStamp: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
        var messageUid: String = ""
        
        messageUid = (self.store?.collection("messages").document().documentID)!
        
        self.store?.collection("messages").document(messageUid).setData([
            "text": self.inputTextField.text!,
            "fromName": "\(name) \(lastName)",
            "toName": "\(toFirstName) \(toLastName)",
            "fromUid": fromUid,
            "toUid": toUid!,
            "time": timeStamp
        ]) { err in
            if let err = err {
                print("Deu tilti em alguma coisa. Apareceu isso: \(err)")
            } else {
                self.inputTextField.text = nil
                
            }
            self.chatCheck(fromUid, toUid!, messageUid)
            self.collectionView.reloadData()
        }
    }
    
    func chatCheck(_ fromUid: String, _ toUid: String, _ messageUid: String) {
        self.store?.collection("users").document(fromUid).getDocument() { (document, error) in
            if let document = document {
                var usersArray: Array<String> = []
                usersArray = document.data()!["usersUid"] as! Array
                var check = false
                for uid in usersArray {
                    if uid == toUid {
                        check = true
                    }
                }
                if check {
                    self.store?.collection("userMessages").document(fromUid).getDocument() { (document, error) in
                        if let document = document {
                            var myMessages: Array<String> = []
                            myMessages = document.data()![toUid] as! Array
                            myMessages.append(messageUid)
                            
                            self.store?.collection("userMessages").document(fromUid).setData(["\(toUid)": myMessages], merge: true) { err in
                                if let err = err {
                                    print("Deu tilti em alguma coisa. Apareceu isso: \(err)")
                                } else {
                                    self.inputTextField.text = nil
                                }
                            }
                        }
                    }
                    self.store?.collection("userMessages").document(toUid).getDocument() { (document, error) in
                        if let document = document {
                            var myMessages: Array<String> = []
                            myMessages = document.data()![fromUid] as! Array
                            myMessages.append(messageUid)
                            
                            self.store?.collection("userMessages").document(toUid).setData(["\(fromUid)": myMessages], merge: true) { err in
                                if let err = err {
                                    print("Deu tilti em alguma coisa. Apareceu isso: \(err)")
                                } else {
                                    self.inputTextField.text = nil
                                }
                            }
                        }
                    }
                } else {
                    self.store?.collection("users").document(fromUid).getDocument() { (document, error) in
                        if let document = document {
                            var userUid: Array<String> = []
                            userUid = document.data()!["usersUid"] as! Array
                            userUid.append(toUid)
                            self.store?.collection("users").document(fromUid).updateData(["usersUid": userUid])  { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                }
                            }
                        }
                    }
                    
                    self.store?.collection("users").document(toUid).getDocument() { (document, error) in
                        if let document = document {
                            var userUid: Array<String> = []
                            userUid = document.data()!["usersUid"] as! Array
                            userUid.append(fromUid)
                            self.store?.collection("users").document(toUid).updateData(["usersUid": userUid])  { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                }
                            }
                        }
                    }
                    
                    self.store?.collection("userMessages").document(fromUid).getDocument() { (document, error) in
                        if document != nil {
                            var myMessages: Array<String> = []
                            myMessages.append(messageUid)
                            self.store?.collection("userMessages").document(fromUid).setData(["\(toUid)": myMessages], merge: true) { err in
                                if let err = err {
                                    print("Deu tilti em alguma coisa. Apareceu isso: \(err)")
                                } else {
                                    self.inputTextField.text = nil
                                }
                            }
                        }
                    }
                    self.store?.collection("userMessages").document(toUid).getDocument() { (document, error) in
                        if document != nil {
                            var myMessages: Array<String> = []
                            myMessages.append(messageUid)
                            self.store?.collection("userMessages").document(toUid).setData(["\(fromUid)": myMessages], merge: true) { err in
                                if let err = err {
                                    print("Deu tilti em alguma coisa. Apareceu isso: \(err)")
                                } else {
                                    self.inputTextField.text = nil
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func myInfo() {
        let uid = Auth.auth().currentUser?.uid
        self.store?.collection("users").document(uid!).getDocument() { (document, err) in
            if let document = document {
                let name = document.data()!["name"] as! String
                let lastName = document.data()!["lastName"] as! String
                self.saveMessage(name, lastName, uid!)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allMessages.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        var height: CGFloat = 80
        
        let text = self.allMessages[indexPath.item].text
        let height = estimateFrameForText(text).height + 16
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 10000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = allMessages[indexPath.item]

        cell.textView.text = message.text
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.text).width + 32
        
        setUpCell(cell, message)
        
        return cell
    }
    
    private func setUpCell(_ cell: ChatMessageCell, _ message: Messages) {
        if message.fromUid == Auth.auth().currentUser!.uid {
            cell.bublleView.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            cell.textView.textColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
        } else {
            cell.bublleView.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
            cell.textView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismissKeyboard()
    }
    
    
}

class StickyHeaders: UICollectionViewFlowLayout {
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard var superAttributes = super.layoutAttributesForElements(in: rect), let collectionView = collectionView else {
            return super.layoutAttributesForElements(in: rect)
        }
        
        let collectionViewTopY = collectionView.contentOffset.y + collectionView.contentInset.top
        let contentOffset = CGPoint(x: 0, y: collectionViewTopY)
        let missingSections = NSMutableIndexSet()
        
        superAttributes.forEach { layoutAttributes in
            if layoutAttributes.representedElementCategory == .cell && layoutAttributes.representedElementKind != UICollectionView.elementKindSectionHeader {
                missingSections.add(layoutAttributes.indexPath.section)
            }
        }
        
        missingSections.enumerate(using: { idx, stop in
            let indexPath = IndexPath(item: 0, section: idx)
            if let layoutAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                superAttributes.append(layoutAttributes)
            }
        })
        
        for layoutAttributes in superAttributes {
            if let representedElementKind = layoutAttributes.representedElementKind {
                if representedElementKind == UICollectionView.elementKindSectionHeader {
                    let section = layoutAttributes.indexPath.section
                    let numberOfItemsInSection = collectionView.numberOfItems(inSection: section)
                    
                    let firstCellIndexPath = IndexPath(item: 0, section: section)
                    let lastCellIndexPath = IndexPath(item: max(0, (numberOfItemsInSection - 1)), section: section)
                    
                    let cellAttributes:(first: UICollectionViewLayoutAttributes, last: UICollectionViewLayoutAttributes) = {
                        if (collectionView.numberOfItems(inSection: section) > 0) {
                            return (
                                self.layoutAttributesForItem(at: firstCellIndexPath)!,
                                self.layoutAttributesForItem(at: lastCellIndexPath)!)
                        } else {
                            return (
                                self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: firstCellIndexPath)!,
                                self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: lastCellIndexPath)!)
                        }
                    }()
                    
                    let headerHeight = layoutAttributes.frame.height
                    var origin = layoutAttributes.frame.origin
                    // This line makes only one header visible fixed at the top
                    //                    origin.y = min(contentOffset.y, cellAttributes.last.frame.maxY - headerHeight)
                    // Uncomment this line for normal behaviour:
                    origin.y = min(max(contentOffset.y, cellAttributes.first.frame.minY - headerHeight), cellAttributes.last.frame.maxY - headerHeight)
                    
                    layoutAttributes.zIndex = 1024
                    layoutAttributes.frame = CGRect(origin: origin, size: layoutAttributes.frame.size)
                }
            }
        }
        
        return superAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    
    
    
    
    
    
    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        
//        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
//        
//        // Helpers
//        let sectionsToAdd = NSMutableIndexSet()
//        var newLayoutAttributes = [UICollectionViewLayoutAttributes]()
//        
//        for layoutAttributesSet in layoutAttributes {
//            if layoutAttributesSet.representedElementCategory == .cell {
//                // Add Layout Attributes
//                newLayoutAttributes.append(layoutAttributesSet)
//                
//                // Update Sections to Add
//                sectionsToAdd.add(layoutAttributesSet.indexPath.section)
//                
//            } else if layoutAttributesSet.representedElementCategory == .supplementaryView {
//                // Update Sections to Add
//                sectionsToAdd.add(layoutAttributesSet.indexPath.section)
//            }
//        }
//        
//        for section in sectionsToAdd {
//            let indexPath = IndexPath(item: 0, section: section)
//            
//            if let sectionAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
//                newLayoutAttributes.append(sectionAttributes)
//            }
//        }
//        
//        return newLayoutAttributes
//        
////        var layoutAttributes = super.layoutAttributesForElements(in: rect) as! [UICollectionViewLayoutAttributes]
////        let headerNeedingLayout = NSMutableIndexSet()
////        for attributes in layoutAttributes {
////            if attributes.representedElementCategory == .cell {
////                headerNeedingLayout.add(attributes.indexPath.section)
////            }
////        }
////        for attributes in layoutAttributes {
////            if let elementKind = attributes.representedElementKind {
////                if elementKind == UICollectionView.elementKindSectionHeader {
////                    headerNeedingLayout.remove(attributes.indexPath.section)
////                }
////            }
////        }
////        headerNeedingLayout.enumerate { (index, stop) -> Void in
////            let indexPath = IndexPath(item: 0, section: index)
////            let attributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader , at: indexPath)
////            layoutAttributes.append(attributes!)
////        }
////        for attributes in layoutAttributes {
////            if let elementKind = attributes.representedElementKind {
////                if elementKind == UICollectionView.elementKindSectionHeader {
////                    let section = attributes.indexPath.section
////                    let attributesForFirstItemInSection = layoutAttributesForItem(at: IndexPath(item: 0, section: section))
////                    let attributesForLastItemInSection = layoutAttributesForItem(at: IndexPath(item: collectionView!.numberOfItems(inSection: section) - 1, section: section))
////                    var frame = attributes.frame
////                    let offset = collectionView!.contentOffset.y
////
////
////                    let minY = (attributesForFirstItemInSection?.frame.minY)! - frame.height
////                    let maxY = (attributesForLastItemInSection?.frame.maxY)! - frame.height
////                    let y = min(max(offset, minY), maxY)
////                    frame.origin.y = y
////                    attributes.frame = frame
////                    attributes.zIndex = 99
////                }
////            }
////        }
////        return layoutAttributes
//    }
//    
//    
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }
}
