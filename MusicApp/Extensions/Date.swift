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
//        var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
        self.init(timeInterval: 0, since: date)
    }

    init(mySqlDateString: String) {
        let stringArr = mySqlDateString.components(separatedBy: "T")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: stringArr[0]) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    func addOrSubtractYear(year:Int) -> Date{
      return Calendar.current.date(byAdding: .year, value: year, to: Date())!
    }
    
    func addOrSubtractDays(day:Int) -> Date{
      return Calendar.current.date(byAdding: .day, value: day, to: self)!
    }
    
    func addOrSubtractMinutes(minutes: Int) -> Date{
      return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func asSqlDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    func asSqlDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.string(from: self)
    }
    
    func asMediumDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
    func asShortDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    func asDayOfWeekString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    
    func asdayOfMonthString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    func asMonthOfYearNumberString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self).capitalized
    }
    
    func asMonthOfYearNameFullString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self).capitalized
    }
    
    func asMonthOfYearNameShortString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self).capitalized
    }
    
    func asYearString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    func asTime() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func asHour() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self)
    }
    
    func asLongDateTime() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.string(from: self).capitalized
    }

}


extension DateFormatter {
    
}
