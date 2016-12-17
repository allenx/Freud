//
//  FitnessCalculator.swift
//  Freud
//
//  Created by Allen X on 12/17/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation
import UIKit

struct FitnessCalculator {
    
    static var sourcePixelData: [PixelData] = []
    
    static func calculateFitnessFor(currentDrawingView: UIView) -> Double {

        var error: Int = 0
        
        let image1 = UIImage.imageFrom(view: currentDrawingView)
        var currentArr: [PixelData] = []
        for i in 0..<200 {
            for j in 0..<200 {
                let foo1 = image1.rgbUInt8(atPos: CGPoint(x: i, y: j))
                let foo = PixelData(a: foo1.alpha, r: foo1.red, g: foo1.green, b: foo1.blue)
                currentArr.append(foo)
            }
        }
        
        for (index, pixel) in currentArr.enumerated() {
            let sourcePixel = FitnessCalculator.sourcePixelData[index]
            let deltaR = Int(pixel.r) - Int(sourcePixel.r)
            let deltaG = Int(pixel.g) - Int(sourcePixel.g)
            let deltaB = Int(pixel.b) - Int(sourcePixel.b)
            
            let delta = deltaR*deltaR + deltaG*deltaG + deltaB*deltaB
            error += delta
        }

        return Double(error)
    }
    
   
}
