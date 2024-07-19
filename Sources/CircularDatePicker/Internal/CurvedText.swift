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
import CoreGraphics

@available(iOS 15.0, *)
struct CurvedText: View {
  let text: String
  let radius: CGFloat
  let startAngle: Angle
  let font: Font
  let isSelected: Bool
  
  init(_ text: String, radius: CGFloat = 100, startAngle: Angle = .zero, font: Font = .body, isSelected: Bool = false) {
    self.text = text
    self.radius = radius
    self.startAngle = startAngle
    self.font = font
    self.isSelected = isSelected
  }
  
  var body: some View {
    
    Canvas { context, size in
      let initialTransform = context.transform
      
      let wholeText = Text(verbatim: text).font(font)
      let resolvedWholeText = context.resolve(wholeText)
      let wholeTextSize = resolvedWholeText.measure(in: size)
      let halfTextWidth = wholeTextSize.width
      
      var angle = startAngle.radians - (halfTextWidth / (2 * radius))
      
      let center = CGPoint(x: size.width / 2, y: size.height / 2)
      
      for character in text {
        context.transform = initialTransform
        
        let text = Text(verbatim: String(character)).font(font)
        let resolvedText = context.resolve(text)
        let charSize = resolvedText.measure(in: size)
        let halfWidth = charSize.width / 2
        
        context.translateBy(x: center.x, y: center.y)
        context.rotate(by: Angle(radians: angle + Double.pi / 2))
        context.translateBy(x: 0, y: -radius)
        
        let rect = CGRect(x: -halfWidth, y: 0, width: charSize.width, height: charSize.height)
        
        context.draw(resolvedText, in: CGRect(origin: .zero, size: rect.size))
        
        angle += atan2(charSize.width, radius)
      }
    }
    .frame(width: radius * 2, height: radius * 2)
  }
}

extension Character {
  func size(withAttributes attributes: [NSAttributedString.Key: Any]) -> CGSize {
    return String(self).size(withAttributes: attributes)
  }
  
  func draw(at point: CGPoint, withAttributes attributes: [NSAttributedString.Key: Any]) {
    String(self).draw(at: point, withAttributes: attributes)
  }
}
