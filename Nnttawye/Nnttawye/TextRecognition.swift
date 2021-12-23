//
//  TextRecognition.swift
//  Nnttawye
//
//  Created by Yizhou Li on 12/22/21.
//

import SwiftUI
import Vision

struct TextRecognition {
    var scannedImages: [UIImage]
    @ObservedObject var recognizedContent: RecognizedContent
    var didFinishRecognition: () -> Void
    
    func recognizeText() {
        let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
        queue.async {
            for image in scannedImages {
                guard let cgImage = image.cgImage else { return }
                
                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                
                do {
                    let textItem = TextItem()
                    try requestHandler.perform([getTextRecognitionRequest(with: textItem)])
                    
                    DispatchQueue.main.async {
                        recognizedContent.items.append(textItem)
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
                    print(val)
                } else if useRegex(pattern: "Calories [0-9]+"), let val = extractVal() {
                    
                } else if useRegex(pattern: "Fat [0-9]+"), let val = extractVal() {
                    
                } else if useRegex(pattern: "Sodium [0-9]+"), let val = extractVal() {
                   
                }
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        return request
    }
}
