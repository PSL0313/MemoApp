//
//  Notification.swift
//  QMemo
//
//  Created by 박선린 on 5/24/25.
//

import UIKit

extension Notification.Name {
    // 메모 저장
    static let memoSaved = Notification.Name("memoSaved")
    
    // 메모 업데이트
    static let memoUpdated = Notification.Name("memoUpdated")
    
    // 알림 클릭시 
    static let didReceiveMemoNotification = Notification.Name("didReceiveMemoNotification")
                                             
}

