//
//  MemoEntityManager.swift
//  QMemo
//
//  Created by 박선린 on 5/21/25.
//

import Foundation
import CoreData
import UIKit

class MemoDataManager {

    static let shared = MemoDataManager()
    private let context: NSManagedObjectContext

    private init() {
        // 앱 델리게이트에서 context 가져오기
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }

    // 📥 메모 추가
    func addMemo(title: String, content: String, alertTime: Date? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        let newMemo = MemoEntity(context: context)
        newMemo.id = UUID()
        newMemo.title = title
        newMemo.content = content
        newMemo.createdAt = Date()
        newMemo.alertTime = alertTime

        if let lat = latitude { newMemo.latitude = lat }
        if let lon = longitude { newMemo.longitude = lon }

        saveContext()
    }

    // 📤 메모 전부 가져오기
    func fetchMemos() -> [MemoEntity] {
        let request: NSFetchRequest<MemoEntity> = MemoEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("❌ 메모 불러오기 실패: \(error)")
            return []
        }
    }

    // 🗑 메모 한개 삭제
    func deleteMemo(_ memo: MemoEntity) {
        context.delete(memo)
        saveContext()
    }
    
    // 🗑 메모 다수 삭제
    func deleteMemos(_ memos: [MemoEntity]) {
        for memo in memos {
            context.delete(memo)
        }
        saveContext()
    }

    // ✏️ 메모 수정 (title, content 변경 예시)
    func updateMemo(_ memo: MemoEntity, title: String, content: String) {
        memo.title = title
        memo.content = content
        saveContext()
    }

    // 💾 저장
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("❌ 저장 실패: \(error)")
        }
    }
}
