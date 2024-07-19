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

import SwiftUI

@available(iOS 15.0, *)
struct CircularTickMarks: Shape {
  private let dayCounts = DateHelpers.maximumDayCountsInMonths
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let standardTickLength = 6.0
    let radius = min(rect.width, rect.height) / 2 - standardTickLength
    
    var dayCount = 0
    
    for month in 1...12 {
      let daysInMonth = dayCounts[month - 1]
      
      for day in 1...daysInMonth {
        let angle = (Double(dayCount) * 360 / Double(DateHelpers.maximumDayCountInYear)) - 90
        let tickLength = if day == 1 {
          standardTickLength * 3
        } else if day % 10 == 0 {
          standardTickLength * 1.6
        } else {
          standardTickLength
        }
        
        let startPoint = CGPoint(
          x: center.x + CGFloat(cos(angle * .pi / 180)) * (radius - standardTickLength),
          y: center.y + CGFloat(sin(angle * .pi / 180)) * (radius - standardTickLength)
        )
        let endPoint = CGPoint(
          x: center.x + CGFloat(cos(angle * .pi / 180)) * (radius + tickLength),
          y: center.y + CGFloat(sin(angle * .pi / 180)) * (radius + tickLength)
        )
        
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        dayCount += 1
      }
    }
    
    return path
  }
}

