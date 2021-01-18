//
//  UsersModel.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 03/10/18.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//

import UIKit

class UsersModel: NSObject {
    var urlImage: URL
    var name: String
    var lastName: String
    var username: String
    var uid: String
    var selected: Bool
    var time: NSNumber
    
    init(_ urlImage: URL, _ name: String, _ lastName: String, _ username: String, _ uid: String, _ selected: Bool, _ time: NSNumber) {
        self.urlImage = urlImage
        self.name = name
        self.lastName = lastName
        self.username = username
        self.uid = uid
        self.selected = selected
        self.time = time
        
    }
}
