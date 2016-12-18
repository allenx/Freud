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
    
    static func calculateSampleFitnessFor(currentDrawing: Drawing) -> Double {
        var error: Int = 0
        var sampleColourArr: [ColourGene] = []
        for i in 0..<5000 {
            let point = PointGene(shouldRandom: true)
            var colour = ColourGene(shouldRandom: false)
            for polygon in currentDrawing.polygons {
                if point.isInPolygon(polygon: polygon) {
                    //colour = colour.newColourBlended(anotherColour: polygon.colour)
                    colour = polygon.colour
                    
                }
            }
            let index = point.x * point.y
            let sourcePixel = FitnessCalculator.sourcePixelData[point.x * point.y]
            let deltaR = colour.R - Int(sourcePixel.r)
            let deltaG = colour.G - Int(sourcePixel.g)
            let deltaB = colour.B - Int(sourcePixel.b)
            let delta = deltaR*deltaR + deltaG*deltaG + deltaB*deltaB
            error += delta
        }
        return Double(error)
    }
}


extension PointGene {
    func isInPolygon(polygon: PolygonGene) -> Bool {
        var n = polygon.numberOfPoints - 1
        var res = false
        for i in 0..<n+1 {
            if (polygon.points[i].y < self.y && polygon.points[n].y >= self.y) || (polygon.points[n].y < self.y && polygon.points[i].y >= self.y) {
                if Double(polygon.points[i].x) + (Double(self.y-polygon.points[i].y))/Double(polygon.points[n].y-polygon.points[i].y)*Double(polygon.points[n].x-polygon.points[i].x) < Double(self.x) {
                    res = !res
                }
            }
            n = i
        }
        return res
    }
}

extension ColourGene {
    func newColourBlended(anotherColour: ColourGene) -> ColourGene {
        
        if self.R == 0 && self.G == 0 && self.B == 0 && self.A == 255 {
            return anotherColour
        }
        
        let R = Int(Double(self.R * self.A + anotherColour.R * (255 - self.A)) / 65025.0)
        let G = Int(Double(self.G * self.A + anotherColour.G * (255 - self.A)) / 65025.0)
        let B = Int(Double(self.R * self.A + anotherColour.B * (255 - self.A)) / 65025.0)
        let A = self.A
        return ColourGene(R: R, G: G, B: B, A: A)!
    }
}
