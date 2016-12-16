//
//  Gene.swift
//  Freud
//
//  Created by Allen X on 12/15/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

public struct Gene {
    var DNASequence: [Double] = []
    //Range of the DNASequence
    let range: (minima: Double, maxima: Double)
    
    var sequenceLength: Int {
        get {
            return self.DNASequence.count
        }
    }
    
    init(minima: Double, maxima: Double) {
        self.range = (minima, maxima)
    }
    
    init?(range: (Double, Double)) {
        guard range.0 != range.1 else {
            print("Gene Initialzaion failed! A wrong range was set: the two values in the range tuple should be different")
            return nil
        }
        self.range = range.0 < range.1 ? range : (range.1, range.0)
    }
    
    //Randomly generate the sequence of a specified length
    init?(length: Int, range: (Double, Double)) {
        guard range.0 != range.1 else {
            print("Gene Initialzaion failed! A wrong range was set: the two values in the range tuple should be different")
            return nil
        }
        self.range = range.0 < range.1 ? range : (range.1, range.0)
        
        let factor = (self.range.maxima - self.range.minima) / Double(UInt32.max)
        for _ in 0..<length {
            let allele = Double(arc4random()) * factor + self.range.minima
            self.DNASequence.append(allele)
        }
    }
    
    //Not needed as long as it's a struct
    //    func clone() -> Gene {
    //        return self
    //    }
    
    mutating func mutateWith(probability: Double) {
        //TODO: Random comparing strategy to be perfected
        let mutateThreshold = UInt32(probability * Double(UInt32.max))
        
        self.DNASequence = self.DNASequence.map { (allele: Double) -> Double in
            if arc4random() < mutateThreshold {
                let random = arc4random()
                var deviation = Double(random & 0x00101010F) * (self.range.maxima - self.range.minima) / 128.0
                if random & 0x00000100 != 0 {
                    deviation *= -1.0
                }
                var foo = allele + deviation
                if foo < self.range.minima {
                    foo = self.range.minima
                    return foo
                }
                if foo > self.range.maxima {
                    foo = self.range.maxima
                    return foo
                }
                return foo
            }
            return allele
        }
    }
    
    
    func mateWith(anotherGene: Gene) -> Gene {
        var childGene = Gene(range: self.range)
        
        //Generate a random DNASequence length that's between the parents' DNASequence length
        var sequenceLengthOfThechildGene = self.sequenceLength
        let diff = abs(self.sequenceLength - anotherGene.sequenceLength)
        if diff > 0 {
            sequenceLengthOfThechildGene = self.sequenceLength > anotherGene.sequenceLength ? anotherGene.sequenceLength + Int(arc4random_uniform(UInt32(diff + 1))) : self.sequenceLength + Int(arc4random_uniform(UInt32(diff + 1)))
        }
        
        for index in 0..<sequenceLengthOfThechildGene {
            var allele: Double
            if index > self.sequenceLength {
                //the childGene can only get allele from anotherGene at index
                allele = anotherGene.DNASequence[index]
            } else if index > anotherGene.sequenceLength {
                //the childGene can only get allele from this gene at index
                allele = self.DNASequence[index]
            } else {
                //the childGene can get allele from both genes at index
                //Mating with random numbers(50:50)
                let halfThreshold = UInt32(0.5 * Double(UInt32.max))
                if arc4random() < halfThreshold {
                    allele = self.DNASequence[index]
                } else {
                    allele = anotherGene.DNASequence[index]
                }
            }
            childGene?.DNASequence.append(allele)
        }
        return childGene!
    }
    
    
    static func mate(lhs: Gene, rhs: Gene) -> Gene {
        var childGene = Gene(range: lhs.range)
        
        //Generate a random DNASequence length that's between the parents' DNASequence length
        var sequenceLengthOfThechildGene = lhs.sequenceLength
        let diff = abs(lhs.sequenceLength - rhs.sequenceLength)
        if diff > 0 {
            sequenceLengthOfThechildGene = lhs.sequenceLength > rhs.sequenceLength ? rhs.sequenceLength + Int(arc4random_uniform(UInt32(diff + 1))) : lhs.sequenceLength + Int(arc4random_uniform(UInt32(diff + 1)))
        }
        
        for index in 0..<sequenceLengthOfThechildGene {
            var allele: Double
            if index > lhs.sequenceLength {
                //the childGene can only get allele from rhs at index
                allele = rhs.DNASequence[index]
            } else if index > rhs.sequenceLength {
                //the childGene can only get allele from lhs at index
                allele = lhs.DNASequence[index]
            } else {
                //the childGene can get allele from both genes at index
                //Mating with random numbers(50:50)
                let halfThreshold = UInt32(0.5 * Double(UInt32.max))
                if arc4random() < halfThreshold {
                    allele = lhs.DNASequence[index]
                } else {
                    allele = rhs.DNASequence[index]
                }
            }
            childGene?.DNASequence.append(allele)
        }
        return childGene!
    }
    
    
    
}
