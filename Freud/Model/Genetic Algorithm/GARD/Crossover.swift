//
//  Crossover.swift
//  Freud
//
//  Created by Allen X on 12/16/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

public protocol Crossover {
    var crossoverRate: Double {
        get set
    }
    init(crossoverRate: Double)
    
    func crossover<T:Hashable>(lhs: [GeneRD<T>], rhs: [GeneRD<T>]) -> (childL: [GeneRD<T>], childR: [GeneRD<T>])
}

