//
//  Art_ColourGene.swift
//  Freud
//
//  Created by Allen X on 12/17/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

open class ColourGene {
    
    var R: Int = 0 {
        didSet {
            if R < 0 || R > 255 {
                R = oldValue
            }
        }
    }
    var G: Int = 0 {
        didSet {
            if G < 0 || G > 255 {
                G = oldValue
            }
        }
    }
    var B: Int = 0 {
        didSet {
            if B < 0 || B > 255 {
                B = oldValue
            }
        }
    }
    var A: Int = 0 {
        didSet {
            if A < 0 || A > 255 {
                A = oldValue
            }
        }
    }
    
    init(shouldRandom: Bool) {
        if shouldRandom {
            R = Int(Random.bounded(min: 0, max: 255))
            G = Int(Random.bounded(min: 0, max: 255))
            B = Int(Random.bounded(min: 0, max: 255))
            A = Int(Random.bounded(min: 10, max: 60))
        }
    }
    
    init?(R: Int, G: Int, B: Int, A: Int) {
        guard R >= 0, R <= 255, G >= 0, G <= 255, B >= 0, B <= 255 else {
            print("Illegal Argument passed in. RGBA values should be between 0 and 255")
            return
        }
        self.R = R
        self.G = G
        self.B = B
        self.A = A
    }
    
    func clone() -> ColourGene {
        return ColourGene(R: self.R, G: self.G, B: self.B, A: self.A)!
    }
    
    func mutate(currentDrawing: Drawing) {
        if DiceRoller.willMutateWith(probability: Factors.ActiveRedMutationRate) {
            R = Int(Random.bounded(min: 0, max: 255))
            currentDrawing.setDirty()
        }
        if DiceRoller.willMutateWith(probability: Factors.ActiveGreenMutationRate) {
            G = Int(Random.bounded(min: 0, max: 255))
            currentDrawing.setDirty()
        }
        if DiceRoller.willMutateWith(probability: Factors.ActiveBlueMutationRate) {
            B = Int(Random.bounded(min: 0, max: 255))
            currentDrawing.setDirty()
        }
        if DiceRoller.willMutateWith(probability: Factors.ActiveAlphaMutationRate) {
            A = Int(Random.bounded(min: 30, max: 60))
            currentDrawing.setDirty()
        }
    }
}
