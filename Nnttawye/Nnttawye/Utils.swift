//
//  Utils.swift
//  Nnttawye
//
//  Created by Yizhou Li on 1/11/22.
//

import Foundation
import SwiftUI

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

enum Method {
    case caloriesLessThan2000
    case randomizeSweetGreen
}
