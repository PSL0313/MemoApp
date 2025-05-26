//
//  Untitled.swift
//  QMemo
//
//  Created by 박선린 on 5/26/25.
//

import UIKit
import UserNotifications

class AlertTimeNotiManager {
    static let shared = AlertTimeNotiManager()
    private init() {}
    
    // 📌 알림 등록
    func alertTimeAdd(id: String, title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = ["memoID": id]

        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ 알림 등록 실패: \(error)")
            } else {
                print("✅ 알림 등록 완료")
            }
        }
    }
    
    // 🧼 기존 알림 삭제
    func alertTimeDelete(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        print("🗑 알림 취소: \(id)")
    }

    // 🔁 알림 수정 = 기존 취소 + 새로 등록
    func updateAlertTime(id: String, title: String, body: String, date: Date) {
        alertTimeDelete(id: id)
        alertTimeAdd(id: id, title: title, body: body, date: date)
    }
}
