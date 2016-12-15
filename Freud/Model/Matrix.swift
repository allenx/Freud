//
//  Matrix.swift
//  Freud
//
//  Created by Allen X on 10/20/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Accelerate

public struct Matrix {
    
    public let rowCount: Int
    public let columnCount: Int
    public let shape: (Int, Int)
    public let size: Int
    var flat: Vector
    
    public init(rowCount: Int, columnCount: Int) {
        self.rowCount = rowCount
        self.columnCount = columnCount
        self.shape = (rowCount, columnCount)
        self.size = rowCount * columnCount
        self.flat = Vector(size: self.size)
    }
    
    
    //get it in a vector form
    public var vectorView: Vector {
        get {
            return self.flat
        }
    }
    
    
    //get description
    public var description: String {
        get {
            return self.flat.flat.description
        }
    }
    
    
    //get the transposed version of the matrix
    public var transpose: Matrix {
        get {
            var foo = Matrix(rowCount: self.columnCount, columnCount: self.rowCount)
            vDSP_mtransD(self.flat.flat, 1, &foo.flat.flat, 1, vDSP_Length(self.rowCount), vDSP_Length(self.columnCount))
            return foo
        }
    }
    
    
    //Get / Set the value at the given coordinate(row and col)
    public subscript(atRow row: Int, atCol col:Int) -> Double {
        get {
            return self.flat.flat[row * self.columnCount + col]
        } set {
            self.flat.flat[row * self.columnCount + col] = newValue
        }
    }
    
    
    //Returns the row as a Vector at the givin column_index
    public func row(atIndex index: Int) -> Vector {
        var deepFlat = self.flat.flat
        var fooRowArr = [Double](repeatElement(0, count: self.columnCount))
        for c in 0..<self.columnCount {
            let position = index * self.columnCount + c
            fooRowArr[c] = deepFlat[position]
        }
        var fooVector = Vector(size: fooRowArr.count)
        fooVector.flat = fooRowArr
        return fooVector
    }
    
    
    //Returns the column as a Vector at the given row_index
    public func colum(atIndex index: Int) -> Vector {
        var deepFlat = self.flat.flat
        var fooColArr = [Double](repeatElement(0, count: self.rowCount))
        for r in 0..<self.rowCount {
            let position = r * self.rowCount + index
            fooColArr[r] = deepFlat[position]
        }
        var fooVector = Vector(size: fooColArr.count)
        fooVector.flat = fooColArr
        return fooVector
    }
    
    
    public func clone() -> Matrix {
        //struct does not need deep copy
        return self
    }
    
}
