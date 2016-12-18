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
    var currentDrawing :Drawing!
    var generation = 0
    var GAView: GeneticAlgorithmView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SocketManager.shared.initHandler()
        currentDrawing = Drawing(shouldRandom: true)
        let imageMona = #imageLiteral(resourceName: "MonaLisa")
        for i in 0..<200 {
            for j in 0..<200 {
                let foo1 = imageMona.rgbUInt8(atPos: CGPoint(x: i, y: j))
                let foo = PixelData(a: foo1.alpha, r: foo1.red, g: foo1.green, b: foo1.blue)
                FitnessCalculator.sourcePixelData.append(foo)
            }
        }
        
        let imageView = UIImageView(image: imageMona)
        
        imageView.frame = CGRect(x: 20, y: 20, width: 200, height: 200)
        //self.view.addSubview(imageView)
        
        
        GAView = GeneticAlgorithmView(currentDrawing: currentDrawing)
        self.view.addSubview(GAView)
        
        
        
        evolveThousands()
        
        let btn = UIButton(title: "hello")
        btn.titleLabel?.textColor = .red
        self.view.addSubview(btn)
        btn.snp.makeConstraints {
            make in
            make.left.bottom.equalTo(self.view)
        }
        
        btn.addTarget(self, action: #selector(evolveThousands), for: .touchUpInside)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func evolveThousands() {
        print(generation)
        print(errorLevel)
        for i in 0..<1000 {
            //print(i)
            evolve()
        }
        GAView.currentDrawing = currentDrawing
    }
    
    func showView() {
        ThreadManager.synchronize(currentDrawing) { 
            GAView.currentDrawing = currentDrawing
        }
        
    }
    
    func evolve() {
        let queue = DispatchQueue(label: "com.allenx.Freud.backEndTraining")
        queue.async {
            objc_sync_enter(self.currentDrawing)
            let fooDrawing = self.currentDrawing.clone()
            objc_sync_exit(self.currentDrawing)
            fooDrawing.mutate()
            if fooDrawing.isDirty {
                self.generation += 1
                
                
                //            self.GAView.currentDrawing = fooDrawing
                //            self.GAView.setNeedsDisplay()
                
                
                //let newErrorLevel = FitnessCalculator.calculateFitnessFor(currentDrawingView: self.GAView)
                let newErrorLevel = FitnessCalculator.calculateSampleFitnessFor(currentDrawing: fooDrawing)
                //print(newErrorLevel)
                if newErrorLevel <= self.errorLevel {
                    objc_sync_enter(self.currentDrawing)
                    self.currentDrawing = fooDrawing
                    objc_sync_exit(self.currentDrawing)
                    self.errorLevel = newErrorLevel
                    
                    
                }
                print("\(self.generation), \(self.errorLevel)")
                
            }
        }
        
        
        
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
