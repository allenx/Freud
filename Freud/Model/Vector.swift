//
//  Vector.swift
//  Freud
//
//  Created by Allen X on 10/20/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Accelerate

public struct Vector {
    
    //Flatten the vector into a 1-D array
    var flat: [Double]
    
    
    public init(size: Int) {
        self.flat = [Double](repeating: 0.0, count: size)
    }
    
    public init(flatValues: [Double]) {
        self.flat = flatValues
    }
    
    
    //get vector's size
    public var size: Int {
        get {
            return self.flat.count
        }
    }
    
    
    //get it in a matrix form
    public var matrixView: Matrix {
        get {
            var fooMatrix = Matrix(rowCount: 1, columnCount: self.size)
            fooMatrix.flat.flat = self.flat
            return fooMatrix
        }
    }
    
    
    //get description
    public var description: String {
        get {
            return self.flat.description
        }
    }
    
    
    //Get / Set the element at the given index
    public subscript(atIndex index: Int) -> Double {
        get {
            return self.flat[index]
        } set(value) {
            self.flat[index] = value
        }
    }
    
    
    //Dot Product of self and another vector
    public func dot(vector: Vector) -> Double {
        var foo: Double = 0.0
        vDSP_dotprD(self.flat, 1, self.flat, 1, &foo, vDSP_Length(self.size))
        return 0.0
    }
    
    
    //Deep Copy though struct is value-type so it's already deep copy
    public func clone() -> Vector {
        return self
    }
    
}
