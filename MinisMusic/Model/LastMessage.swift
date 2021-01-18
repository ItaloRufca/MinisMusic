//
//  LastMessage.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 03/10/18.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//

import UIKit

class LastMessage: NSObject {
    var text: String
    var time: NSNumber
    
    init(_ text: String, _ time: NSNumber) {
        self.text = text
        self.time = time
    }
}
