//
//  MainTabBarViewController.swift
//  MC3
//
//  Created by Hansen Yudistira on 20/08/24.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let configuration = UIImage.SymbolConfiguration(weight: .heavy)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    func setupTabs() {
        viewControllers = [
            createNavigationController(rootViewController: DailyReminderViewController(),
                                       title: "Daily Reminder",
                                       image: UIImage(systemName: "calendar.badge.checkmark", withConfiguration: configuration)!,
                                       selectedImage: UIImage(systemName: "calendar.badge.checkmark", withConfiguration: configuration)!
                                      ),
            createNavigationController(rootViewController: ReminderViewController(),
                                       title: "All Reminder",
                                       image: UIImage(systemName: "list.bullet", withConfiguration: configuration)!,
                                       selectedImage: UIImage(systemName: "list.bullet", withConfiguration: configuration)!
                                      )
        ]
    }
    
    func createNavigationController(rootViewController: UIViewController, title: String, image: UIImage, selectedImage: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.prefersLargeTitles = false
        navController.navigationItem.title = title
        
        UITabBar.appearance().tintColor = .systemBlue
        UITabBar.appearance().backgroundColor = .white
        
        return navController
    }
}
