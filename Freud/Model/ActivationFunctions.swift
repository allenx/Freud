//
//  ActivationFunctions.swift
//  Freud
//
//  Created by Allen X on 12/12/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation


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
