//
//  MenuBar.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 26/08/2018.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var circleButton: UIButton!
    let cellId = "cellId"
    var imageNames = ["songs","playlist","","sms","calendar"]
    
    var homeController: HomeController?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: [], metrics: nil, views: ["v0": collectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: [], metrics: nil, views: ["v0": collectionView]))
        collectionView.isScrollEnabled = false
        
        
        addTopBorder(color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), width: 0.4)
        createBorder()
        configureView()
        
    }
    
    func configureView() {
        
        circleButton = createCircleButton()
        circleButton.layer.cornerRadius = circleButton.frame.width / 2
        circleButton.clipsToBounds = true
        circleButton.layer.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        circleButton.tintColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
        circleButton.setImage(UIImage(named : "music"), for: UIControl.State.normal)
        circleButton.imageView?.contentMode = .scaleAspectFit
        
        self.addSubview(circleButton)
    }
    
    func createCircleButton() -> UIButton {
        let size: CGFloat = 60
        let screenWidth = UIScreen.main.bounds.width
        let x = screenWidth / 2 - size / 2
        let y = -size / 4
        let btn = UIButton(type: .custom)
        let frame = CGRect(x: x, y: y, width: size, height: size)
        btn.frame = frame
        return btn
    }
    
    func createBorder() {
        let border = CALayer()
        border.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        let sizeBorder: CGFloat = 61
        let screenWidth = UIScreen.main.bounds.width
        let x = screenWidth / 2 - (sizeBorder - 1) / 2
        let y = -(sizeBorder + 1) / 4
        border.frame = CGRect(x: x, y: y, width: sizeBorder - 1, height: sizeBorder - 2)
        border.cornerRadius = border.frame.width / 2
        
        
        self.layer.addSublayer(border)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 5, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 3 {
            homeController?.scrollToMenuIndex(2)
            
        } else if indexPath.item == 4 {
            homeController?.scrollToMenuIndex(3)
            
        } else if indexPath.item == 2 {
            
        } else {
            homeController?.scrollToMenuIndex(indexPath.item)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension UIView {
    func addTopBorder(color: UIColor, width: CGFloat) {
        let topBorderView = UIView(frame: CGRect.zero)
        topBorderView.backgroundColor = color
        self.addSubview(topBorderView)
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topBorderView.topAnchor.constraint(equalTo: self.topAnchor),
            topBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topBorderView.heightAnchor.constraint(equalToConstant: width)
            ])
    }
}

class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
        let size: CGFloat = 25
        let screenWidth = UIScreen.main.bounds.width
        let x = screenWidth / 10 - size / 2
        let y = size / 4 + 5
        let frame = CGRect(x: x, y: y, width: size, height: size)
        let iv = UIImageView(frame: frame)
        iv.image = UIImage(named: "music")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    //    let imageNames = ["songs","playlist","","sms","pp"]
    
    override var isHighlighted: Bool {
        didSet {
            
            imageView.image = isHighlighted ? imageView.image?.withRenderingMode(.alwaysOriginal): imageView.image?.withRenderingMode(.alwaysTemplate)
            
        }
    }
    
    override var isSelected: Bool {
        didSet {
            
            imageView.image = isSelected ? imageView.image?.withRenderingMode(.alwaysOriginal): imageView.image?.withRenderingMode(.alwaysTemplate)
            
        }
    }
    
    override func setUpViews() {
        super.setUpViews()
        
        addSubview(imageView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(28)]", options: [], metrics: nil, views: ["v0": imageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(28)]", options: [], metrics: nil, views: ["v0": imageView]))
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
}
