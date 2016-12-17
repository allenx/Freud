//
//  PopulationRD.swift
//  Freud
//
//  Created by Allen X on 12/16/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

public struct PopulationRD<T: Hashable> {
    var chromosomes: [Chromosome<T>]
    
    public init(chromosomes: [Chromosome<T>]) {
        self.chromosomes = chromosomes
    }
}
