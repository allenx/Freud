//
//  FFNN.swift
//  Freud
//
//  Created by Allen X on 10/21/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation
import Accelerate

public enum FFNNError: Error {
    case InvalidInputsError(String)
    case InvalidAnswerError(String)
    case InvalidWeightsError(String)
}

public enum ActivationFunction: String {
    //No activation function (returns zero)
    case None
    
    case Default
    case Linear
    case Sigmoid
    case Softmax
    case RationalSigmoid
    case HyperbolicTangent
}

public enum ErrorFunction {
    case Default(average: Bool)
    case CrossEntropy(average: Bool)
}


public class FFNN {
    
    //The number of input nodes to the network
    let numInputs: Int
    
    //The number of hidden nodes in the network
    let numHidden: Int
    
    //The number of output nodes from the network
    let numOutputs: Int
    
    var learningRate: Float {
        didSet(newValue) {
            self.mfLR = (1 - self.momentumFactor) * newValue
        }
    }
    
    var momentumFactor: Float {
        didSet(newValue) {
            self.mfLR = (1 - newValue) * self.learningRate
        }
    }
    
    fileprivate var activationFunction: ActivationFunction = .Sigmoid
    fileprivate var errorFunction: ErrorFunction = .Default(average: false)
    
    //(1 - momentumFactor) * learningRate as a stored and precomputed property because it's gonna be frequently used
    fileprivate var mfLR: Float
    
    //The number of input nodes includeing the biased one
    fileprivate let numberOfInputNodes: Int
    //The number of hidden nodes including the biased one
    fileprivate let numberOfHiddenNodes: Int
    //The total number of weights of edges connecting all input nodes to all hidden nodes
    fileprivate let numberOfHiddenWeights: Int
    //The total number of weights of edges connecting all hidden nodes to all output nodes
    fileprivate let numberOfOutputWeights: Int
    
    //Current weight values leading into all of the hidden nodes, serialized in a single array
    fileprivate var hiddenWeights: [Float]
    
    //The weight values leading into all of the hidden nodes from the previous round of training, serialized in a single array
    //Used for applying momentum during backpropagation
    fileprivate var previousHiddenWeights: [Float]
    
    //Current weight values leading into all of the output nodes, serialized in a single array
    fileprivate var outputWeights: [Float]
    
    //The weight values leading into all of the output nodes from the previous round of training, serialized in a single array
    //Used for applying momentum during backpropagation
    fileprivate var previousOutputWeights: [Float]
    
    //The most recent set of inputs applied to the network
    fileprivate var inputCache: [Float]
    //The most recent outputs from each of the hidden nodes
    fileprivate var hiddenOutputCache: [Float]
    //The most recent output from the network
    fileprivate var outputCache: [Float]
    
    // Temporary storage while calculating hidden errors, for use during backpropagation.
    fileprivate var hiddenErrorSumsCache: [Float]
    // Temporary storage while calculating hidden errors, for use during backpropagation.
    fileprivate var hiddenErrorsCache: [Float]
    // Temporary storage while calculating output errors, for use during backpropagation.
    fileprivate var outputErrorsCache: [Float]
    // Temporary storage while updating hidden weights, for use during backpropagation.
    fileprivate var newHiddenWeights: [Float]
    // Temporary storage while updating output weights, for use during backpropagation.
    fileprivate var newOutputWeights: [Float]
    
    // The output error indices corresponding to each output weight.
    fileprivate var outputErrorIndices = [Int]()
    // The hidden output indices corresponding to each output weight.
    fileprivate var hiddenOutputIndices = [Int]()
    // The hidden error indices corresponding to each hidden weight.
    fileprivate var hiddenErrorIndices = [Int]()
    // The input indices corresponding to each hidden weight.
    fileprivate var inputIndices = [Int]()
    
