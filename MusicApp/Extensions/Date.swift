//
//  Date.swift
//  MusicApp
//
//  Created by Steve on 16/06/2023.
//

import Foundation

extension Date {
    

    init(mySqlDateTimeString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        //    formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: mySqlDateTimeString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    
    private var mediumFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    func asMediumDateString() -> String {
        return mediumFormatter.string(from: self)
    }
    
    private var sqlDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    func asSqlDateString() -> String {
        return sqlDateFormatter.string(from: self)
    }
    
    func addOrSubtractYear(year:Int)->Date{
      return Calendar.current.date(byAdding: .year, value: year, to: Date())!
    }
    
}
