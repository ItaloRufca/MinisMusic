//
//  ChatMessageCell.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 06/10/18.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Messagem aqui"
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.backgroundColor = UIColor.clear
        return tv
    }()
    
    let bublleView: UIView = {
        let bv = UIView()
        bv.backgroundColor = #colorLiteral(red: 0, green: 0.537254902, blue: 0.9764705882, alpha: 1)
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.layer.cornerRadius = 16
        bv.layer.masksToBounds = true
        return bv
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bublleView)
        bubbleRightAnchor = bublleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleRightAnchor?.isActive = true
        bubbleLeftAnchor = bublleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        bubbleLeftAnchor?.isActive = false
        bublleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bublleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bublleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        bublleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        addSubview(textView)
        textView.rightAnchor.constraint(equalTo: bublleView.rightAnchor, constant: -6).isActive = true
        textView.leftAnchor.constraint(equalTo: bublleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
