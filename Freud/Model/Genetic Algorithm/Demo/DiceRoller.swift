//
//  DiceRoller.swift
//  Freud
//
//  Created by Allen X on 12/17/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

struct DiceRoller {
    static func willMutateWith(probability: Double) -> Bool {
        let mutationThreshold = UInt32(probability * Double(UInt32.max))
        if arc4random() < mutationThreshold {
            return true
        }
        return false
    }
}
