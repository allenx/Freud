//
//  GeneRD.swift
//  Freud
//
//  Created by Allen X on 12/16/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

public struct GeneRD<T: Hashable>: Hashable {
    public let value: T
    
    public var hashValue: Int {
        return self.value.hashValue
    }
    
    public init(value: T) {
        self.value = value
    }
}

public func ==<T:Hashable>(lhs: GeneRD<T>, rhs: GeneRD<T>) -> Bool {
    return lhs.value == rhs.value
}

