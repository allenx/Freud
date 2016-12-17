//
//  Population.swift
//  Freud
//
//  Created by Allen X on 12/12/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation



public struct Population {
    
    var generation: [Genome]
    var mutationRate = 0.01
    
    var sortedGeneration: [Genome] {
        get {
            return self.generation.sorted {
                $0.fitness! > $1.fitness!
            }
        }
    }
    
    init(generation: [Genome]) {
        self.generation = generation
    }
    
//    init(populationSize: Int, geneLength: Int, geneRange: ) {
//        <#statements#>
//    }
}
