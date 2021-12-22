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
}
