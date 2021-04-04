import Foundation

@available(iOS 13.0, *)
public class AccessibleLoading {
    private let player = HapticPlayer()
    
    public init() {}
    
    public func start(duration: TimeInterval) {
        player.play(pattern: PatternFabric().pattern(duration: duration))
    }
    
    public func stop() {
        player.play(pattern: PatternFabric().finalPattern())
    }
}

import UIKit
@available(iOS 13.0, *)
open class AccessibleActivityIndicatorView: UIActivityIndicatorView {
    
    let duration: TimeInterval = 20
    
    let haptic = AccessibleLoading()
    
    open override func startAnimating() {
        super.startAnimating()
        
        haptic.start(duration: duration)
    }
    
    open override func stopAnimating() {
        super.stopAnimating()
        haptic.stop()
    }
}

