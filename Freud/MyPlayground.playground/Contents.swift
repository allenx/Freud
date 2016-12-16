//: Playground - noun: a place where people can play

import XCPlayground
import Foundation

func sine() {
    var outputs = [Float]()
    
    let network = FFNN(inputs: 1, hidden: 8, outputs: 1, learningRate: 0.7, momentum: 0.2, weights: nil, activationFunction: .Sigmoid, errorFunction: ErrorFunction.Default(average: false))
    
    for _ in 0..<4000 {
        for i in -500...500 {
            let x = Float(i) / 1000
            try! network.update(inputs: [x])
            let answer = sineFunc(x: x)
            try! network.backPropagate(answer: [answer])
        }
    }
    
    for i in -1000...1000 {
        let x = Float(i) / 1000
        let output = try! network.update(inputs: [x]).first!
        outputs.append(output)
    }
    
    print(outputs)
}

/// sin(10x)/2 + 1/2
func sineFunc(x: Float) -> Float {
    return (0.5 * sin(10 * x)) + 0.5
}

func plotSineWave() {
    
    // ** REPLACE THESE WITH YOUR OWN TRAINED WEIGHTS **
    let weights: [Float] = [-5.22869825, -10.1711273, -4.36484909, -21.1035194, 4.19102192, -8.63894939, 1.59657192, -22.9107838, 0.70995748, -3.91651845, -2.56867361, -19.8344517, 0.719888806, -3.8848772, -0.975778878, 9.90899944, -2.95733762, 8.57180309, 9.44693851, 12.0124817, -9.42532158, 1.37747943, -11.4907112, 1.35024226, -8.57461739]
    
    // Initialize neural network with pre-trained weights (may need to change activation function if yours was trained with a different one)
    let network = FFNN(inputs: 1, hidden: 8, outputs: 1, learningRate: 0.7, momentum: 0.2, weights: weights, activationFunction: .Sigmoid, errorFunction: .Default(average: false))
    
    // Plot points in domain [-0.5 , 0.5]
    
    
    for i in -500...500 {
        let x = Float(i) / 1000
        let output = try! network.update(inputs: [x]).first!
        XCPlaygroundPage.currentPage.captureValue(value: output, withIdentifier: "Sine Wave")
    }
}

// ** UNCOMMENT THIS LINE TO RUN **
plotSineWave()



let probability = 0.01
let threshold = UInt32(probability * Double(UInt32.max))

let random = arc4random()
let a = random & 0x0000001F





