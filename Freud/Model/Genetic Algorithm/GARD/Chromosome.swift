//
//  Chromosome.swift
//  Freud
//
//  Created by Allen X on 12/16/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

public struct Chromosome<T: Hashable> {
    var genes: [GeneRD<T>]
    let fitnessFunction: ((_ chromosome: [T]) -> Double)
    
    var fitness: Double {
        get {
            return self.fitnessFunction(self.genes.map {
                return $0.value
            })
        }
    }
    
    init(genes: [GeneRD<T>], fitnessFunction: @escaping (_ chromosome: [T]) -> Double) {
        self.genes = genes
        self.fitnessFunction = fitnessFunction
    }
}
