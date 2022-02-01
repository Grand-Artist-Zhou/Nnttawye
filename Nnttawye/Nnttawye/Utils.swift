//
//  Utils.swift
//  Nnttawye
//
//  Created by Yizhou Li on 1/11/22.
//

import Foundation
import SwiftUI
import Vision

struct Icon: Identifiable {
    let id: UUID = UUID()
    let name: String
    let icon: String
    var items: [Icon]?

    static let res = Icon(name: "Which Res", icon: "square.and.pencil")
    static let des = Icon(name: "Description", icon: "bolt.fill")
    static let pic = Icon(name: "Picture", icon: "mic")

    // some example groups
    static let g1 = Icon(name: "Title", icon: "star", items: [Icon.res, Icon.des, Icon.pic])
}

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .frame(width: 100, height: 100, alignment: .center)
    }
}

struct TextRecognition {
    var scannedImages: [UIImage]
    @EnvironmentObject var recordModel: RecordModel
    var didFinishRecognition: () -> Void
    
    func recognizeText() {
        DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated).async {
            for image in scannedImages {
                guard let cgImage = image.cgImage else { return }
                
                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                
                do {
                    let textItem = TextItem()
                    try requestHandler.perform([getTextRecognitionRequest(with: textItem)])
                    
                    DispatchQueue.main.async {
                        recordModel.carbohydrate = textItem.carbohydrate
                        recordModel.calories = textItem.calories
                        recordModel.fat = textItem.fat
                        recordModel.sodium = textItem.sodium
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    didFinishRecognition()
                }
            }
        }
    }
    
    private func getTextRecognitionRequest(with textItem: TextItem) -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            observations.forEach { observation in
                guard let recognizedText = observation.topCandidates(1).first else { return }
                
                func useRegex(pattern: String) -> Bool {
                    let regex = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
                    let range = NSRange(location: 0, length: recognizedText.string.count)
                    let matches = regex.matches(in: recognizedText.string, options: [], range: range)
                    return matches.first != nil
                }
                
                func extractVal() -> Float? {
                    let str = recognizedText.string
                    let strArr = str.split(separator: " ")
                    
                    for item in strArr {
                        let part = item.components(separatedBy: CharacterSet.init(charactersIn: "0123456789.").inverted).joined()
                        
                        if let val = Float(part) {
                            return val
                        }
                    }
                    
                    return nil
                }
                
                if useRegex(pattern: "Carbohydrate [0-9]+"), let val = extractVal() {
                    textItem.carbohydrate = String(val)
                }
                if useRegex(pattern: "Calories [0-9]+"), let val = extractVal() {
                    textItem.calories = String(val)
                }
                if useRegex(pattern: "Fat [0-9]+"), let val = extractVal() {
                    textItem.fat = String(val)
                }
                if useRegex(pattern: "Sodium [0-9]+"), let val = extractVal() {
                    textItem.sodium = String(val)
                }
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        return request
    }
}
