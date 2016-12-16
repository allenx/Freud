//
//  Genome.swift
//  Freud
//
//  Created by Allen X on 12/15/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

//a genome is a set of genes
public struct Genome {
    var genes: [Gene]
    
    var fitness: Double {
        get {
            return self.fitnessFunction(self)
        }
    }
    
    let fitnessFunction: ((_ genome: Genome) -> Double)
    
    init(genes: [Gene], fitnessFunction: @escaping ((_ genome: Genome) -> Double)) {
        self.genes = genes
        self.fitnessFunction = fitnessFunction
    }
}
