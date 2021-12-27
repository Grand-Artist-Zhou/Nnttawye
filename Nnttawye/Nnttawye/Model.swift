//
//  Model.swift
//  Nnttawye
//
//  Created by Yizhou Li on 12/22/21.
//

import Foundation

class TextItem: Identifiable {
    var id: String = UUID().uuidString
    var calories: String = ""
    var fat: String = ""
    var carbohydrate: String = ""
    var sodium: String = ""
}

class RecordModel: ObservableObject {
    @Published var rstName: String = ""
    @Published var fdName: String = ""
    @Published var fdType: String = ""
    @Published var time: String = ""
    @Published var cost: String = ""

    @Published var calories: String = ""
    @Published var fat: String = ""
    @Published var carbohydrate: String = ""
    @Published var sodium: String = ""
}
