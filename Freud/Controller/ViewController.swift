//
//  ViewController.swift
//  Freud
//
//  Created by Allen X on 10/20/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sineWave(errorThreshold: 2.0)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

func sineWave2(errorThreshold: Float) {
    print("FFNN: Sine Wave")
    let NN = FFNN(inputs: 1, hidden: 8, outputs: 1, learningRate: 0.7, momentum: 0.2, weights: nil, activationFunction: .Sigmoid, errorFunction: .Default(average: false))
    
    var inputs = [[Float]]()
    var answers = [[Float]]()
    for i in -500...500 {
        let x = Float(i) / 1000
        inputs.append([x])
        answers.append([sine(x: x)])
    }
    
    var testInputs = [[Float]]()
    var testAnswers = [[Float]]()
    for j in -300...300 {
        let x = Float(j) / 600
        testInputs.append([x])
        testAnswers.append([sine(x: x)])
    }
    
    let weights = try! NN.train(inputs: inputs, answers: answers, testInputs: testInputs, testAnswers: testAnswers, errorThreshold: errorThreshold)
    
    print(weights)
}

func sineWave(errorThreshold: Float) {
    print("FFNN: Sine Wave")
    let NN = FFNN(inputs: 1, hidden: 8, outputs: 1, learningRate: 0.7, momentum: 0.2, weights: nil, activationFunction: .Sigmoid, errorFunction: .Default(average: false))
    
    var inputs = [[Float]]()
    var answers = [[Float]]()
    for i in -500...500 {
        let x = Float(i) / 1000
        inputs.append([x])
        answers.append([sine(x: x)])
    }
    
    var testInputs = [[Float]]()
    var testAnswers = [[Float]]()
    for j in -300...300 {
        let x = Float(j) / 600
        testInputs.append([x])
        testAnswers.append([sine(x: x)])
    }
    
    let weights = try! NN.train(inputs: inputs, answers: answers, testInputs: testInputs, testAnswers: testAnswers, errorThreshold: errorThreshold)
    
    print(weights)
}

func sine(x: Float) -> Float {
    return (0.5 * sin(10 * x)) + 0.5
}
