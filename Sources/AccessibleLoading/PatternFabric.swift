//
//  PatternFabric.swift
//  
//
//  Created by Mikhail Rubanov on 04.04.2021.
//

import CoreHaptics

@available(iOS 13.0, *)
class PatternFabric {
    
    func pattern(duration: TimeInterval) -> CHHapticPattern {
        var events = self.events(countPerSec: Config.countsPerSec, duration: duration)
//        events.append(contentsOf: finalEvent(time: duration))
        
        let pattern = try! CHHapticPattern(
            events: events,
            parameterCurves: [])
        
        return pattern
    }
    
    func finalPattern() -> CHHapticPattern {
        let pattern = try! CHHapticPattern(
            events: finalEvent(time: 0),
            parameterCurves: [])
        
        return pattern
    }
    
    func events(countPerSec: Int, duration: TimeInterval) -> [CHHapticEvent] {
        let interval = 1 / TimeInterval(countPerSec)
        var events = [CHHapticEvent]()
        
        let times = Int(duration) * countPerSec
        for index in 0..<times {
            let time = TimeInterval(index) * interval
            let event = eventWith(time: time)
            
            events.append(event)
        }
        return events
    }
    
    func finalEvent(time: TimeInterval) -> [CHHapticEvent] {
        [CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity,
                                       value: Config.prelast.intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness,
                                       value: Config.prelast.sharpness),
            ],
            relativeTime: time),
         CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity,
                                       value: Config.last.intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness,
                                       value: Config.last.sharpness),
            ],
            relativeTime: time + Config.delayBetweenLast)]
    }
    
    func eventWith(time: TimeInterval) -> CHHapticEvent {
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity,
                                       value: Config.regular.intensity),
                CHHapticEventParameter(parameterID: .hapticSharpness,
                                       value: Config.regular.sharpness)],
            relativeTime: time)
        return event
    }
}

