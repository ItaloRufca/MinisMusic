//
//  MusicCell.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 20/09/2018.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//

import UIKit

class MusicCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
