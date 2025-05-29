//
//  MemoEntity+CoreDataProperties.swift
//  QMemo
//
//  Created by 박선린 on 5/27/25.
//
//

import Foundation
import CoreData


extension MemoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoEntity> {
        return NSFetchRequest<MemoEntity>(entityName: "MemoEntity")
    }

    @NSManaged public var alertTime: Date?
    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var title: String?
    @NSManaged public var isFavorite: Bool

}

extension MemoEntity : Identifiable {

}
