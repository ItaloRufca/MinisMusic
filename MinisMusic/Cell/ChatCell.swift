//
//  ChatCell.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 20/09/2018.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ChatCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    lazy var contactList: UITableView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let tv = UITableView()
        tv.frame = frame
        tv.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    var usersArray: Array<UsersModel> = []
    var store: Firestore? = nil
    let user = Auth.auth().currentUser?.uid
    var uidArray: Array<String> = []
    let cellId = "cellId"
//    var messages: Array<Messages> = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        store = Firestore.firestore()
        
        contactList.register(UsersCell.self, forCellReuseIdentifier: cellId)
        
        setUpView()
//        observeMessage()
    }
    
//    func observeMessage() {
//        self.store?.collection("messages").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    let fromName = document.data()["fromName"] as! String
//                    let fromUid = document.data()["fromUid"] as! String
//                    let text = document.data()["text"] as! String
//                    let toName = document.data()["toName"] as! String
//                    let toUid = document.data()["toUid"] as! String
//                    let time = document.data()["time"] as! NSNumber
////                    self.messages.append(Messages(fromName, fromUid, text, toName, toUid, time))
//                }
//            }
//
//        }
//    }
    
    func findMessage( _ cell: UITableViewCell, _ toUid: String, _ timeLabel: UILabel) {
        let uid = Auth.auth().currentUser?.uid
        var messagesUid: Array<String> = []
        var messages = [Messages]()
        
        self.store?.collection("users").document(uid!).getDocument() { (document, error) in
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
                    self.store?.collection("userMessages").document(uid!).getDocument() {(document, error) in
                        if let document = document {
                            messagesUid = document.data()![toUid] as! Array
                            for msg in messagesUid {
                                self.store?.collection("messages").document(msg).addSnapshotListener(   {   documentSnapshot, error in
                                    guard let document = documentSnapshot else {
                                        print("Error fetching document: \(error!)")
                                        return
                                    }
                                    let fromName = document.data()!["fromName"] as! String
                                    let fromUid = document.data()!["fromUid"] as! String
                                    let text = document.data()!["text"] as! String
                                    let toName = document.data()!["toName"] as! String
                                    let toUid = document.data()!["toUid"] as! String
                                    let time = document.data()!["time"] as! NSNumber
                                    messages.append(Messages(fromName, fromUid, text, toName, toUid, time))
                                    messages.sort { ($0.time as NSNumber).compare($1.time) == .orderedDescending }
                                    self.showLastMessage(cell, messages[0].text, timeLabel, messages[0].time)
                                })
                            }
                        }
                    }
                } else {
                    self.showLastMessage(cell, "", timeLabel, 0)
                }
            }
        }
    }
    
    func showLastMessage(_ cell: UITableViewCell, _ text: String, _ timeLabel: UILabel, _ time: NSNumber) {
        cell.detailTextLabel?.text = text
        
        let exactDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: time))
        let dateFormatt = DateFormatter()
        dateFormatt.dateFormat = "HH:mm"
        
        timeLabel.text = dateFormatt.string(from: exactDate as Date)
        
        
    }
    
    func setUpView(){
        backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        addSubview(contactList)
                
        if UIScreen.main.bounds.height >= 812 {
            contactList.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
        } else {
            contactList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        }
        
        findUsers()
    }
    
    func findUsers() {
        self.store?.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if document.documentID != Auth.auth().currentUser?.uid {
                        self.uidArray.append("\(document.documentID)")
                    }
                }
                self.populateArray()
            }
        }
    }
    
    func populateArray() {
        for uid in self.uidArray {
            self.store?.collection("users").document(uid).getDocument() { (document, err) in
                if let document = document {
                    let urlImage = URL(string: document.data()!["profileImageUrl"] as! String)
                    let name = document.data()!["name"] as! String
                    let lastName = document.data()!["lastName"] as! String
                    let username = document.data()!["username"] as! String
                    let uidUser = document.data()!["uid"] as! String
                    self.usersArray.append(UsersModel(urlImage!, name, lastName, username, uidUser, false, 0))
                    self.usersArray = self.usersArray.sorted(by: {$0.name < $1.name})
                    self.contactList.reloadData()
                }
            }
        }
    }
    
    @objc func openChat() {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UsersCell
        let user = usersArray[indexPath.row]
        cell.textLabel?.text = "\(user.name) \(user.lastName)"
        cell.profileImageView.sd_setImage(with: user.urlImage, completed: nil)
        self.findMessage(cell, user.uid, cell.timeLabel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var homeController: HomeController?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.usersArray[indexPath.row]
        
        let parent = self.parentViewController as! HomeController
        
        parent.showChatForUser(user)
//        self.homeController?.showChatForUser(user)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
