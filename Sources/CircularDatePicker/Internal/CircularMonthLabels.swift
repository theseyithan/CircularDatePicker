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
struct CircularMonthLabels: View {
  var selectedMonth: Int
  var size: CGSize
  var rotationAngle: Double
  
  var labels: [String]
  
  var renderer: CircularMonthLabelRenderer
  
  init(selectedMonth: Int, size: CGSize, rotationAngle: Double, labels: [String] = Calendar.current.shortMonthSymbols) {
    self.selectedMonth = selectedMonth
    self.size = size
    self.rotationAngle = rotationAngle
    
    let labels = labels.map(\.localizedUppercase)
    self.labels = labels
    
    self.renderer = CircularMonthLabelRenderer(size: size, rotationAngle: rotationAngle, selectedMonth: selectedMonth, labels: labels)
    self.renderer.calculatePositions()
  }
  
  var body: some View {
    ForEach(1...12, id: \.self) { month in
      let isSelected = month == selectedMonth
      
      CurvedText(
        monthLabel(for: month),
        radius: renderer.circleRadius,
        startAngle: renderer.angleForMonth(month),
        font: .callout,
        isSelected: isSelected
      )
      .foregroundStyle(isSelected ? .primary : .secondary)
    }
  }
  
  private func monthLabel(for month: Int) -> String {
    labels[month - 1]
  }
  
  private func angleForMonth(_ month: Int) -> Double {
    let dayOfYear = DateHelpers.daysFromYearStartToStartOfMonth(month)
    return (Double(dayOfYear) * 2 * .pi / Double(DateHelpers.maximumDayCountInYear)) - .pi / 2
  }
}

@available(iOS 13.0, *)
struct CircularMonthLabelRenderer {
  var positions: [Int: Angle] = [:]
  
  var size: CGSize
  var rotationAngle: Double
  var selectedMonth: Int
  var labels: [String]
  
  private(set) var widths: [Int: CGFloat] = [:]
  
  var circleRadius: CGFloat {
    min(size.width, size.height) / 2 + 20
  }
  
  mutating func calculatePositions() {
    setInitialPositions()
    setInitialSizes()
    fixOverlaps()
  }
  
  func angleForMonth(_ month: Int) -> Angle {
    positions[month] ?? .zero
  }
  
  private mutating func setInitialPositions() {
    for month in 1...12 {
      positions[month] = initialAngleForMonth(month)
    }
  }
  
  private mutating func setInitialSizes() {
    let font = UIFont.preferredFont(forTextStyle: .callout)
    for month in 1...12 {
      let label = labels[month - 1]
      let width = label.size(withAttributes: [.font: font]).width // Approximation works well enough
      widths[month] = width
    }
  }
  
  private mutating func fixOverlaps() {
    for month in 1...12 {
      let previousMonth = month == 1 ? 12 : month - 1
      
      var difference = angleForMonth(month).degrees - angleForMonth(previousMonth).degrees
      if difference > 360 {
        difference -= 360
      } else if difference < 0 {
        difference += 360
      }
      
      let estimatedOverlap = (widths[month]! + widths[previousMonth]!) / 7.8 // Magic number
      let push = (estimatedOverlap - difference) / 2
      
      if difference <  estimatedOverlap {
        positions[month] = angleForMonth(month) + Angle(degrees: push)
        positions[previousMonth] = angleForMonth(previousMonth) - Angle(degrees: push)
      }
    }
  }
  
  private func initialAngleForMonth(_ month: Int) -> Angle {
    if month == selectedMonth {
      return Angle(degrees: 360 - rotationAngle - 90)
    }
    
    let dayOfYear = if !isMonthOnLeftSideOfTheCircle(month) {
      DateHelpers.daysFromYearStartToStartOfMonth(month + 1) - 1
    } else {
      DateHelpers.daysFromYearStartToStartOfMonth(month)
    }
    let angle = (Double(dayOfYear) * 2 * .pi / Double(DateHelpers.maximumDayCountInYear)) - .pi / 2
    return Angle(radians: angle)
  }
  
  private func isMonthOnLeftSideOfTheCircle(_ month: Int) -> Bool {
    let monthDifference = (month - selectedMonth + 12) % 12
    return monthDifference > 0 && monthDifference < 6
  }
}


