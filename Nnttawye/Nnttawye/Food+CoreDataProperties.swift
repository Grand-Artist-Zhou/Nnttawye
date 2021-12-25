//
//  Food+CoreDataProperties.swift
//  Nnttawye
//
//  Created by Yizhou Li on 12/24/21.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var type: String?
    @NSManaged public var time: String?
    @NSManaged public var fat: Float
    @NSManaged public var calories: Float
    @NSManaged public var cost: Float
    @NSManaged public var carbohydrate: Float
    @NSManaged public var sodium: Float
    @NSManaged public var name: String?

}

extension Food : Identifiable {

}
