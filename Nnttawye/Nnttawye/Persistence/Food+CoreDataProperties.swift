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
    
    @NSManaged public var name: String
    @NSManaged public var type: String
    var fdType: FoodType {
        set {
            type = newValue.rawValue
        }
        get {
            FoodType(rawValue: type) ?? .main
        }
    }
    
    @NSManaged public var time: String
    var fdTime: FoodTime {
        set {
            time = newValue.rawValue
        }
        get {
            FoodTime(rawValue: time) ?? .morning
        }
    }
    @NSManaged public var cost: Float
    
    @NSManaged public var fat: Float
    @NSManaged public var calories: Float
    @NSManaged public var carbohydrate: Float
    @NSManaged public var sodium: Float
    @NSManaged public var origin: Restaurant

}

extension Food : Identifiable {
    
}
