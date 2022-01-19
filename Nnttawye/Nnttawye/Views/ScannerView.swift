//
//  Test.swift
//  Nnttawye
//
//  Created by Yizhou Li on 12/21/21.
//

import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    var didFinishScanning: ((_ result: Result<[UIImage], Error>) -> Void)
    var didCancelScanning: () -> Void
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) { }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }
    
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let scannerView: ScannerView
        
        init(with scannerView: ScannerView) {
            self.scannerView = scannerView
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            var scannedPages = [UIImage]()
   
            // We only pick the first image scanned.
            scannedPages.append(scan.imageOfPage(at: 0))
            
            scannerView.didFinishScanning(.success(scannedPages))
        }
        
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            scannerView.didCancelScanning()
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            scannerView.didFinishScanning(.failure(error))
        }
    }
    
}