    public init(inputs: Int, hidden: Int, outputs: Int, learningRate: Float = 0.7, momentum: Float = 0.4, weights: [Float]? = nil, activationFunction: ActivationFunction = .Default, errorFunction: ErrorFunction = .Default(average: false)) {
        if inputs < 1 || hidden < 1 || outputs < 1 || learningRate <= 0 {
            print("Sorry but you gotta input some valid arguments so that you can get a working FFNN. Inputs, hidden, outpus and learningRate should all be above 0.")
            return
        }
        
        self.numberOfHiddenWeights = (hidden * (inputs + 1))
        self.numberOfOutputWeights = (outputs * (hidden + 1))
        
        self.numInputs = inputs
        self.numHidden = hidden
        self.numOutputs = outputs
        
        self.numberOfInputNodes = inputs + 1
        self.numberOfHiddenNodes = hidden + 1
        
        self.learningRate = learningRate
        self.momentumFactor = momentum
        self.mfLR = (1 - momentum) * learningRate
        
        self.inputCache = [Float](repeatElement(0, count: self.numberOfInputNodes))
        self.hiddenOutputCache = [Float](repeatElement(0, count: self.numberOfHiddenNodes))
        self.outputCache = [Float](repeatElement(0, count: outputs))
        
        self.outputErrorsCache = [Float](repeatElement(0, count: self.numOutputs))
        self.hiddenErrorSumsCache = [Float](repeatElement(0, count: self.numberOfHiddenNodes))
        self.hiddenErrorsCache = [Float](repeatElement(0, count: self.numberOfHiddenNodes))
        self.newOutputWeights = [Float](repeatElement(0, count: self.numberOfOutputWeights))
        self.newHiddenWeights = [Float](repeatElement(0, count: self.numberOfHiddenWeights))
        
        self.activationFunction = activationFunction
        self.errorFunction = errorFunction
        for weightIndex in 0..<self.numberOfOutputWeights {
            self.outputErrorIndices.append(weightIndex / self.numberOfHiddenNodes)
            self.inputIndices.append(weightIndex % self.numberOfHiddenNodes)
        }
        
        for weightIndex in 0..<self.numberOfHiddenWeights {
            self.hiddenErrorIndices.append(weightIndex / self.numberOfInputNodes)
            self.inputIndices.append(weightIndex % self.numberOfInputNodes)
        }
        
        self.hiddenWeights = [Float](repeatElement(0, count: self.numberOfHiddenWeights))
        self.previousHiddenWeights = self.hiddenWeights
        self.outputWeights = [Float](repeatElement(0, count: outputs * self.numberOfHiddenNodes))
        self.previousOutputWeights = self.outputWeights
        
        if let foo = weights {
            guard foo.count == numberOfHiddenWeights + numberOfOutputWeights else {
                print("FFNN initialization error: Incorrect number of weights provided. Randomized weights will be used instead.")
                self.randomizeWeights()
                return
            }
            self.hiddenWeights = Array(foo[0..<self.numberOfHiddenWeights])
            self.outputWeights = Array(foo[self.numberOfHiddenWeights..<foo.count])
        } else {
            print("FFNN initialization error: no weights provided. Randomized weights will be used instead.")
            self.randomizeWeights()
        }
    }
    
    
    //Propagates inputs throught the NN and returns the output
    public func update(inputs: [Float]) throws -> [Float] {
        guard inputs.count == self.numInputs else {
            throw FFNNError.InvalidAnswerError("Number of inputs given does not match the network's setting. Given: \(inputs.count), expected: \(self.numInputs)")
        }
        
        //Cache the inputs
        //A biased node is inserted to index 0, followed by each of the given inputs
        self.inputCache[0] = 1.0
        for i in 1..<self.numberOfInputNodes {
            self.inputCache[i] = inputs[i - 1]
        }
        
        //Calculate the weighted sums for the hidden layer
        vDSP_mmul(self.hiddenWeights, 1, self.inputCache, 1, &self.hiddenOutputCache, 1, vDSP_Length(self.numHidden), vDSP_Length(1), vDSP_Length(self.numberOfInputNodes))
        
        //Apply the activation function to the nodes at the hidden layer
        //Array elements are shifted one index to the right because the biased node is at index 0
        self.activateHidden()
        
        //Calculate the weighted sums for the output layer
        vDSP_mmul(self.outputWeights, 1, self.hiddenOutputCache, 1, &self.outputCache, 1, vDSP_Length(self.numOutputs), vDSP_Length(1), vDSP_Length(self.numberOfHiddenNodes))
        
        //Apply the activation function to the nodes at the output layer
        self.activateOutput()
        
        //Return the final outputs
        return self.outputCache
    }
    
    
    //Trains the NN by comparing its most recent output with the given 'standard outputs' or answers and adjusts the NN's weights according to that deviation
    public func backPropagate(answer: [Float]) throws -> Float {
        guard answer.count == self.numOutputs else {
            throw FFNNError.InvalidAnswerError("Number of answer given does not match the network's setting. Given: \(answer.count), expected: \(self.numOutputs)")
        }
        
        //Calculate output errors
        for (outputIndex, output) in self.outputCache.enumerated() {
            switch self.activationFunction {
            case .Softmax:
                //FIXME: This is not working correctly
                self.outputErrorsCache[outputIndex] = output - answer[outputIndex]
            default:
                self.outputErrorsCache[outputIndex] = self.activationDerivative(output: output) * (answer[outputIndex] - output)
            }
        }
        
        //Calculate hidden errors
        vDSP_mmul(self.outputErrorsCache, 1, self.outputWeights, 1, &self.hiddenErrorSumsCache, 1, vDSP_Length(1), vDSP_Length(self.numberOfHiddenNodes), vDSP_Length(self.numOutputs))
        for (errorIndex, error) in self.hiddenErrorSumsCache.enumerated() {
            self.hiddenErrorsCache[errorIndex] = self.activationDerivative(output: self.hiddenOutputCache[errorIndex]) * error
        }
        
        //Update the output weights
        for weightIndex in 0..<self.outputWeights.count {
            let offset = self.outputWeights[weightIndex] + (self.momentumFactor * (self.outputWeights[weightIndex] - previousOutputWeights[weightIndex]))
            let errorIndex = self.outputErrorIndices[weightIndex]
            let hiddenOutputIndex = self.hiddenOutputIndices[weightIndex]
            let mfLRErrIn = self.mfLR * self.outputErrorsCache[errorIndex] * self.hiddenOutputCache[hiddenOutputIndex]
            self.newOutputWeights[weightIndex] = offset + mfLRErrIn
        }
        
        vDSP_mmov(outputWeights, &previousOutputWeights, 1, vDSP_Length(numberOfOutputWeights), 1, 1)
        vDSP_mmov(newOutputWeights, &outputWeights, 1, vDSP_Length(numberOfOutputWeights), 1, 1)
        
        //Update the hidden weights
        for weightIndex in 0..<self.hiddenWeights.count {
            let offset = self.hiddenWeights[weightIndex] + (self.momentumFactor * (self.hiddenWeights[weightIndex] - self.previousHiddenWeights[weightIndex]))
            let errorIndex = self.hiddenErrorIndices[weightIndex]
            let inputIndex = self.inputIndices[weightIndex]
            //shift right by 1 on the errorIndex coz there's a biased error which should be ignored
            let mfLRErrIn = self.mfLR * self.hiddenErrorsCache[errorIndex + 1] * self.inputCache[inputIndex]
            self.newHiddenWeights[weightIndex] = offset + mfLRErrIn
        }
        
        vDSP_mmov(hiddenWeights, &previousHiddenWeights, 1, vDSP_Length(numberOfHiddenWeights), 1, 1)
        vDSP_mmov(newHiddenWeights, &hiddenWeights, 1, vDSP_Length(numberOfHiddenWeights), 1, 1)
        
        //Sum and return the output errors
        return self.outputErrorsCache.reduce(0, {
            (sum, error) -> Float in
            return sum + abs(error)
        })
    }
    
    
    //Training
    public func train(inputs: [[Float]], answers: [[Float]], testInputs: [[Float]], testAnswers: [[Float]], errorThreshold: Float) throws -> [Float] {
        guard errorThreshold > 0 else {
            throw FFNNError.InvalidInputsError("Error threshold must be greater than zero!")
        }
        
        // TODO: Allow trainer to exit early or regenerate new weights if it gets stuck in local minima
        
        // Train forever until the desired error threshold is met
        while true {
            for (index, input) in inputs.enumerated() {
                try self.update(inputs: input)
                try self.backPropagate(answer: answers[index])
            }
            
            //Calculate the total error of the validation set after each epoch
            let errorSum: Float = try self.error(result: testInputs, expected: testAnswers)
            if errorSum < errorThreshold {
                break
            }
        }
        
        return self.hiddenWeights + self.outputWeights
    }
    
    
    //Returns a serialized array of the network's current weights
    public func currentWeights() -> [Float] {
        return self.hiddenWeights + self.outputWeights
    }
    
