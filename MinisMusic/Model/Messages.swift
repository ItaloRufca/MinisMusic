//
//  Messages.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 03/10/18.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//

import UIKit

class Messages: NSObject {
    var fromName: String
    var fromUid: String
    var text: String
    var toName: String
    var toUid: String
    var time: NSNumber
    
    init(_ fromName: String, _ fromUid: String, _ text: String, _ toName: String, _ toUid: String, _ time: NSNumber) {
        self.fromName = fromName
        self.fromUid = fromUid
        self.text = text
        self.toName = toName
        self.toUid = toUid
        self.time = time
    }
}
