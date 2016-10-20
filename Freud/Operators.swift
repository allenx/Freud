//
//  Operators.swift
//  Freud
//
//  Created by Allen X on 10/21/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Accelerate


//Vector Negation -
public prefix func -(vector: Vector) -> Vector {
    var foo = [Double](repeatElement(0.0, count: vector.size))
    vDSP_vnegD(vector.flat, 1, &foo, 1, vDSP_Length(vector.size))
    var fooVector = Vector(size: vector.size)
    fooVector.flat = foo
    return fooVector
}


//Vector Addition +
public func +(lhs: Vector, rhs: Vector) -> Vector {
    var foo = [Double](repeatElement(0.0, count: lhs.size))
    vDSP_vaddD(lhs.flat, 1, rhs.flat, 1, &foo, 1, vDSP_Length(lhs.size))
    var fooVector = Vector(size: lhs.size)
    fooVector.flat = foo
    return fooVector
}


//Vector Subtraction -
public func -(lhs: Vector, rhs: Vector) -> Vector {
    var foo = [Double](repeatElement(0.0, count: lhs.size))
    vDSP_vsubD(rhs.flat, 1, lhs.flat, 1, &foo, 1, vDSP_Length(lhs.size))
    var fooVector = Vector(size: lhs.size)
    fooVector.flat = foo
    return fooVector
}


// Element-wise vector addition.
public func +(lhs: Vector, rhs: Double) -> Vector {
    var scalar = rhs
    var foo = [Double](repeatElement(0.0, count: lhs.size))
    vDSP_vsaddD(lhs.flat, 1, &scalar, &foo, 1, vDSP_Length(lhs.size))
    var fooVector = Vector(size: lhs.size)
    fooVector.flat = foo
    return fooVector
}

// Element-wise vector subtraction.
public func -(lhs: Vector, rhs: Double) -> Vector {
    var scalar = -rhs
    var foo = [Double](repeatElement(0.0, count: lhs.size))
    vDSP_vsaddD(lhs.flat, 1, &scalar, &foo, 1, vDSP_Length(lhs.size))
    var fooVector = Vector(size: lhs.size)
    fooVector.flat = foo
    return fooVector
}

// Element-wise vector multiplication.
public func *(lhs: Vector, rhs: Double) -> Vector {
    var scalar = -rhs
    var foo = [Double](repeatElement(0.0, count: lhs.size))
    vDSP_vsmulD(lhs.flat, 1, &scalar, &foo, 1, vDSP_Length(lhs.size))
    var fooVector = Vector(size: lhs.size)
    fooVector.flat = foo
    return fooVector
}

// Element-wise vector division.
public func /(lhs: Vector, rhs: Double) -> Vector {
    var scalar = -rhs
    var foo = [Double](repeatElement(0.0, count: lhs.size))
    vDSP_vsdivD(lhs.flat, 1, &scalar, &foo, 1, vDSP_Length(lhs.size))
    var fooVector = Vector(size: lhs.size)
    fooVector.flat = foo
    return fooVector
}


// MARK: Matrix operators

// Matrix negation.
public prefix func -(matrix: Matrix) -> Matrix {
    let fooVector = -(matrix.flat)
    var mat = Matrix(rowCount: matrix.rowCount, columnCount: matrix.columnCount)
    mat.flat = fooVector
    return mat
}

// Matrix addition.
public func +(lhs: Matrix, rhs: Matrix) -> Matrix {
    assert(lhs.rowCount == rhs.rowCount && lhs.columnCount == rhs.columnCount, "The sizes of the two matrices don't match")
    let fooVector1 = lhs.flat
    let fooVector2 = rhs.flat
    var mat = Matrix(rowCount: lhs.rowCount, columnCount: lhs.columnCount)
    mat.flat =  fooVector1 + fooVector2
    return mat
}

// Matrix subtraction.
public func -(lhs: Matrix, rhs: Matrix) -> Matrix {
    assert(lhs.rowCount == rhs.rowCount && lhs.columnCount == rhs.columnCount, "The sizes of the two matrices don't match")
    let fooVector1 = lhs.flat
    let fooVector2 = rhs.flat
    var mat = Matrix(rowCount: lhs.rowCount, columnCount: lhs.columnCount)
    mat.flat =  fooVector1 - fooVector2
    return mat
}

// Matrix multiplication.
public func *(lhs: Matrix, rhs: Matrix) -> Matrix {
    assert(lhs.columnCount == rhs.rowCount, "The sizes of the two matrices don't match")
    let fooVector1 = lhs.flat.flat
    let fooVector2 = rhs.flat.flat
    var foo = [Double](repeatElement(1, count: (lhs.rowCount * rhs.columnCount)))
    vDSP_mmulD(fooVector1, 1, fooVector2, 1, &foo, 1, vDSP_Length(lhs.rowCount), vDSP_Length(rhs.columnCount), vDSP_Length(rhs.rowCount))
    var mat = Matrix(rowCount: lhs.rowCount, columnCount: rhs.columnCount)
    mat.flat.flat = foo
    return mat
}

// Element-wise matrix addition.
public func +(lhs: Matrix, rhs: Double) -> Matrix {
    let fooVector = lhs.flat + rhs
    var mat = Matrix(rowCount: lhs.rowCount, columnCount: lhs.columnCount)
    mat.flat = fooVector
    return mat
}

// Element-wise matrix subtraction.
public func -(lhs: Matrix, rhs: Double) -> Matrix {
    let fooVector = lhs.flat - rhs
    var mat = Matrix(rowCount: lhs.rowCount, columnCount: lhs.columnCount)
    mat.flat = fooVector
    return mat
}

// Element-wise matrix multiplication.
public func *(lhs: Matrix, rhs: Double) -> Matrix {
    let fooVector = lhs.flat * rhs
    var mat = Matrix(rowCount: lhs.rowCount, columnCount: lhs.columnCount)
    mat.flat = fooVector
    return mat
}

// Element-wise matrix division.
public func /(lhs: Matrix, rhs: Double) -> Matrix {
    let fooVector = lhs.flat / rhs
    var mat = Matrix(rowCount: lhs.rowCount, columnCount: lhs.columnCount)
    mat.flat = fooVector
    return mat
}
