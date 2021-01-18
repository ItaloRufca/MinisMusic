//
//  MainNavigationController.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 26/08/2018.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//

import UIKit


class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        if UserDefaults.standard.isLoggedIn() {
            //assume user is logged in
            let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
            viewControllers = [homeController]
        } else {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return true
    }
    
    @objc func showLoginController() {
        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen
        present(loginController, animated: false, completion: {
            //perhaps we'll do something here later
        })
    }
}
