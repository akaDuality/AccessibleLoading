//
//  HapticPlayer.swift
//  
//
//  Created by Mikhail Rubanov on 04.04.2021.
//

import CoreHaptics
import os

@available(iOS 13.0, *)
public class HapticPlayer {
    public init() {
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            engine?.stoppedHandler = { [weak self] stoppedReason in
                guard let self = self else { return }
                os_log(.error, log: self.logger, "Engine stopped by reason %d", stoppedReason.rawValue)
                
                self.needResetOnNextPlay = true
            }
            
            engine?.resetHandler = { [weak self] in
                guard let self = self else { return }
                os_log(.error, log: self.logger, "Reset engine")
                
                do {
                    try self.engine?.start()
                } catch {
                    os_log(.error, log: self.logger, "Can't create engine on reset", error.localizedDescription)
                }
            }
        } catch let error {
            os_log(.error, log: logger, "Can't create engine or start", error.localizedDescription)
        }
    }
    
    private var needResetOnNextPlay = false
    
    public func play(pattern: CHHapticPattern) {
        resetIfNeeded()
        
        do {
            player = try engine?.makePlayer(with: pattern)
            
            try player?.start(atTime: 0)
        } catch let error {
            os_log(.error, log: logger, "Can't play event", error.localizedDescription)
        }
    }
    
    private func resetIfNeeded() {
        try? player?.cancel()
        
        if needResetOnNextPlay {
            do {
                try self.engine?.start()
                needResetOnNextPlay = false
            } catch {
                os_log(.error, log: self.logger, "Can't reset engine on next play")
            }
        }
    }
    
    private let logger = OSLog(subsystem: "com.akaDuality.HapticComposer", category: "player")
    private var engine: CHHapticEngine? = nil
    private var player: CHHapticPatternPlayer?
}


