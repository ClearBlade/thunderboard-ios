//
//  EnvironmentDemoStreamingConnection.swift
//  Thunderboard
//
//  Copyright © 2016 Silicon Labs. All rights reserved.
//

import Foundation

protocol EnvironmentDemoStreamingDataSource : class {
    func currentEnvironmentData() -> EnvironmentData?
}

class EnvironmentDemoStreamingConnection : DemoStreamingConnection {
    
    weak var dataSource: EnvironmentDemoStreamingDataSource?

    override func demoType() -> String {
        return "environment"
    }
    
    override func sampleDemoData() -> [DemoStreamingDataPoint]? {
        
        guard let sample = self.dataSource?.currentEnvironmentData() else {
            return nil
        }
        
        var data = Dictionary<String, AnyObject>()
        
        data["temperature"] = sample.temperature
        data["humidity"] = sample.humidity
        data["ambientLight"] = sample.ambientLight
        data["uvIndex"] = sample.uvIndex

        if let co2 = sample.co2 {
            if co2.enabled, let value = co2.value {
                data["co2"] = value
            }
        }
        
        if let voc = sample.voc {
            if voc.enabled, let value = voc.value {
                data["voc"] = value
            }
        }
        
        if let sound = sample.sound {
            data["sound"] = sound
        }
        
        if let pressure = sample.pressure {
            data["pressure"] = pressure
        }
        
        let path = "environment/data"
        let dataPoint = DemoStreamingDataPoint(path: path, timestamp: String(NSDate.tb_currentTimestamp), data: data)
        return [ dataPoint ]
    }
    
    override func reportingFrequency() -> NSTimeInterval {
        return NSTimeInterval(3)
    }
}