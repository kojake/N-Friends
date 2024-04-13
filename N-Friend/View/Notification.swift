//
//  Notification.swift
//  N-Friend
//
//  Created by kaito on 2024/04/13.
//

import Foundation
import UserNotifications

func makeNotification(){
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    let content = UNMutableNotificationContent()
    content.title = "ローカル通知"
    content.body = "ローカル通知を発行しました"
    content.sound = UNNotificationSound.default
    
    let request = UNNotificationRequest(identifier: "notification001", content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}
