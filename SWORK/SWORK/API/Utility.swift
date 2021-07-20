//
//  Utility.swift
//  SWORK
//
//  Created by Aasheesh Kumar Rai on 20/07/21.
//

import Foundation

extension Date {
//    var millisecondsSince1970:Int {
//        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
//    }
//
//    init(milliseconds:Int) {
//        self =  Date(timeIntervalSince1970: TimeInterval(milliseconds))
//        // milliseconds/1000
//    }
    
    static func getTodaysDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date)
    }
    
    static func getHourFrom(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        var string = dateFormatter.string(from: date)
        if string.last == "M" {
            string = String(string.prefix(string.count - 3))
        }
        return string
    }
    
    static func getDayOfWeekFrom(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        var string = dateFormatter.string(from: date)
        if let index = string.firstIndex(of: ",") {
            string = String(string.prefix(upTo: index))
            return string
        }
        return "error"
    }
    
    static func isDatePrime(date: Date?) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
        guard let date = date else {
            return false
        }
        formatter.dateFormat = "dd"
        let number = Int(formatter.string(from: date))!
        let i = 2
        var isItPrime = false
        if number == 1 {
            isItPrime = true
        }
        while i < number {
            if number % i == 0 {
                break
            } else {
                isItPrime = true
            }
        }
        return isItPrime
    }
}
