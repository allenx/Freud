//
//  GeneticAlgorithmView.swift
//  Freud
//
//  Created by Allen X on 12/12/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation
import UIKit
import GLKit




class GeneticAlgorithmView: UIView {
    
    var currentDrawing: Drawing! {
        didSet {
            //self.setNeedsDisplay()
        }
    }
    
    
    convenience init(currentDrawing: Drawing) {
        self.init()
        self.frame = CGRect(x: 40, y: 40, width: 200, height: 200)
        self.backgroundColor = .black
        self.currentDrawing = currentDrawing
        
    }
    
    
    override func draw(_ rect: CGRect) {
        for polygon in currentDrawing.polygons {
            let aPath = UIBezierPath()
            let color = UIColor(colorLiteralRed: Float(polygon.colour.R) / 255.0, green: Float(polygon.colour.G) / 255.0, blue: Float(polygon.colour.B) / 255.0, alpha: Float(polygon.colour.A) / 255.0)
            color.set()
            color.setFill()
            for (index, point) in polygon.points.enumerated() {
                if index == 0 {
                    aPath.move(to: CGPoint(x: CGFloat(point.x), y: CGFloat(point.y)))
                } else {
                    aPath.addLine(to: CGPoint(x: CGFloat(point.x), y: CGFloat(point.y)))
                }
            }
            aPath.close()
            aPath.fill()
            aPath.stroke()
            
        }
        
    }
}
