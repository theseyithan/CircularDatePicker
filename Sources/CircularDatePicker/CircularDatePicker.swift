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
public struct CircularDatePicker: View {
  @Binding public var selectedDate: Date
  
  @State private var rotationAngle: Double = 0
  @State private var lastDragLocation: CGPoint?
  
  private let calendar = Calendar.current
  
  public init(selectedDate: Binding<Date>) {
    self._selectedDate = selectedDate
  }
  
  public var body: some View {
    let selectedMonth = calendar.component(.month, from: selectedDate)
    
    GeometryReader { geometry in
      let width = geometry.size.width
      let size = CGSize(width: width, height: width)
      
      VStack {
        ZStack {
          ZStack {
            CircularTickMarks()
              .stroke(Color.gray.opacity(0.3), lineWidth: 1)
              .padding(36)
            
            CircularMonthLabels(
              selectedMonth: selectedMonth,
              size: CGSize(width: width * 1.2, height: width * 1.2),
              rotationAngle: rotationAngle
            )
            .foregroundStyle(.primary, .gray)
          }
          .rotationEffect(Angle(degrees: rotationAngle))
          
          Rectangle()
            .fill(.primary)
            .frame(width: 2, height: 25)
            .offset(y: -size.height / 1.8)
          
          Text("\(calendar.component(.day, from: selectedDate))")
            .font(.system(size: 60, weight: .thin))
            .offset(y: -size.height / 1.32)
        }
        .frame(width: size.width)
        .padding(.bottom, -size.height * 1.4)
        .clipped()
        .onAppear {
          setRotationAngle(date: selectedDate)
        }
        .gesture(
          DragGesture()
            .onChanged { value in
              setRotationAngle(size: size, gestureValue: value)
            }
            .onEnded { _ in
              lastDragLocation = nil
              setRotationAngle(date: selectedDate)
            }
        )
      }
    }
    .scaledToFit()
  }
  
  private func setRotationAngle(size: CGSize, gestureValue: DragGesture.Value) {
    let startLocation = lastDragLocation ?? gestureValue.startLocation
    
    let center = CGPoint(x: size.width / 2, y: size.height)
    let startAngle = atan2(startLocation.y - center.y, startLocation.x - center.x)
    let currentAngle = atan2(gestureValue.location.y - center.y, gestureValue.location.x - center.x)
    let deltaAngle = (currentAngle - startAngle) / 2
    
    var deltaDegrees = deltaAngle * 180 / .pi
    if deltaDegrees > 160 {
      deltaDegrees -= 180
    } else if deltaDegrees < -160 {
      deltaDegrees += 180
    }
    
    rotationAngle += deltaDegrees
    lastDragLocation = gestureValue.location
    
    rotationAngle = rotationAngle.truncatingRemainder(dividingBy: 360)
    if rotationAngle < 0 {
      rotationAngle += 360
    }
    
    updateSelectedDate()
  }
  
  private func setRotationAngle(date: Date) {
    let daysInYear = DateHelpers.maximumDayCountInYear
    let daysBetween = DateHelpers.daysFromYearStartToDate(date)
    
    rotationAngle = 360 - (Double(daysBetween) * (360 / Double(daysInYear)))
    
    rotationAngle = rotationAngle.truncatingRemainder(dividingBy: 360)
    if rotationAngle < 0 {
      rotationAngle += 360
    }
    
    selectedDate = date
  }
  
  private var yearStartDate: Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year], from: selectedDate)
    return calendar.date(from: components)!
  }
  
  private func updateSelectedDate() {
    let dayOfYear = Int((-rotationAngle / 360) * Double(DateHelpers.maximumDayCountInYear))
    if let newDate = calendar.date(byAdding: .day, value: dayOfYear, to: yearStartDate) {
      selectedDate = newDate
    }
  }
}

@available(iOS 15.0, *)
struct CircularDatePreviewContainer: View {
  @State var selectedDate: Date = .now
  
  var body: some View {
    VStack {
      Spacer()
      CircularDatePicker(selectedDate: $selectedDate)
        .background(.white)
        .cornerRadius(14)
        .padding()
        .foregroundStyle(.red)
        .shadow(color: .black.opacity(0.14), radius: 12)
    }
    .background(.orange.opacity(0.2))
  }
}

@available(iOS 15.0, *)
#Preview {
  CircularDatePreviewContainer()
}
