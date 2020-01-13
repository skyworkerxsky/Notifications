//
//  Notifications.swift
//  NotificationsDemo
//
//  Created by Алексей Макаров on 13.01.2020.
//  Copyright © 2020 Алексей Макаров. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
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
