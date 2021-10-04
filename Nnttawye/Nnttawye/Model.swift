//
//  Model.swift
//  Nnttawye
//
//  Created by Yizhou Li on 9/29/21.
//

import Foundation

enum FoodType {
    case desert
    case apetizer
    case drink
    case main
}

enum RestaurantType {
    case dinningHall
    case foodShop
}

class Dish {
    var nameFood : String
    var nameRestaurant : String
    var foodType : FoodType
    var restaurantType : RestaurantType
    var foodTimePeriod : String // b: breakfast, l: lunch, d: dinner. "bd" -> breakfast + dinner
    var energy : Int
    var taste : Int
    var price : Float
    
    init(nameFood : String, nameRestaurant : String, foodType : FoodType, restaurantType: RestaurantType
         , foodTimePeriod : String, energy : Int, taste : Int, price : Float) {
        self.nameFood = nameFood
        self.nameRestaurant = nameRestaurant
        self.foodType = foodType
        self.restaurantType = restaurantType
        self.foodTimePeriod = foodTimePeriod
        self.energy = energy
        self.taste = taste
        self.price = price
    }
}

class UserDemands {
    var energyDemand: Int = 0
    var tasteDemand: Int = 0
    var priceDemand: Float = 0
    var restaurantFreq: Int = 0
    var dishFreq: Int = 0
    var mealTypeDemand: [FoodType] = []
}

class Algorithms {
    // Core algorithm to calculate people's meal schedule
    static func calculateMeals(mealDatabase: [Dish], userDemands: UserDemands) -> [[Dish]] {
        var mealSchedule: [[Dish]] = Array(repeating: Array(repeating: Dish(), count: 3), count: 7)
        var energyCurrent = 0
        var tasteCurrent = 0

        for i in 0..<7 {
            for j in 0..<3 {
                for k in 0..<mealDatabase.count {
                    if energyCurrent < userDemands.energyDemand {
                        mealSchedule[i][j].append(mealDatabase[k])
                        energyCurrent += 1
                    } else if tasteCurrent < userDemands.tasteDemand {
                        mealSchedule[i][j].append(mealDatabase[k])
                        tasteCurrent += 1
                    }
                }
            }
        }
        
        return mealSchedule
    }
    
    
}

