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
                    Text("AddData")
                }.padding()
                                
                NavigationLink {
                    ViewDataView()
                } label: {
                    Text("ViewData")
                }.padding()
                
                NavigationLink {
                    PredictionView()
                } label: {
                    Text("Predict")
                }.padding()
            }
        }
    }
}

struct PredictionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Food.name, ascending: true)], predicate: NSPredicate(format: "time == %@", "Morning"), animation: .default) private var fds: FetchedResults<Food> //TODO: predicate problems

    var body: some View {
        List {
            ForEach(fds) { fd in
                Text(fd.name)
            }
        }
    }
}

struct ViewDataView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Restaurant.name, ascending: true)], animation: .default)
    private var rsts: FetchedResults<Restaurant>
    
    private func deleteItems(offsets: IndexSet) {
            offsets.map { rsts[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(rsts) { rst in
                    Text("Restaurant: \(rst.name!)")
                    Text("Food: \(rst.foods!)")
                    Text("Time: \(rst.foods!.description)")
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            Button("Delete all") {

            }
        }
    }
}

struct AddingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var recordModel: RecordModel
    
    @State private var selectedFdType = FoodType.default_
    @State private var selectedFdTime = FoodTime.default_
    @State private var showScanner = false
    @State private var isRecognizing = false
    
    var body: some View {
        VStack{
            HStack {
                Text("Restaurant")
                TextField("", text: $recordModel.rstName)
            }
            HStack {
                Text("Food")
                TextField("", text: $recordModel.fdName)
            }
            HStack {
                Text("FoodType")
                Picker("", selection: $selectedFdType) {
                    Text("Main").tag(FoodType.main)
                }
            }
            HStack {
                Text("FoodTime")
                Picker("", selection: $selectedFdTime) {
                    Text("Morning").tag(FoodTime.morning)
                    Text("Noon").tag(FoodTime.noon)
                    Text("Night").tag(FoodTime.night)
                }
            }
            HStack {
                Text("Cost")
                TextField("", text: $recordModel.fdcost)
            }
            HStack {
                Text("Calories")
                TextField("", text: $recordModel.calories)
            }
            HStack {
                Text("Fat")
                TextField("", text: $recordModel.fat)
            }
            HStack {
                Text("Sodium")
                TextField("", text: $recordModel.sodium)
            }
            HStack {
                Text("Carbohydrate")
                TextField("", text: $recordModel.carbohydrate)
            }
            Button("Save") {
                let rst = Restaurant(context: viewContext)
                rst.name = recordModel.rstName
                
                let fd = Food(context: viewContext)
                fd.name = recordModel.fdName
                fd.type = recordModel.fdType
                fd.time = recordModel.fdtime
                fd.cost = Float(recordModel.fdcost) ?? 0
                
                fd.calories = Float(recordModel.calories) ?? 0
                fd.fat = Float(recordModel.fat) ?? 0
                fd.sodium = Float(recordModel.sodium) ?? 0
                fd.carbohydrate = Float(recordModel.carbohydrate) ?? 0
                
                rst.addToFoods(fd)
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
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
                    
                    TextRecognition(scannedImages: scannedImages) {
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
