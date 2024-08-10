import CoreHaptics
import Foundation
import UIKit

@available(iOS 13.0, *)
final class AccessibilityHapticPatternFactory {

    // MARK: - Internal Methods

    func makeOnStartActivityPattern(duration: TimeInterval) -> CHHapticPattern? {
        guard isVoiceOverRunning else {
            return nil
        }
        let events = makeActivityEvents(duration: duration)
        return try? CHHapticPattern(events: events, parameterCurves: [])
    }

    func makeOnStopActivityPattern() -> CHHapticPattern? {
        guard isVoiceOverRunning else {
            return nil
        }
        let events = makeActivityStopEvent()
        return try? CHHapticPattern(events: events, parameterCurves: [])
    }

    // MARK: - Private Types

    private struct Event {
        let intensity: Float
        let sharpness: Float
    }

    private enum Constants {
        static let eventsPerSecond = 1
        static let standardEvent = Event(intensity: 0.4, sharpness: 0.5)
        static let penultimateEvent = Event(intensity: 0.5, sharpness: 0.5)
        static let finalEvent = Event(intensity: 0.75, sharpness: 0)
        static let delayToFinalEvent: TimeInterval = 0.2
    }

    // MARK: - Private Properties

    private var isVoiceOverRunning: Bool { UIAccessibility.isVoiceOverRunning }

    // MARK: - Private Methods

    private func makeActivityEvents(duration: TimeInterval) -> [CHHapticEvent] {
        let interval = 1 / TimeInterval(Constants.eventsPerSecond)
        let numberOfEvents = Int(duration) * Constants.eventsPerSecond
        return (0..<numberOfEvents).map { index in
            let time = TimeInterval(index) * interval
            return makeActivityLoadingEvent(time: time)
        }
    }

    private func makeActivityLoadingEvent(time: TimeInterval) -> CHHapticEvent {
        return makeActivityEvent(with: Constants.standardEvent, time: time)
    }

    private func makeActivityStopEvent() -> [CHHapticEvent] {
        let beforeFinalEvent = makeActivityEvent(with: Constants.penultimateEvent, time: 0)
        let finalEvent = makeActivityEvent(with: Constants.finalEvent, time: Constants.delayToFinalEvent)
        return [beforeFinalEvent, finalEvent]
    }

    private func makeActivityEvent(with event: Event, time: TimeInterval) -> CHHapticEvent {
        let intensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity, value: event.intensity)
        let sharpnessParameter = CHHapticEventParameter(parameterID: .hapticSharpness, value: event.sharpness)
        return CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensityParameter, sharpnessParameter],
            relativeTime: time
        )
    }

}
