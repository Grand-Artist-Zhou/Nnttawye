//
//  Model.swift
//  Nnttawye
//
//  Created by Yizhou Li on 12/22/21.
//

import Foundation
import SwiftUI

enum FoodType {
    case default_, main
}

enum FoodTime {
    case default_, morning, noon, night
}

class TextItem: Identifiable {
    var id: String = UUID().uuidString
    var calories: String = ""
    var fat: String = ""
    var carbohydrate: String = ""
    var sodium: String = ""
}

class RecordModel: ObservableObject {
    @Published var rstName: String = "None"
    @Published var fdName: String = "None"
    @Published var fdType: FoodType = .default_
    @Published var fdtime: FoodTime = .default_
    @Published var fdcost: String = "0"
    
    @Published var calories: String = "0"
    @Published var fat: String = "0"
    @Published var carbohydrate: String = "0"
    @Published var sodium: String = "0"
}
