//
//  NnttawyeTests.swift
//  NnttawyeTests
//
//  Created by Yizhou Li on 9/18/21.
//

import XCTest
@testable import Nnttawye

class NnttawyeTests: XCTestCase {
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
    
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let userDemand = UserDemands()
        userDemand.energyDemand = 5
        userDemand.tasteDemand = 5
        
        Algorithms.calculateMeals(mealDatabase: data, userDemands: userDemand)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
