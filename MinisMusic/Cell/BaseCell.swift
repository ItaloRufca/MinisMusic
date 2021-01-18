//
//  BaseCell.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 26/08/2018.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
