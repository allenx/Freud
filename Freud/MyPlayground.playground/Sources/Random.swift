//
//  Random.swift
//  Freud
//
//  Created by Allen X on 12/5/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

struct Random {
    
    static let maxInteger = UInt32.max
    
    static func random(number: UInt32) -> UInt32 {
        return arc4random_uniform(number)
    }
    
    static func fromZeroToOne() -> Double {
        return Double(random(number: maxInteger)) / Double(maxInteger)
    }
    
    static func bounded(min: Double, max: Double) -> Double {
        let amplitude = max - min
        let offset = min
        return offset + amplitude * self.fromZeroToOne()
    }
    
}
