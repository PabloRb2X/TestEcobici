//
//  Timer.swift
//  Ecobici
//
//  Created by Pablo Ramirez on 1/31/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import Foundation
import UIKit

public class TimerToken: NSObject {
    
    func startTimer(){
        countSecondsTimer = 0
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil,repeats: true)
    }
    
    @objc func updateTime() {
        countSecondsTimer += 1
        if countSecondsTimer >= 3600{
            endTimer()
            
            //////// Accion para informar al usuario que su sesión ha expirado
            
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                // topController should now be your topmost view controller
                if let currentVC = topController as? MapController {
                    //the type of currentVC is MyViewController inside the if statement, use it as you want to
                    currentVC.sessionExpired()
                }
            }
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
}
