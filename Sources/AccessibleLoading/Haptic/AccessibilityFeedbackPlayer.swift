import Foundation
import CoreHaptics

@available(iOS 13.0, *)
final class AccessibilityFeedbackPlayer {

    // MARK: - Internal Init

    init?() {
        do {
            engine = try CHHapticEngine()
        } catch {
            return nil
        }
    }

    // MARK: - Internal Methods

    func playLoop(pattern: CHHapticPattern) {
        do {
            try engine.start()
            player = try engine.makeAdvancedPlayer(with: pattern)
            player?.loopEnabled = true
            try player?.start(atTime: CHHapticTimeImmediate)
        } catch {
            assertionFailure("Accessibility feedback player unable to start pattern")
            return
        }
    }

    func playOnce(pattern: CHHapticPattern) {
        do {
            try engine.start()
            player = try engine.makeAdvancedPlayer(with: pattern)
            try player?.start(atTime: CHHapticTimeImmediate)
        } catch {
            assertionFailure("Accessibility feedback player unable to start pattern")
            return
        }
    }

    func stop(afterStop: (() -> Void)?) {
        try? player?.stop(atTime: CHHapticTimeImmediate)
        player = nil
        afterStop?()
    }

    // MARK: - Private Properties

    private var engine: CHHapticEngine
    private var player: CHHapticAdvancedPatternPlayer?

}
