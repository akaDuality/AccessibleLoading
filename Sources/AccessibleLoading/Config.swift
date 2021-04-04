//
//  Config.swift
//  
//
//  Created by Mikhail Rubanov on 04.04.2021.
//

import Foundation

struct Config {
    static let countsPerSec = 1
    
    static let regular = Event(intensity: 0.4, sharpness: 0.5)
    
    static let prelast = Event(intensity: 0.5, sharpness: 0.5)
    static let delayBetweenLast: TimeInterval = 0.2
    static let last = Event(intensity: 0.75, sharpness: 0)
}

struct Event {
    let intensity: Float
    let sharpness: Float
}
