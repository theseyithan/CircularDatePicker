# CircularDatePicker

An interactive circular date picker for SwiftUI.

## Description

CircularDatePicker is a custom date selection component for iOS apps that use SwiftUI. It presents months in a circular layout, allowing users to navigate through dates with a natural rotational gesture.

![CircularDatePicker demo](https://imgur.com/a/OlpFXj3)

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/theseyithan/CircularDatePicker", from: "1.0.0")
]
```

## Usage
```swift
import SwiftUI
import CircularDatePicker

struct ContentView: View {
  @State var selectedDate = Date.now
  
  var body: some View {
    VStack {
      CircularDatePicker(selectedDate: $selectedDate)
        .foregroundStyle(.green)
    }
  }
}
```

## Requirements
- iOS 14.0+
- Swift 5.4+

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License - see the LICENSE.md file for details.
