//
//  AppDelegate.swift
//  JiveTalkQuiz
//
//  Created by sihon321 on 2020/02/02.
//  Copyright © 2020 sihon321. All rights reserved.
//

import UIKit
import RxGesture
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    if #available(iOS 13, *) {
      
    } else {
      FirebaseApp.configure()
      GADMobileAds.sharedInstance().start(completionHandler: nil)
      self.window = UIWindow(frame: UIScreen.main.bounds)
      window?.makeKeyAndVisible()
      
      let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
      window?.rootViewController = launchScreen
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
        let vc = QuizListViewController()
        vc.reactor = QuizListViewReactor(storageService: StorageService(),
                                         localStorage: LocalStorage())
        let nc = UINavigationController(rootViewController: vc)
        
        self?.window?.rootViewController = nc
      }
    }
    return true
  }

  // MARK: UISceneSession Lifecycle
  @available(iOS 13.0, *)
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  @available(iOS 13.0, *)
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

