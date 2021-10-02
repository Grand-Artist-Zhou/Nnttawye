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

var data = [Dish(nameFood : "Milk-chocalate", nameRestaurant : "UMD Dinning Hall", foodType : .drink, restaurantType: .dinningHall
                        , foodTimePeriod : "bld", energy : 2, taste : 2, price : 0),
            Dish(nameFood : "Milk-2%milk", nameRestaurant : "UMD Dinning Hall", foodType : .drink, restaurantType: .dinningHall
                        , foodTimePeriod : "bld", energy : 1, taste : 1, price : 0),
            Dish(nameFood : "Smoothie", nameRestaurant : "UMD Dinning Hall", foodType : .drink, restaurantType: .dinningHall
                        , foodTimePeriod : "bld", energy : 1, taste : 3, price : 0),
            Dish(nameFood : "Chicken", nameRestaurant : "UMD Dinning Hall", foodType : .main, restaurantType: .dinningHall
                        , foodTimePeriod : "ld", energy : 3, taste : 3, price : 0),
            Dish(nameFood : "Spagheti", nameRestaurant : "UMD Dinning Hall", foodType : .main, restaurantType: .dinningHall
                        , foodTimePeriod : "d", energy : 3, taste : 3, price : 0),
            Dish(nameFood : "Beef", nameRestaurant : "UMD Dinning Hall", foodType : .main, restaurantType:  .dinningHall
                        , foodTimePeriod : "ld", energy : 3, taste : 2, price : 0),
            Dish(nameFood : "Noodle", nameRestaurant : "UMD Dinning Hall", foodType : .main, restaurantType:  .dinningHall
                        , foodTimePeriod : "d", energy : 2, taste : 2, price : 0),
            Dish(nameFood : "Coffee-Americano", nameRestaurant : "Vigilante", foodType : .drink, restaurantType: .foodShop
                        , foodTimePeriod : "bld", energy : 3, taste : 1, price : 7),
            Dish(nameFood : "Coffee-Lattie", nameRestaurant : "Vigilante", foodType : .drink, restaurantType: .foodShop
                        , foodTimePeriod : "bld", energy : 3, taste : 2, price : 7),
            Dish(nameFood : "HotHonneyChickenPlate", nameRestaurant : "SweetGreen", foodType : .main, restaurantType: .foodShop
                        , foodTimePeriod : "ld", energy : 2, taste : 2, price : 13),
]

