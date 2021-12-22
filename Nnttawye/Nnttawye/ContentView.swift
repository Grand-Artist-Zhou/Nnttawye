//
//  ContentView.swift
//  Nnttawye
//
//  Created by Yizhou Li on 12/21/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var showScanner = true
    
    var body: some View {
        VStack {
//            AddingView()
            Text("Scan")
            .sheet(isPresented: $showScanner, content: {
                ScannerView(didCancelScanning: {}, didFinishScanning: {result in })
            })
//            Text("Summary")
//            Text("Settings")
        }
    }
}

struct AddingView: View {
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
                TextField("", text: $calories)
            }
            HStack {
                Text("Fat")
                TextField("", text: $fat)
            }
            HStack {
                Text("Sodium")
                TextField("", text: $sodium)
            }
            HStack {
                Text("Carbohydrate")
                TextField("", text: $carbohydrate)
            }
        }
    }
}
