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
    func addMemo(uuid: UUID, title: String, content: String, isFavorite: Bool, alertTime: Date? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        let newMemo = MemoEntity(context: context)
        newMemo.id = uuid
        newMemo.title = title
        newMemo.content = content
        newMemo.isFavorite = isFavorite
        newMemo.createdAt = Date()
        newMemo.alertTime = alertTime

        if let lat = latitude { newMemo.latitude = lat }
        if let lon = longitude { newMemo.longitude = lon }

        saveContext()
    }

    // 📤 메모 전부 가져오기
    func fetchMemos() -> [MemoEntity] {
        let request: NSFetchRequest<MemoEntity> = MemoEntity.fetchRequest()

        // ⭐️ 즐겨찾기 먼저 정렬 (true가 위로 오게 = 내림차순), 다음은 생성일 기준
//        let favoriteSort = NSSortDescriptor(key: "isFavorite", ascending: false)
        let dateSort = NSSortDescriptor(key: "createdAt", ascending: false)

        request.sortDescriptors = [ dateSort] //favoriteSort,

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
    func updateMemo(_ memo: MemoEntity, title: String, content: String, isFavorite: Bool, alertTime: Date? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        memo.title = title
        memo.content = content
        memo.isFavorite = isFavorite 
        memo.alertTime = alertTime  // 덮어쓰기 허용
        memo.latitude = latitude ?? 0
        memo.longitude = longitude ?? 0
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
    
    // 메모를 아이디로 검색하여 가져옴
    func fetchMemo(byID id: UUID) -> MemoEntity? {
        let request: NSFetchRequest<MemoEntity> = MemoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        do {
            return try context.fetch(request).first
        } catch {
            print("❌ 특정 메모 불러오기 실패: \(error)")
            return nil
        }
    }
    
    func alarmJoinfetchMemo(by id: UUID) -> MemoEntity? {
        let fetchRequest: NSFetchRequest<MemoEntity> = MemoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("❌ 메모 찾기 실패: \(error)")
            return nil
        }
    }
}
