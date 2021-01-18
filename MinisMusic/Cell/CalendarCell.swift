//
//  CalendarCell.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 20/09/2018.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
