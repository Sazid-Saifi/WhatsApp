//
//  AppDelegate.swift
//  UserDemo
//
//  Created by Vijay's Braintech on 16/04/24.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift
import FirebaseDatabase
import UXCam
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebasePerformance
      


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
//        let trace = Performance.startTrace(name: "CUSTOM_TRACE_NAME")
//        let configuration = UXCamConfiguration(appKey: "n7vqmkkiked1ru0")
//        configuration.enableAdvancedGestureRecognition = true
//        UXCam.optIntoSchematicRecordings()
//        UXCam.start(with: configuration)
        IQKeyboardManager.shared.enable = true
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

