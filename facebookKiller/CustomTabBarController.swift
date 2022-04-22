//
//  CustomTabBarController.swift
//  facebookKiller
//
//  Created by Valeriy Trusov on 15.03.2022.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let FriendsController = FriendsController(collectionViewLayout: layout)
        let navForFriends = UINavigationController(rootViewController: FriendsController)
        navForFriends.navigationBar.scrollEdgeAppearance = navForFriends.navigationBar.standardAppearance
        navForFriends.tabBarItem = UITabBarItem(title: "Recent", image: UIImage(systemName: "clock"), tag: 0)
        
        let vc = createDummyVC(title: "Calls", image: "phone")
        vc.view.backgroundColor = .white
        let vc2 = createDummyVC(title: "Groups", image: "person.3")
        vc2.view.backgroundColor = .white
        let vc3 = createDummyVC(title: "People", image: "list.bullet")
        vc3.view.backgroundColor = .white
        let vc4 = createDummyVC(title: "Settings", image: "gear")
        vc4.view.backgroundColor = .white

        
        viewControllers = [navForFriends, vc, vc2, vc3, vc4]
    }
    
    private func createDummyVC(title: String, image: String) -> UINavigationController {
        
        let vc = UIViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: image), tag: 0)
        return nav
    }
}
