import UIKit
import Foundation

@available(iOS 13.0, *)
public final class AccessibleActivityIndicatorView: UIActivityIndicatorView {

    // MARK: - Public Methods

    public override func startAnimating() {
        super.startAnimating()
        accessibilityHapticEngine?.startActivity()
    }
    
    public override func stopAnimating() {
        super.stopAnimating()
        accessibilityHapticEngine?.stopActivity()
    }

    // MARK: - Private Properties

    private let accessibilityHapticEngine = AccessibilityHapticEngine()

}
