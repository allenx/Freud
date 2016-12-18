//
//  Art_PolygonGene.swift
//  Freud
//
//  Created by Allen X on 12/17/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

open class PolygonGene {
    
    var numberOfPoints: Int {
        get {
            return points.count
        }
    }
    var points: [PointGene]
    var colour: ColourGene
    
    
    
    init(shouldRandom: Bool) {
        points = []
        if shouldRandom {
            let origin = PointGene(shouldRandom: true)
            for _ in 0..<Factors.ActivePointsPerPolygonMin {
                let point = PointGene(shouldRandom: false)
                point.x = min(max(0, origin.x + Int(Random.bounded(min: -3, max: 3))), PointGene.MaxWidth)
                point.y = min(max(0, origin.y + Int(Random.bounded(min: -3, max: 3))), PointGene.MaxHeight)
                points.append(point)
            }
        }
    
        colour = ColourGene(shouldRandom: true)
    }
    
    init(points: [PointGene], colour: ColourGene) {
        self.points = points
        self.colour = colour
    }
    
    func clone() -> PolygonGene {
//        return PolygonGene(points: points, colour: colour)
        let foo = PolygonGene(shouldRandom: false)
        for point in self.points {
            foo.points.append(point.clone())
        }
        foo.colour = self.colour.clone()
        return foo
    }
    
    func mutate(currentDrawing: Drawing) {
        if DiceRoller.willMutateWith(probability: Factors.ActiveAddPointMutationRate) {
            addPoint(currentDrawing: currentDrawing)
        }
        
        if DiceRoller.willMutateWith(probability: Factors.ActiveRemovePointMutationRate) {
            removePoint(currentDrawing: currentDrawing)
        }
        
        colour.mutate(currentDrawing: currentDrawing)
        for point in points {
            point.mutate(currentDrawing: currentDrawing)
        }
    }
    
    func addPoint(currentDrawing: Drawing) {
        if numberOfPoints < Factors.ActivePointsPerPolygonMax {
            let point = PointGene(shouldRandom: false)
            let index = Int(Random.bounded(min: 1, max: Double(numberOfPoints - 1)))
            
            let previous = points[index - 1]
            let next = points[index]
            
            point.x = (previous.x + next.x) / 2
            point.y = (previous.y + next.y) / 2
            points.insert(point, at: index)
            currentDrawing.setDirty()
        }
    }
    
    func removePoint(currentDrawing: Drawing) {
        if numberOfPoints > Factors.ActivePointsPerPolygonMin {
            if currentDrawing.numberOfPoints > Factors.ActivePointsMin {
                let index = Int(Random.bounded(min: 0, max: Double(numberOfPoints)))
                points.remove(at: index)
                currentDrawing.setDirty()
            }
        }
    }
    
    
}
