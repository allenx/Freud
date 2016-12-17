//
//  ViewController.swift
//  Freud
//
//  Created by Allen X on 10/20/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import UIKit
import SnapKit
import GLKit

class ViewController: UIViewController {
    
    var errorLevel = Double.greatestFiniteMagnitude
    var currentDrawing = Drawing()
    var generation = 0
    var GAView: GeneticAlgorithmView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SocketManager.shared.initHandler()

        var error: Int = 0
        let imageMona = #imageLiteral(resourceName: "MonaLisa")
        for i in 0..<200 {
            for j in 0..<200 {
                let foo1 = imageMona.rgbUInt8(atPos: CGPoint(x: i, y: j))
                let foo = PixelData(a: foo1.alpha, r: foo1.red, g: foo1.green, b: foo1.blue)
                FitnessCalculator.sourcePixelData.append(foo)
            }
        }
        


//        imageView.frame = CGRect(x: 20, y: 20, width: 200, height: 200)
//        self.view.addSubview(imageView)
        
        GAView = GeneticAlgorithmView(currentDrawing: currentDrawing)
        self.view.addSubview(GAView)
        
        while true {
            evolve()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func evolve() {

        let fooDrawing = currentDrawing.clone()
        fooDrawing.mutate()
        if fooDrawing.isDirty {
            GAView.currentDrawing = fooDrawing
            generation += 1
            let newErrorLevel = FitnessCalculator.calculateFitnessFor(currentDrawingView: GAView)
            if newErrorLevel <= errorLevel {
                ThreadManager.synchronize(currentDrawing) {
                    currentDrawing = fooDrawing
                }
                errorLevel = newErrorLevel
            }
        }
        print(generation)
        
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
