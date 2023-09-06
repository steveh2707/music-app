//
//  Date.swift
//  MusicApp
//
//  Created by Steve on 16/06/2023.
//

import Foundation

extension Date {
    
    /// Initialise date from mySQL datetime string provided by API
    /// - Parameter mySqlDateTimeString: MySQL datetime string provided by API
    init(mySqlDateTimeString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: mySqlDateTimeString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    /// Initialise date from mySQL date string provided by API
    /// - Parameter mySqlDateString: MySQL date string provided by API
    init(mySqlDateString: String) {
        let stringArr = mySqlDateString.components(separatedBy: "T")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: stringArr[0]) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    /// Add or subtract years to a date
    /// - Parameter year: number of years to add or subtract
    /// - Returns: date modified by number of years
    func addOrSubtractYear(year:Int) -> Date{
      return Calendar.current.date(byAdding: .year, value: year, to: self)!
    }
    
    /// Add or subtract days to date
    /// - Parameter day: number of days to add or subtract
    /// - Returns: date modified by number of days
    func addOrSubtractDays(day:Int) -> Date{
      return Calendar.current.date(byAdding: .day, value: day, to: self)!
    }
    
    /// Add or subtract minutes to date
    /// - Parameter minutes: number of minutes to add or subtract
    /// - Returns: date modified by number of minutes
    func addOrSubtractMinutes(minutes: Int) -> Date{
      return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    /// Find the nearest of date
    /// - Returns: date modified to be to the nearest hour
    func nearestHour() -> Date {
        var components = NSCalendar.current.dateComponents([.minute, .second, .nanosecond], from: self)
        let minute = components.minute ?? 0
//        components.minute = minute >= 30 ? 60 - minute : -minute
        components.minute = 60 - minute
        components.second = -(components.second ?? 0)
        components.nanosecond = -(components.nanosecond ?? 0)
        return Calendar.current.date(byAdding: components, to: self) ?? Date()
    }
    
    /// Outputs date to a SQL date format string
    /// - Returns: date formatted to be understood by SQL
    func asSqlDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    /// Outputs date to a SQL datetime format string
    /// - Returns: datetime formatted to be understood by SQL
    func asSqlDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.string(from: self)
    }
    
    /// Outputs date to a medium date string to be displayed
    /// - Returns: medium length string describing date
    func asMediumDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
    /// Outputs date to a short date string to be displayed
    /// - Returns: short length string describing date
    func asShortDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    /// Outputs day of the week string that date is on
    /// - Returns: day of the week
    func asDayOfWeekString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    
    /// Outputs day of the month string that date is on
    /// - Returns: day of the month
    func asdayOfMonthString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    /// Outputs month number string that date is on
    /// - Returns: month number of year
    func asMonthOfYearNumberString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self).capitalized
    }
    
    /// Outputs month full name string that date is on
    /// - Returns: month full name
    func asMonthOfYearNameFullString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self).capitalized
    }
    
    /// Outputs month short name string that date is on
    /// - Returns: month short name
    func asMonthOfYearNameShortString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self).capitalized
    }
    
    /// Outputs year string that date is on
    /// - Returns: year
    func asYearString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    /// Outputs time that date is on
    /// - Returns: time
    func asTime() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    /// Outputs hour that date is on
    /// - Returns: hour
    func asHour() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self)
    }
    
    /// Outputs full date and time string that date is on
    /// - Returns: full date and time
    func asLongDateTime() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.string(from: self).capitalized
    }

}
