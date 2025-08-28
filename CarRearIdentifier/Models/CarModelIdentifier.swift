//
//  CarIdentifier.swift
//  CarRearIdentifier
//
//  Created by Matheus on 26/08/25.
//

import SwiftUI
import CoreML
import Vision

class CarIdentifierModel: ObservableObject {
    @Published var identifiedModel: String? = nil
    @Published var isProcessing: Bool = false
    @Published var errorMessage: String? = nil
    
    private var model: CarModelIdentifierV8?
    
    init() {
        do {
            self.model = try CarModelIdentifierV8(configuration: MLModelConfiguration())
        } catch {
            print("Erro ao carregar modelo: \(error)")
            self.errorMessage = "Falha ao carregar modelo."
        }
    }
    
    func classify(image: UIImage) {
        guard let model = self.model else { return }
        
        self.isProcessing = true
        self.errorMessage = nil
        self.identifiedModel = nil
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let pixelBuffer = image.toCVPixelBuffer() else {
                DispatchQueue.main.async {
                    self.errorMessage = "Erro ao converter imagem."
                    self.isProcessing = false
                }
                return
            }
            
            do {
                let input = CarModelIdentifierV8Input(image: pixelBuffer)
                let output = try model.prediction(input: input)
                
                DispatchQueue.main.async {
                    self.identifiedModel = output.target
                    self.isProcessing = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Erro na previsão: \(error.localizedDescription)"
                    self.isProcessing = false
                }
            }
        }
    }
}

extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let modelInputSize = CGSize(width: 360, height: 360) // ajuste p/ o tamanho de input do seu modelo
        
        let image = self.resize(to: modelInputSize)
        let attrs = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
        ] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(image.size.width),
            Int(image.size.height),
            kCVPixelFormatType_32ARGB,
            attrs,
            &pixelBuffer
        )
        
        guard status == kCVReturnSuccess, let pb = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pb, [])
        let pixelData = CVPixelBufferGetBaseAddress(pb)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: pixelData,
            width: Int(image.size.width),
            height: Int(image.size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pb),
            space: rgbColorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            CVPixelBufferUnlockBaseAddress(pb, [])
            return nil
        }
        
        context.translateBy(x: 0, y: image.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()

        CVPixelBufferUnlockBaseAddress(pb, [])
        return pb
    }
    
    func resize(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
