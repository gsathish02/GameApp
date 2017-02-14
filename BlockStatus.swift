//
//  BlockStatus.swift
//  gameTest
//
//  Created by Sathish Kumar on 10/7/16.
//  Copyright © 2016 Sathish Kumar. All rights reserved.
//

import Foundation

class BlockStatus {
    var isRunning = false
    var timeForNextRun = UInt32(0)
    var currentWaitingTime = UInt32(0)
    
    init(isRunning : Bool, timeForNextRun : UInt32, currentWaitingTime : UInt32) {
        self.isRunning = isRunning
        self.currentWaitingTime = currentWaitingTime
        self.timeForNextRun = timeForNextRun
    }
    func shouldRun() -> Bool{
        return currentWaitingTime > timeForNextRun
    }
}
