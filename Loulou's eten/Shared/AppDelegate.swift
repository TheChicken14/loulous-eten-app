//
//  AppDelegate.swift
//  Loulou's eten
//
//  Created by Wisse Hes on 05/10/2021.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseAnalytics
import Alamofire

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        process(notification)
        
        // Only show notification if not sent by current user
        let userInfo = notification.request.content.userInfo
        if let userID = userInfo["feederID"] as? String {
            if let savedUserID = UserDefaults.standard.string(forKey: "userid") {
                if userID != savedUserID {
                    completionHandler([[.banner, .sound, .list]])
                }
            }
        } else {
            completionHandler([[.banner, .sound, .list]])
        }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        process(response.notification)
        completionHandler()
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    private func process(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)

        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        let tokenDict = [ "token": fcmToken ?? "" ]
        
        if UserDefaults.standard.string(forKey: "token") != nil {
            APIMethods.registerDevice(fcmToken ?? "")
        }
        
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: tokenDict
        )
    }
}
