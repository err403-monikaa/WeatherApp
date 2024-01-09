//
//  Common.swift
//  WeatherApp
//
//  Created by Monikaa on 06/01/24.
//

import Foundation
import UIKit

class Common {
    
    // Converts the temperature to Celius
    static func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)
    }
    
    
    static func getDay(dateString: String) -> String {
        // Create a date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateString) else { return "" }
        
        // To get day from date
        formatter.dateFormat = "E"
        let day = formatter.string(from: date)
        return day
    }
    
    static func getHours(dateString: String) -> String {
        // Create a date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateString) else { return "" }
        
        // To get time from date
        formatter.dateFormat = "HH:mm:ss"
        let day = formatter.string(from: date)
        return day
    }  
}
