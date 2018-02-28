//
//  AppDelegate.swift
//  HubrickApp
//
//  Created by Andrey on 2/24/18.
//

import UIKit
import Firebase
import UserNotifications
import PushNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let pushNotifications = PushNotifications.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        requestNotificationAuthorization(application: application)
        
        pushNotifications.start(instanceId: "52df483e-a134-4da2-a2cd-46cfed83ac67")
        pushNotifications.registerForRemoteNotifications()
        
        return true
    }
    
    func requestNotificationAuthorization(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        pushNotifications.registerDeviceToken(deviceToken) {
            try? self.pushNotifications.subscribe(interest: "HubrickApp")
        }
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let apsNotification = userInfo["aps"] as? Dictionary<String, AnyObject> {
            NotificationCenter.default.post(name: NSNotification.Name(FeedViewController.RefreshFeedItemsNotification), object: nil, userInfo: apsNotification)
        }
        
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if UIApplication.shared.applicationState != .active {
            if let apsNotification = userInfo["aps"] as? Dictionary<String, AnyObject> {
                NotificationCenter.default.post(name: NSNotification.Name(FeedViewController.RefreshFeedItemsNotification), object: nil, userInfo: apsNotification)
            }
        }
    }
}
