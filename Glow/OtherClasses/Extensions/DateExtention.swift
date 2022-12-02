//  Created by iOS Development Company on 2/23/17.
//  Copyright © 2017 iOS Development Company. All rights reserved.
//

import Foundation
import UIKit


extension Date{
    static func dateFromAppServerFormatNoti(from string: String, format: String = "d MMM,yyyy h:mm a") -> Date?{
        _serverFormatter.dateFormat = format
        return _serverFormatter.date(from: string)
    }
    
    static func dateFromAppServerFormat(from string: String, format: String = "yyyy-MM-dd") -> Date?{
        _serverFormatter.dateFormat = format
        return _serverFormatter.date(from: string)
    }

    static func dateFromServerFormat(from string: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> Date?{
        _serverFormatter.dateFormat = format
        return _serverFormatter.date(from: string)
    }
    
    static func dateFromLocalFormat(from string: String, format: String = "yyyy-MM-dd") -> Date?{
        _deviceFormatter.dateFormat = format
        return _deviceFormatter.date(from: string)
    }
    
    static func localDateString(from date: Date?, format: String = "yyyy-MM-dd") -> String{
        _deviceFormatter.dateFormat = format
        if let _ = date{
            return _deviceFormatter.string(from: date!)
        }else{
            return ""
        }
    }
    
    static func localTimeString(from date: Date?, format: String = "HH:mm a") -> String{
        _deviceFormatter.dateFormat = format
        if let _ = date{
            return _deviceFormatter.string(from: date!)
        }else{
            return ""
        }
    }
    
    static func serverDateString(from date: Date?, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> String{
        _serverFormatter.dateFormat = format
        if let _ = date{
            return _serverFormatter.string(from: date!)
        }else{
            return ""
        }
    }
    
    func removeTimeFromDate() -> Date{
        let str = Date.localDateString(from: self, format: "MM-dd-yyyy")
        return Date.dateFromLocalFormat(from: str, format: "MM-dd-yyyy")!
    }
    
    func getDateComponents() -> (day: String, month: String, year: String) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: self)
        let month = DateFormatter().monthSymbols[components.month! - 1]
        let day = String(components.day!)
        let year = String(components.year!)
        return (day,month,year)
    }
    
    func getTime() -> (hour: Int, minute: Int, seconds: Int) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let seconds = calendar.component(.second, from: self)
        return (hour,minutes,seconds)
    }
    
    func getAge() -> Int{
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self, to: now)
        return ageComponents.year!
    }
    
    func stringOfCurrentTime12HoursFormat() -> String {
        return _timeFormatter.string(from: self)
    }
    
    func getMaxBookingDate() -> Date{
        return Calendar.current.date(byAdding: .day, value: 2, to: self)!
    }
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
   
    func getChatHeaderDate() -> String{
        let orgDate = self.removeTimeFromDate()
        let curDate = Date().removeTimeFromDate()
        let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())!.removeTimeFromDate()
        if orgDate == curDate{
            return "today"
        }else if yesterDay == orgDate{
            return "yesterday"
        }else{
            return Date.localDateString(from: self, format: "dd MMMM yyyy").lowercased()
        }
    }
    
    func getDateSufix() -> String{
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: self)
        
        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day = "st"
        case "2" , "22":
            day = "nd"
        case "3" ,"23":
            day = "rd"
        default:
            day = "th"
        }
        return day
    }
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    
    func agoStringFromTime()-> String {
        let timeScale = ["now"  :1,
                         "m"  :60,
                         "h"   :3600,
                         "d"  :86400,
                         "w" :605800,
                         "y" :31556926];
        
        var scale : String = ""
        var timeAgo = 0 - Int(self.timeIntervalSinceNow)
        if (timeAgo < 60) {
            scale = "now";
        } else if (timeAgo < 3600) {
            scale = "m";
        } else if (timeAgo < 86400) {
            scale = "h";
        } else if (timeAgo < 605800) {
            scale = "d";
        } else if (timeAgo < 31556926) {
            scale = "w";
        } else {
            scale = "y";
        }
        
        timeAgo = timeAgo / Int(timeScale[scale]!)
        if scale == "now"{
            return scale
        }else{
            return "\(timeAgo)\(scale) ago"
        }
    }
    static func getISODateFormatConvertor(from string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate,
                                   .withTime,
                                   .withDashSeparatorInDate,
                                   .withColonSeparatorInTime]
        return formatter.date(from: string)
    }
    
    func getMonthAndYearString() -> (mon: String, year: String){
        var cal = Calendar.current
        cal.locale = Locale.current
        let comp = cal.dateComponents([.month, .year], from: self)
        
        let mon = comp.month == nil ? "" : "\(comp.month!)"
        let year = comp.year == nil ? "" : "\(comp.year!)"
        
        return (mon, year)
    }
    
    var isWeekend: Bool {
        return NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.isDateInWeekend(self)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func startOfWeek() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func timeLeftStringFromTime()-> String {
        let timeScale = ["now"  :1,
                         "m"  :60,
                         "h"  :3600,
                         "d"  :86400,
                         "w" :605800,
                         "y" :31556926];
        
        var scale : String = ""
        var timeAgo = Int(self.timeIntervalSinceNow) - Int(Date().timeIntervalSinceNow)
        if (timeAgo < 60) {
            scale = "now";
        } else if (timeAgo < 3600) {
            scale = "m";
        } else if (timeAgo < 86400) {
            scale = "h";
        } else if (timeAgo < 605800) {
            scale = "d";
        } else if (timeAgo < 31556926) {
            scale = "w";
        } else {
            scale = "y";
        }
        
        timeAgo = timeAgo / Int(timeScale[scale]!)
        if scale == "now"{
            return self.agoStringFromTime()
        }else{
            return "\(timeAgo)\(scale)"
        }
    }
    
//    func agoStringFromTime()-> String {
//        let timeScale = ["now"  :1,
//                         "min"  :60,
//                         "hr"   :3600,
//                         "day"  :86400,
//                         "week" :605800,
//                         "mth"  :2629743,
//                         "year" :31556926];
//
//        var scale : String = ""
//        var timeAgo = 0 - Int(self.timeIntervalSinceNow)
//        if (timeAgo < 60) {
//            scale = "now";
//        } else if (timeAgo < 3600) {
//            scale = "min";
//        } else if (timeAgo < 86400) {
//            scale = "hr";
//        } else if (timeAgo < 605800) {
//            scale = "day";
//        } else if (timeAgo < 2629743) {
//            scale = "week";
//        } else if (timeAgo < 31556926) {
//            scale = "mth";
//        } else {
//            scale = "year";
//        }
//
//        timeAgo = timeAgo / Int(timeScale[scale]!)
//        if scale == "now"{
//            return scale
//        }else{
//            return "\(timeAgo) \(scale) ago"
//        }
//    }
    
    
}
