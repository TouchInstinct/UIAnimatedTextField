# UIAnimatedTextField

## Installation

UIAnimatedTextField is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the pod 'UIAnimatedTextField' and the source for podspecs to your Podfile. For example:

```ruby
source "https://github.com/iznv/Podspecs.git"

platform :ios, '9.0'
use_frameworks!

target "ProjectName" do
    pod 'UIAnimatedTextField'
end
```

## Usage
Set height of UIView to 50. Create IBOutlet:
```swift
@IBOutlet weak var textField: UIAnimatedTextField!
```

In order to enable placeholder, set placeholder property:
```swift
textField.placeholder = "Enter something"
```

### Simple type
By default you use simple type. It is just a text field.

<img src="https://raw.githubusercontent.com/iznv/UIAnimatedTextField/master/UIAnimatedTextField/Screenshots/simple1.png" width="300">
<img src="https://raw.githubusercontent.com/iznv/UIAnimatedTextField/master/UIAnimatedTextField/Screenshots/simple2.png" width="300">

### Password type
In order to use UIAnimatedTextField for password input, specify its type as .password 
```swift
textField.type = .password
```

### Date type
In order to use UIAnimatedTextField for date input, specify its type as .date 
```swift
textField.type = .date
```
Also you can set date format and done button title:
```swift
// "Done" by default
textField.doneTitle = "Ok"
// "dd/MM/YYYY" by default
textField.dateFormat = "dd MMMM YYYY"
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## License
Copyright (c) 2016 Touch Instinct

UIAnimatedTextField is available under the MIT license. See the LICENSE file for more info.
