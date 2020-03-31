//
//  Model.swift
//  SpeedMathMobile
//
//  Created by Munir Wanis on 2020-03-31.
//  Copyright © 2020 Munir Wanis. All rights reserved.
//

import Foundation

enum Position {
    case answered, current, upcoming
}

struct Question {
    let text: String
    let actualAnswer: String
    var userAnswer = ""
    var paddingAmount: Int
    
    init() {
        let left = Int.random(in: 1...10)
        let right = Int.random(in: 1...10)
        
        text = "\(left) + \(right) = "
        actualAnswer = "\(left + right)"
        paddingAmount = 0
        
        if left < 10 {
            paddingAmount += 1
        }
        
        if right < 10 {
            paddingAmount += 1
        }
    }
}
