//
//  LoveElixirApp.swift
//  LoveElixir
//
//  Created by Apple  on 14/08/23.
//
//Device token:  ["token": "d-61erQYjU6srShRS6c7bA:APA91bHCElb2Ol76JMMXaQndWOXd6WVDqUGIQdm8E197KyghSHL3jd0E67wqzTX1pkftM0M_WyPsUE3LJSFSg_aJAUn6UVQDo2_oD_d-xPPRfby9GHSribPcjiplKnp8dPEWTxSqof_e"]


//ipad
//e-0EiTy3Ik3Ost0VW-OEIi:APA91bG6o57OhU-85iyaHqHWmOaRHHUN0HgcZPT082G1bFjd_cIBXfEQuZmXY7n9f7c6z3sE0-Dm2iEjxLM-0psVePzNXNr-GDN73vtbvQD6jUU2CniOdPNWjQeTmKvKYiLBkm4eGKuQ

import SwiftUI
import FirebaseCore
import Firebase
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        Messaging.messaging().delegate = self

        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
        print("Device token: ", deviceToken) // This token can be used for testing notifications on FCM
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
    }

    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.banner, .badge, .sound]])
  }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID from userNotificationCenter didReceive: \(messageID)")
    }

    print(userInfo)

    completionHandler()
  }
}


@main
struct LoveElixir: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("LOGIN_STATUS") var isLoggedIn:Bool = false
    @AppStorage("USER_NAME") var userName:String = ""

    
    @State var imageAray:[UIImage] = []
    
  var body: some Scene {
      
    WindowGroup {
      ContentView()
    }
  }
}
