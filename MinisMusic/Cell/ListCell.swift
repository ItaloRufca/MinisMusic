//
//  ListCell.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 20/09/2018.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//

import UIKit

class ListCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
