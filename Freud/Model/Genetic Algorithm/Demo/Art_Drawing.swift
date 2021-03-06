//
//  Art_Drawing.swift
//  Freud
//
//  Created by Allen X on 12/17/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

open class Drawing {
    var polygons: [PolygonGene]
    
    var isDirty: Bool = false
    
    var numberOfPoints: Int {
        get {
            return (polygons.map {
                return $0.numberOfPoints
            }).reduce(0) {
                $0 + $1
            }
        }
    }
    
    var numberOfPolygons: Int {
        get {
            return polygons.count
        }
    }
    
    func setDirty() {
        isDirty = true;
    }
    
    init(shouldRandom: Bool) {
        polygons = []
        if shouldRandom {
            for _ in 0..<Factors.ActivePolygonsMin {
                addPolygon()
            }
        }
        
        setDirty()
    }
    
    init(polygons: [PolygonGene]) {
        self.polygons = polygons
    }
    
    func clone() -> Drawing {
        let foo = Drawing(shouldRandom: false)
        for polygon in self.polygons {
            foo.polygons.append(polygon.clone())
        }
        return foo
    }
    
    func mutate() {
        if DiceRoller.willMutateWith(probability: Factors.ActiveAddPolygonMutationRate) {
            addPolygon()
        }
        if DiceRoller.willMutateWith(probability: Factors.ActiveRemovePolygonMutationRate) {
            removePolygon()
        }
        if DiceRoller.willMutateWith(probability: Factors.ActiveMovePolygonMutationRate) {
            movePolygon()
        }
        
        for poly in polygons {
            poly.mutate(currentDrawing: self)
        }
    }
    
    
    func addPolygon() {
        if numberOfPolygons < Factors.ActivePolygonsMax {
            let poly = PolygonGene(shouldRandom: true)
            let index = Int(Random.bounded(min: 0, max: Double(polygons.count)))
            polygons.insert(poly, at: Int(index))
            setDirty()
        }
    }
    
    func removePolygon() {
        if numberOfPolygons > Factors.ActivePolygonsMin {
            let index = Int(Random.bounded(min: 0, max: Double(polygons.count)))
            polygons.remove(at: index)
            setDirty()
        }
    }
    
    func movePolygon() {
        if polygons.count < 1 {
            return
        }
        var index = Int(Random.bounded(min: 0, max: Double(polygons.count)))
        let poly = polygons[index];
        polygons.remove(at: index);
        index = Int(Random.bounded(min: 0, max: Double(polygons.count)))
        polygons.insert(poly, at: index)
        setDirty()
    }
}
