//
//  NotificationHandler.swift
//  LoveElixir
//
//  Created by Apple  on 05/09/23.
//

import Foundation
import UserNotifications

class NotificationHandler {
    
    func askPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { success, error in
            if success{
                print("access granted")
            }else if let error = error{
                print(error.localizedDescription)
            }
        }
    }
    
    func sendNotification(date:Date,type:String,timeInterval:Double , title:String ,body:String){
        var trigger:UNNotificationTrigger?
        
        if type == "date"{
            let dateComponents = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        }else if type == "time"{
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

import SwiftUI

struct NotifyMe: View {
   
    var body: some View {
        Button("show notification in 3s "){
            let notify = NotificationHandler()
            notify.sendNotification(date: Date(), type: "time", timeInterval: 3,title: "tiel", body: "This is a reminder")
        }
    }
}


