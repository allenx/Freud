//
//  Art_PointGene.swift
//  Freud
//
//  Created by Allen X on 12/17/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

open class PointGene {
    
    var x: Int = 0 {
        didSet {
            if x < 0 || x > 200 {
                x = oldValue
            }
        }
    }
    var y: Int = 0 {
        didSet {
            if y < 0 || y > 200 {
                y = oldValue
            }
        }
    }
    
    static var MaxHeight = 200
    static var MaxWidth = 200
    
    init(shouldRandom: Bool) {
        if shouldRandom {
            x = Int(Random.bounded(min: 0, max: Double(PointGene.MaxHeight)))
            y = Int(Random.bounded(min: 0, max: Double(PointGene.MaxWidth)))
        }
    }
    
    init?(x: Int, y: Int) {
        guard x >= 0, x <= PointGene.MaxWidth, y >= 0, y <= PointGene.MaxHeight else {
            print("Illegal Argument passed in. Coordinate values should be x: between 0 and \(PointGene.MaxWidth), y: between 0 and \(PointGene.MaxHeight)")
            return
        }
        self.x = x
        self.y = y
    }
    
    func clone() -> PointGene {
        return PointGene(x: self.x, y: self.y)!
    }
    
    func mutate(currentDrawing: Drawing) {
        if DiceRoller.willMutateWith(probability: Factors.ActiveMovePointMaxMutationRate) {
            x = Int(Random.bounded(min: 0, max: Double(PointGene.MaxHeight)))
            y = Int(Random.bounded(min: 0, max: Double(PointGene.MaxWidth)))
            currentDrawing.setDirty()
        }
        
        if DiceRoller.willMutateWith(probability: Factors.ActiveMovePointMidMutationRate) {
            x = min(max(0, x + Int(Random.bounded(min: -(Double)(Factors.ActiveMovePointRangeMid), max: Double(Factors.ActiveMovePointRangeMid)))), PointGene.MaxWidth)
            y = min(max(0, y + Int(Random.bounded(min: -(Double)(Factors.ActiveMovePointRangeMid), max: Double(Factors.ActiveMovePointRangeMid)))), PointGene.MaxHeight)
            currentDrawing.setDirty()
        }
        
        if DiceRoller.willMutateWith(probability: Factors.ActiveMovePointMinMutationRate) {
            x = min(max(0, x + Int(Random.bounded(min: -(Double)(Factors.ActiveMovePointRangeMin), max: Double(Factors.ActiveMovePointRangeMid)))), PointGene.MaxWidth)
            y = min(max(0, y + Int(Random.bounded(min: -(Double)(Factors.ActiveMovePointRangeMin), max: Double(Factors.ActiveMovePointRangeMid)))), PointGene.MaxHeight)
            currentDrawing.setDirty()
        }
        
    }
}