    //Reset the network with some given weights (i.e. from a pre-trained network).
    public func resetWithWeights(weights: [Float]) throws {
        guard weights.count == self.numberOfHiddenWeights + self.numberOfOutputWeights else {
            throw FFNNError.InvalidWeightsError("Invalid number of weights provided: \(weights.count). Expected: \(self.numberOfHiddenWeights + self.numberOfOutputWeights)")
        }
        
        self.hiddenWeights = Array(weights[0..<self.hiddenWeights.count])
        self.outputWeights = Array(weights[self.hiddenWeights.count..<weights.count])
    }
}


public extension FFNN {
    //Returns a URL for a document with the given filename in the default documents directory
    public static func getFileURL(fileName: String) -> URL {
        let manager = FileManager.default
        let dirURL = try! manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return dirURL.appendingPathComponent(fileName)
    }
    
    //Reads a FFNN stored in a file at the given URL.
    public static func fromFile(url: URL) -> FFNN? {
//        guard let data = Data(contentsOf: url) else {
//            return nil
//        }
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        guard let storage = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: AnyObject] else {
            return nil
        }
        
        //Read a Dictionary from file
        guard let numInputs = storage["inputs"] as? Int,
            let numHidden = storage["hidden"] as? Int,
            let numOutputs = storage["outputs"] as? Int,
            let momentumFactor = storage["momentum"] as? Float,
            let learningRate = storage["learningRate"] as? Float,
            let activationFunction = storage["activationFunction"] as? String,
            let hiddenWeights = storage["hiddenWeights"] as? [Float],
            let outputWeights = storage["outputWeights"] as? [Float] else {
                return nil
        }
        
