//
//  Copyright 2024 Seyithan Teymur (https://seyithan.me)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this
//  software and associated documentation files (the “Software”), to deal in the Software
//  without restriction, including without limitation the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
//  to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies
//  or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
//  PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
//  FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
//  OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
//  OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

struct DateHelpers {
  static let maximumDayCountInYear = maximumDayCountsInMonths.reduce(0, +)
  static let maximumDayCountsInMonths = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  
  static func maximumDayCountInMonth(_ month: Int) -> Int {
    maximumDayCountsInMonths[month - 1]
  }
  
  static func daysFromYearStartToStartOfMonth(_ month: Int) -> Int {
    maximumDayCountsInMonths.prefix(month - 1).reduce(0, +)
  }
  
  static func daysFromYearStartToDate(_ date: Date) -> Int {
    let month = Calendar.current.component(.month, from: date)
    let day = Calendar.current.component(.day, from: date)
    
    let monthStartDayCount = daysFromYearStartToStartOfMonth(month)
    return monthStartDayCount + day - 1
  }
}

