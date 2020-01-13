//
//  AppDelegate.swift
//  NotificationsDemo
//
//  Created by Алексей Макаров on 11.01.2020.
//  Copyright © 2020 Алексей Макаров. All rights reserved.
//

import UIKit
import NotificationCenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        requestAuthorization()
        notificationCenter.delegate = self
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
    
    // запрос на отправку уведомлений
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSetting()
        }
    }
    
    // запрос настроек из центра уведомлений
    func getNotificationSetting() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }
    
    // создание уведомления
    func scheduleNotificaion(notificationType: String) {
        
        let content = UNMutableNotificationContent()
        let userActions = "User Actions" // id для категории действий
        
        content.title = notificationType
        content.body = "This is example how to create \(notificationType)"
        content.sound = UNNotificationSound.default
        content.badge = 1
        // вкл. созданные действия в центре уведомлений
        content.categoryIdentifier = userActions
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifie = "Local Notification"
        let request = UNNotificationRequest(identifier: identifie, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error", error.localizedDescription)
            }
        }
        
        // Создаем действия для уведомления
        let snoozeAction = UNNotificationAction(identifier: "snooze", title: "Отложить", options: [])
        let deleteAction = UNNotificationAction(identifier: "delete", title: "Удалить", options: [.destructive])
        
        // создали категории для действий
        let category = UNNotificationCategory(identifier: userActions,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        
        // регистрируем созданую категорию в центре уведомлений
        notificationCenter.setNotificationCategories([category])
    }
    
}

// MARK: - Extension

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Теперь уведомления срабатывают когда приложение находится на переднем плане
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Срабатывает при открытом приложении alert, sound
        completionHandler([.alert, .sound])
    }
    
    //
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // обработка уведомления по id
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notification with the local notificaion identifire")
        }
        
        // обработка действий
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier: // отклонение уведомления из центра уведомлений
        print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier: // когда пользователь просто тапнул по уведомлению и открыл приложение
            print("Default")
        case "snooze":
            print("Отложить")
            scheduleNotificaion(notificationType: "Reminder")
        case "delete":
            print("Удалить")
        default:
            print("Unknown action")
        }
        
        completionHandler()
    }
}

