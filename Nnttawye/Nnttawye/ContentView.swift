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
                    AddView()
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
    @State private var isPressed: Bool = false
    @State private var chosenMethod: Method = .caloriesLessThan2000
    
    var body: some View {
        VStack {
            if isPressed {
                GenView(chosenMethod: chosenMethod)
            } else {
                Button {
                    isPressed = true
                    chosenMethod = .randomizeSweetGreen
                } label: {
                    Text("Randomize Sweet Green")
                }
                .buttonStyle(BlueButton())
                
                Button {
                    isPressed = true
                    chosenMethod = .caloriesLessThan2000
                } label: {
                    Text("Foods calores add up must less than 2000")
                }
                .buttonStyle(BlueButton())
            }
        }
    }
}

struct GenView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var rsts: [String: [String: Food]] = [:]
    var chosenMethod: Method
    
    struct Methods {

        // A default method allows Nntawye to regulate user's daily calories intake less than 2000
        static func default_DailyCaloriesLessThan2000(rsts: inout [String: [String: Food]]) {
            let persistenceController = PersistenceController.shared
            let viewContext = persistenceController.container.viewContext
            
            let fdFetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
            fdFetchRequest.predicate = NSPredicate(format: "calories < %d", 2000)

            var fds: [Food] = []
            
            rsts.forEach { key, value in
                do {
                    fds = try viewContext.fetch(fdFetchRequest)
                } catch {
                    fatalError()
                }
                
                var canDo: Bool = false
                for i in 0..<fds.count {
                    rsts[key]!["B"]! = fds[i]
                    for j in 0..<fds.count {
                        rsts[key]!["L"]! = fds[j]
                        for k in 0..<fds.count {
                            rsts[key]!["D"]! = fds[k]
                            if rsts[key]!["B"]!.calories + rsts[key]!["L"]!.calories + rsts[key]!["D"]!.calories <= 2000 {
                                canDo = true
                                break
                            }
                        }
                        if canDo {
                            break
                        }
                    }
                    if canDo {
                        break
                    }
                }
                if !canDo {
                    fatalError()
                }
            }
        }
        
    }

    var body: some View {
        List {
            ForEach(Array(rsts.keys.sorted()), id: \.self) { key in
                Section {
                    VStack {
                            Text("Breakfast: \((rsts[key]!["B"]!).name)")
                            HStack {
                                Text("Calories: \((rsts[key]!["B"]!).calories)")
                            }
                            HStack {
                                Text("Carbohydrate: \((rsts[key]!["B"]!).carbohydrate)")
                            }
                        
                        
                        HStack {
                            Text("Lunch: \((rsts[key]!["L"]!).name)")
                            VStack {
                                Text("Calories: \((rsts[key]!["L"]!).calories)")
                                Text("Carbohydrate: \((rsts[key]!["L"]!).carbohydrate)")
                            }
                        }
                        HStack {
                            Text("Dinner: \((rsts[key]!["D"]!).name)")
                            VStack {
                                Text("Calories: \((rsts[key]!["D"]!).calories)")
                                Text("Carbohydrate: \((rsts[key]!["D"]!).carbohydrate)")
                            }
                        }
                    }
                } header: {
                    Text(key)
                }
            }
        }.onAppear {
            // Initialize foods
            let fd = Food(context: viewContext)
            fd.name = "name"
            fd.calories = 0
            fd.carbohydrate = 0
            
            rsts = ["Mon": ["B": fd, "L": fd, "D": fd], "Tue": ["B": fd, "L": fd, "D": fd], "Wed": ["B": fd, "L": fd, "D": fd],
                    "Thu": ["B": fd, "L": fd, "D": fd], "Fri": ["B": fd, "L": fd, "D": fd], "Sat": ["B": fd, "L": fd, "D": fd], "Sun": ["B": fd, "L": fd, "D": fd]]
        
            // Initialize methods array
            if chosenMethod == .caloriesLessThan2000 {
                Methods.default_DailyCaloriesLessThan2000(rsts: &rsts)
            } else if chosenMethod == .randomizeSweetGreen{
                
            }
        }
    }
}

struct ViewDataView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Restaurant.name, ascending: true)], animation: .default)
    private var rsts: FetchedResults<Restaurant>
    
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
                                    Text("Calories: \(fd.calories)")
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
                do {
                    var fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Food")
                    var deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    try viewContext.execute(deleteRequest)
                    try viewContext.save()
                    
                    fetchRequest = NSFetchRequest(entityName: "Restaurant")
                    deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    try viewContext.execute(deleteRequest)
                    try viewContext.save()
                } catch {
                    fatalError()
                }
            }
        }
    }
}

struct AddView: View {
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
                
                if rst.foodArray.contains(where: { $0.name == recordModel.fdName }) {
                    fatalError("Cannot have the same food in a restaurants.")
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
