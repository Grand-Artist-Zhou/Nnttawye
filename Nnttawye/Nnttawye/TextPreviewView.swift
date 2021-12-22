//
//  TextPreviewView.swift
//  Nnttawye
//
//  Created by Yizhou Li on 12/22/21.
//

import SwiftUI

struct TextPreviewView: View {
    var text: String
    
    var body: some View {
        VStack {
            ScrollView {
                Text(text)
                    .font(.body)
                    .padding()
            }
        }
    }
}
