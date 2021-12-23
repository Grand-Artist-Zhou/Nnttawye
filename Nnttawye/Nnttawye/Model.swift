//
//  Model.swift
//  Nnttawye
//
//  Created by Yizhou Li on 12/22/21.
//

import Foundation

class TextItem: Identifiable {
    var id: String
    var text: String = ""
    
    init() {
        id = UUID().uuidString
    }
}

class RecognizedContent: ObservableObject {
    @Published var items = [TextItem]()
    @Published var calories: Float = 0
    @Published var fat: Float = 0
    @Published var carbohydrate: Float = 0
    @Published var sodium: Float = 0
}
