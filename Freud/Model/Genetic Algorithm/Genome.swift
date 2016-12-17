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
    
    var fitness: Double? {
        get {
            guard self.fitnessFunction != nil else {
                print("Please set a fitness function first so you can calculate the fitness")
                return nil
            }
            return self.fitnessFunction!(self)
        }
    }
    
    //It needs a default value, not nil
    var fitnessFunction: ((_ genome: Genome) -> Double)? = nil
    
    init(genes: [Gene], fitnessFunction: @escaping ((_ genome: Genome) -> Double)) {
        self.genes = genes
        self.fitnessFunction = fitnessFunction
    }
    
    init(parentLHS: Genome, parentRHS: Genome, mutationRate: Double) {
        self.genes = []
        for (index, gene) in parentLHS.genes.enumerated() {
            var childGene = gene.mateWith(anotherGene: parentRHS.genes[index])
            if mutationRate != 0 {
                childGene.mutateWith(probability: mutationRate)
            }
            self.genes.append(childGene)
        }
    }
    
    mutating func mutateWith(probability: Double) {
        for (index, gene) in self.genes.enumerated() {
            var foo = gene
            foo.mutateWith(probability: probability)
            self.genes[index] = foo
        }
    }

}
