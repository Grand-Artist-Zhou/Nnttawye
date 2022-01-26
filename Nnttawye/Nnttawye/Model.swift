//
//  Model.swift
//  Nnttawye
//
//  Created by Yizhou Li on 12/22/21.
//

import Foundation
import SwiftUI

public enum FoodType: String {
    case main
}

public enum FoodTime: String {
    case morning, noon, night
}

enum Method {
    case caloriesLessThan2000, menuShuffler
}

class TextItem: Identifiable {
    var id: String = UUID().uuidString
    var calories: String = ""
    var fat: String = ""
    var carbohydrate: String = ""
    var sodium: String = ""
}

class RecordModel: ObservableObject { // todo: may not need it?
    @Published var rstName: String = "R"
    @Published var fdName: String = "F"
    @Published var fdType: FoodType = .main
    @Published var fdTime: FoodTime = .morning
    @Published var fdcost: String = "0"
    @Published var description: String = ""
    @Published var picture: String = ""
    
    @Published var calories: String = "0"
    @Published var fat: String = "0"
    @Published var carbohydrate: String = "0"
    @Published var sodium: String = "0"
}