        //Fallback to Default activation if an unknow value is found (i.e. a newer version of FFNN)
        var activation: ActivationFunction? = ActivationFunction(rawValue: activationFunction)
        if activation == nil {
            print("Warning: Unknown activation function read from file. Using Default activation instead.")
            activation = .Default
        }
        
        let weights = hiddenWeights + outputWeights
        return FFNN(inputs: numInputs, hidden: numHidden, outputs: numOutputs, learningRate: learningRate, momentum: momentumFactor, weights: weights, activationFunction: activation!, errorFunction: .Default(average: false))
    }
    
    //Write a Dictionary to a file
    public func toFile(url: URL) {
        var storage = [String: AnyObject]()
        storage["inputs"] = self.numInputs as AnyObject?
        storage["hidden"] = self.numHidden as AnyObject?
        storage["outputs"] = self.numOutputs as AnyObject?
        storage["momentum"] = self.momentumFactor as AnyObject?
        storage["learningRate"] = self.learningRate as AnyObject?
        storage["hiddenWeights"] = self.hiddenWeights as AnyObject?
        storage["outputWeights"] = self.outputWeights as AnyObject?
        storage["activationFunction"] = self.activationFunction.rawValue as AnyObject?
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: storage)
        
        do {
            try? data.write(to: url, options: .atomic)
        } catch {
            print("Writing Failed")
        }
    }
    
    
    //Computes the error over the given training set
    public func error(result: [[Float]], expected: [[Float]]) throws -> Float {
        var errorSum: Float = 0
        switch self.errorFunction {
        case .Default(let average):
            for (inputIndex, input) in result.enumerated() {
                let outputs = try self.update(inputs: input)
                for (outputIndex, output) in outputs.enumerated() {
                    errorSum += abs(self.activationDerivative(output: output) * (expected[inputIndex][outputIndex] - output))
                }
            }
            if average {
                errorSum /= Float(result.count)
            }
            
        case .CrossEntropy(let average):
            for (inputIndex, input) in result.enumerated() {
                let outputs = try self.update(inputs: input)
                for (outputIndex, output) in outputs.enumerated() {
                    errorSum += crossEntropy(a: output, b: expected[inputIndex][outputIndex])
                }
            }
            errorSum = -errorSum
            if average {
                errorSum /= Float(result.count)
            }
        }
        return errorSum
    }
    
    //Applies the activation function to the nodes at the hidden layer
    fileprivate func activateHidden() {
        switch self.activationFunction {
        case .None:
            for i in (1...self.numHidden).reversed() {
                self.hiddenOutputCache[i] = 0.0
            }
            self.hiddenOutputCache[0] = 1.0
        case .Default:
            for i in (1...self.numHidden).reversed() {
                self.hiddenOutputCache[i] = sigmoid(x: self.hiddenOutputCache[i - 1])
            }
            self.hiddenOutputCache[0] = 1.0
        case .Linear:
            for i in (1...self.numHidden).reversed() {
                self.hiddenOutputCache[i] = linear(x: self.hiddenOutputCache[i - 1])
            }
            self.hiddenOutputCache[0] = 1.0
        case .Sigmoid:
            //Apply Sigmoid activation for hidden layers if it's Softmax
            for i in (1...self.numHidden).reversed() {
                self.hiddenOutputCache[i] = sigmoid(x: self.hiddenOutputCache[i - 1])
            }
            self.hiddenOutputCache[0] = 1.0
        case .Softmax:
            //Apply Sigmoid activation for hidden layers if it's Softmax
            for i in (1...self.numHidden).reversed() {
                self.hiddenOutputCache[i] = sigmoid(x: self.hiddenOutputCache[i - 1])
            }
            self.hiddenOutputCache[0] = 1.0
        case .RationalSigmoid:
            for i in (1...self.numHidden).reversed() {
                self.hiddenOutputCache[i] = rationalSigmoid(x: self.hiddenOutputCache[i - 1])
            }
            self.hiddenOutputCache[0] = 1.0
        case .HyperbolicTangent:
            for i in (1...self.numHidden).reversed() {
                self.hiddenOutputCache[i] = hyperbolicTangent(x: self.hiddenOutputCache[i - 1])
            }
            self.hiddenOutputCache[0] = 1.0
        }
    }
    
    //Applies the activation function to the nodes at the output layer
    fileprivate func activateOutput() {
        switch self.activationFunction {
        case .None:
            for i in 0..<self.numOutputs {
                self.outputCache[i] = 0.0
            }
        case .Default:
            for i in 0..<self.numOutputs {
                self.outputCache[i] = sigmoid(x: self.outputCache[i])
            }
        case .Linear:
            for i in 0..<self.numOutputs {
                self.outputCache[i] = linear(x: self.outputCache[i])
            }
        case .Sigmoid:
            for i in 0..<self.numOutputs {
                self.outputCache[i] = sigmoid(x: self.outputCache[i])
            }
        case .Softmax:
            var sum: Float = 0
            let max = self.outputCache.max()!
            for i in 0..<self.numOutputs {
                self.outputCache[i] = self.outputCache[i] - max
            }
            for i in 0..<self.numOutputs {
                self.outputCache[i] = exp(self.outputCache[i])
                sum += self.outputCache[i]
            }
            for i in 0..<self.numOutputs {
                self.outputCache[i] = self.outputCache[i] / sum
            }
        case .RationalSigmoid:
            for i in 0..<self.numOutputs {
                self.outputCache[i] = rationalSigmoid(x: self.outputCache[i])
            }
        case .HyperbolicTangent:
            for i in 0..<self.numOutputs {
                self.outputCache[i] = hyperbolicTangent(x: self.outputCache[i])
            }
        }
    }
    
    //Calculates the deriative of the activation function from the given y value
    fileprivate func activationDerivative(output: Float) -> Float {
        switch self.activationFunction {
        case .None:
            return 0.0
        case .Default:
            return sigmoidDerivative(y: output)
        case .Linear:
            return linearDerivative(y: output)
        case .Sigmoid:
            return sigmoidDerivative(y: output)
        case .Softmax:
            return sigmoidDerivative(y: output)
        case .RationalSigmoid:
            return rationalSigmoidDerivative(y: output)
        case .HyperbolicTangent:
            return hyperbolicTangentDerivative(y: output)
        }
    }
    
    fileprivate func randomizeWeights() {
        for i in 0..<self.numberOfHiddenWeights {
            self.hiddenWeights[i] = randomWeight(numberOfInputNodes: self.numberOfInputNodes)
        }
        for i in 0..<self.numberOfOutputWeights {
            self.outputWeights[i] = randomWeight(numberOfInputNodes: self.numberOfInputNodes)
        }
    }
    
    
    // TODO: Generate random weights along a normal distribution, rather than a uniform distribution.
    // Also, these weights are only optimal for sigmoid activation. They don't work well with other functions
    
    // Generates a random weight for a layer node, based on the parameters set for the network.
    // Will return a Float between +/- 1/sqrt(numInputNodes).
    fileprivate func randomWeight(numberOfInputNodes: Int) -> Float {
        let range = 1 / sqrt(Float(numberOfInputNodes))
        let rangeInt = UInt32(2_000_000 * range)
        let randomFloat = Float(arc4random_uniform(rangeInt)) - Float(rangeInt / 2)
        return randomFloat / 1_000_000
    }
    
    
    fileprivate func crossEntropy(a: Float, b: Float) -> Float {
        return log(a) * b
    }
    
    
    // Linear activation function (raw sum)
    private func linear(x: Float) -> Float {
        return x
    }
    
    // Derivative for the linear activation function
    private func linearDerivative(y: Float) -> Float {
        return 1.0
    }
    
    // Sigmoid activation function
    private func sigmoid(x: Float) -> Float {
        return 1 / (1 + exp(-x))
    }
    // Derivative for the sigmoid activation function
    private func sigmoidDerivative(y: Float) -> Float {
        return y * (1 - y)
    }
    
    // Rational sigmoid activation function
    private func rationalSigmoid(x: Float) -> Float {
        return x / (1.0 + sqrt(1.0 + x * x))
    }
    
    // Derivative for the rational sigmoid activation function
    private func rationalSigmoidDerivative(y: Float) -> Float {
        let x = -(2 * y) / (y * y - 1)
        return 1 / ((x * x) + sqrt((x * x) + 1) + 1)
    }
    
    // Hyperbolic tangent activation function
    private func hyperbolicTangent(x: Float) -> Float {
        return tanh(x)
    }
    
    // Derivative for the hyperbolic tangent activation function
    private func hyperbolicTangentDerivative(y: Float) -> Float {
        return 1 - (y * y)
    }
}
