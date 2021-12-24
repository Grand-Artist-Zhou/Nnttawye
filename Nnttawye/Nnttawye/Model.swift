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

class RecognizedContent: ObservableObject {
    @Published var calories: String = ""
    @Published var fat: String = ""
    @Published var carbohydrate: String = ""
    @Published var sodium: String = ""
}
