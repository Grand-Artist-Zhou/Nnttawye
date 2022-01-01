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
    var body: some View {
        VStack {
            Text("1. Foods calores add up must less than 2000")
            Text("2. You cannot have same receipe in a regular day")
            NavigationLink {
                GenView()
            } label: {
                Text("Generate")
            }.padding()
        }
    }
}

struct Method {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Food.name, ascending: true)], animation: .default) private var fds: FetchedResults<Food>
    
    static let shared = Method()
    
    // A default method allows Nntawye to regulate user's daily calories intake less than 2000
    func default_DailyCaloriesLessThan2000(rsts: inout [String: [String: Food]]) -> [String: [String: Food]] {
        rsts.forEach { key, value in
            let bCal = value["B"]!.calories
            let lCal = value["L"]!.calories
            let dCal = value["D"]!.calories
            
            if bCal >= 2000 {
                fds.nsPredicate = NSPredicate(format: "calories < %@", 2000)
                if fds.isEmpty {
                    fatalError()
                } else {
                    rsts[key]!["B"] = fds.first
                }
            }
            
            if bCal + lCal >= 2000 {
                fds.nsPredicate = NSPredicate(format: "calories < %@", 2000 - bCal)
                if fds.isEmpty {
                    fatalError()
                } else {
                    rsts[key]!["L"] = fds.first
                }
            }
            
            if bCal + lCal + dCal >= 2000 {
                fds.nsPredicate = NSPredicate(format: "calories < %@", 2000 - bCal - lCal)
                if fds.isEmpty {
                    fatalError()
                } else {
                    rsts[key]!["D"] = fds.first
                }
            }
        }
        return rsts
    }
}

struct GenView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var rsts: [String: [String: Food]] = [:]
    var methods: [([String: [String: Food]]) -> [String: [String: Food]]] = []
    
    init() {
        let fd = Food(context: viewContext)
        fd.name = "hi"
        fd.calories = 0
        fd.carbohydrate = 0
        
        rsts = ["Mon": ["B": fd, "L": fd, "D": fd], "Tue": ["B": fd, "L": fd, "D": fd], "Wed": ["B": fd, "L": fd, "D": fd],
                "Thu": ["B": fd, "L": fd, "D": fd], "Fri": ["B": fd, "L": fd, "D": fd], "Sat": ["B": fd, "L": fd, "D": fd], "Sun": ["B": fd, "L": fd, "D": fd]]
        
        for i in 0..<methods.count {
            rsts = parseMethodsInOrder(function: methods[i], rsts: rsts)
        }
    }
    
    func parseMethodsInOrder(function: ([String: [String: Food]]) -> [String: [String: Food]], rsts: [String: [String: Food]]) -> [String: [String: Food]] {
        return rsts
    }
    
    var body: some View {
        List {
            ForEach(Array(rsts.keys.sorted()), id: \.self) { key in
                Section {
                    VStack {
                        HStack {
                            Text("Breakfast: \((rsts[key]!["B"]!).name)")
                            VStack {
                                Text("Calories: \((rsts[key]!["B"]!).calories)")
                                Text("Carbohydrate: \((rsts[key]!["B"]!).carbohydrate)")
                            }
                        }
                        Text((rsts[key]!["L"]!).name)
                        Text((rsts[key]!["D"]!).name)
                    }
                } header: {
                    Text(key)
                }
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
                    Section() {
                        Text("Restaurant: \(rst.name)")
                        ForEach(rst.foodArray, id: \.self) { fd in
                            HStack {
                                Text("Food: \(fd.name)")
                                VStack {
                                    Text("Type: \(fd.type)")
                                    Text("Time: \(fd.time)")
                                    Text("Cost: \(fd.cost)")
                                }
                            }
                        }.onDelete { indexSet in
                            for index in indexSet {
                                let foodToDelete = rst.foodArray[index]
                                rst.removeFromFoods(foodToDelete)
                            }
                            do {
                                try viewContext.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let rst = rsts[index]
                        let foodsToDelete = rst.foods
                        rst.removeFromFoods(foodsToDelete)
                        
                        viewContext.delete(rsts[index])
                    }
                    do {
                        try viewContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Restaurant.name, ascending: true)], animation: .default) private var rsts: FetchedResults<Restaurant>
    @EnvironmentObject var recordModel: RecordModel
    
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
                Picker("", selection: $recordModel.fdType) {
                    Text("Main").tag(FoodType.main)
                }
            }
            HStack {
                Text("FoodTime")
                Picker("", selection: $recordModel.fdTime) {
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
                let rst: Restaurant
                rsts.nsPredicate = NSPredicate(format: "name == %@", recordModel.rstName)
                
                if rsts.isEmpty {
                    rst = Restaurant(context: viewContext)
                    rst.name = recordModel.rstName
                } else {
                    rst = rsts.first!
                }
                
                let fd = Food(context: viewContext)
                fd.name = recordModel.fdName
                fd.type = (recordModel.fdType).rawValue
                fd.time = (recordModel.fdTime).rawValue
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
