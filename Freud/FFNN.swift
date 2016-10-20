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
    case invalidInputError(String)
    case invalidAnswerError(String)
    case invalidWeightsError(String)
}


