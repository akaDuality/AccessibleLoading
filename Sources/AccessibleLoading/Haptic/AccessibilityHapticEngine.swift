import CoreHaptics
import Foundation
import UIKit

/// AccessibilityHapticEngine is a class designed to provide haptic feedback for accessibility purposes.
/// It utilizes the Core Haptics framework to create and manage haptic patterns that can be used to indicate loading states or
/// other activities.
///
/// Usage:
/// ```
/// let hapticEngine = AccessibilityHapticEngine()
/// hapticEngine?.startActivity()
/// // Some time later...
/// hapticEngine?.stopActivity()
/// ```
@available(iOS 13.0, *)
public final class AccessibilityHapticEngine {

    // MARK: - Public Init

    /// Initializes the haptic engine.
    /// Returns nil if the device does not support haptic feedback.
    public init?() {
        guard supportsHapticFeedback else {
            return nil
        }
    }

    // MARK: - Public Methods

    /// Starts the haptic feedback loading activity.
    /// If there is an existing activity, this method does nothing.
    public func startActivity() {
        guard activityDelayedWorkItem == nil else {
            return
        }
        activityDelayedWorkItem = DelayedWorkItemExecutor(delay: Constants.delay) { [weak self] in
            guard let self else {
                return
            }
            if let pattern = patternFactory.makeOnStartActivityPattern(duration: Constants.duration) {
                feedbackPlayer?.playLoop(pattern: pattern)
            }
        }
    }

    /// Stops the ongoing haptic feedback activity and plays a stop activity pattern.
    public func stopActivity() {
        guard activityDelayedWorkItem != nil else {
            return
        }
        activityDelayedWorkItem = nil
        feedbackPlayer?.stop { [weak self] in
            guard let self else {
                return
            }
            if let pattern = patternFactory.makeOnStopActivityPattern() {
                feedbackPlayer?.playOnce(pattern: pattern)
            }
        }
    }

    // MARK: - Private Types

    private enum Constants {

        static var duration: TimeInterval { TimeInterval(60) }
        static var delay: Double { 0.5 }

    }

    // MARK: - Private Properties

    private lazy var patternFactory = AccessibilityHapticPatternFactory()
    private lazy var feedbackPlayer = AccessibilityFeedbackPlayer()

    private var activityDelayedWorkItem: DelayedWorkItemExecutor?

    private var supportsHapticFeedback: Bool {
        return CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }

}
