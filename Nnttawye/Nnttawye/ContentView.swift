//
//  ContentView.swift
//  Nnttawye
//
//  Created by Yizhou Li on 12/21/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    AddingView()
                } label: {
                    Text("Adding")
                }
                NavigationLink {
                    Text("Under construction...")
                } label: {
                    Text("Summary")
                }
            }
        }
    }
}

struct AddingView: View {
    @StateObject var recognizedContent = RecognizedContent()
    @State private var showScanner = false
    @State private var isRecognizing = false
    
    @State private var rstName: String = ""
    @State private var fdName: String = ""
    @State private var fdType: String = ""
    @State private var time: String = ""
    @State private var cost: String = ""
    @State private var calories: String = ""
    @State private var fat: String = ""
    @State private var sodium: String = ""
    @State private var carbohydrate: String = ""
    
    var body: some View {
        VStack{
            HStack {
                Text("Restaurant")
                TextField("name", text: $rstName)
            }
            HStack {
                Text("Food")
                TextField("name", text: $fdName)
            }
            HStack {
                Text("Type")
                TextField("", text: $fdType)
            }
            HStack {
                Text("Time")
                TextField("", text: $time)
            }
            HStack {
                Text("Cost")
                TextField("", text: $cost)
            }
            HStack {
                Text("Calories")
                TextField("", text: $recognizedContent.calories)
            }
            HStack {
                Text("Fat")
                TextField("", text: $recognizedContent.fat)
            }
            HStack {
                Text("Sodium")
                TextField("", text: $recognizedContent.sodium)
            }
            HStack {
                Text("Carbohydrate")
                TextField("", text: $recognizedContent.carbohydrate)
            }
        }
        .navigationBarItems(trailing: Button(action: {
            guard !isRecognizing else { return }
            showScanner = true
        }, label: {
            HStack {
                Image(systemName: "doc.text.viewfinder")
                    .renderingMode(.template)
                    .foregroundColor(.white)
                
                Text("Scan")
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .frame(height: 36)
            .background(Color(UIColor.systemIndigo))
            .cornerRadius(18)
        }))
        .sheet(isPresented: $showScanner, content: {
            ScannerView { result in
                switch result {
                case .success(let scannedImages):
                    isRecognizing = true
                    
                    TextRecognition(scannedImages: scannedImages,
                                    recognizedContent: recognizedContent) {
                        // Text recognition is finished, hide the progress indicator.
                        isRecognizing = false
                    }.recognizeText()
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                showScanner = false
                
            } didCancelScanning: {
                // Dismiss the scanner controller and the sheet.
                showScanner = false
            }
        })
    }
}
