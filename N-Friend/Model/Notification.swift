//
//  Notification.swift
//  N-Friend
//
//  Created by kaito on 2024/04/13.
//

import Foundation
import UserNotifications

func makeNotification(MatchedUsername: String){
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    let content = UNMutableNotificationContent()
    content.title = "マッチ!"
    content.body = "\(MatchedUsername)さんとマッチしたよ!!"
    content.sound = UNNotificationSound.default
    
    let request = UNNotificationRequest(identifier: "notification001", content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}
