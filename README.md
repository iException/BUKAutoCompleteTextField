# BUKAutoCompleteTextField

[![CI Status](http://img.shields.io/travis/monzy613/BUKAutoCompleteTextField.svg?style=flat)](https://travis-ci.org/monzy613/BUKAutoCompleteTextField)
[![Version](https://img.shields.io/cocoapods/v/BUKAutoCompleteTextField.svg?style=flat)](http://cocoapods.org/pods/BUKAutoCompleteTextField)
[![License](https://img.shields.io/cocoapods/l/BUKAutoCompleteTextField.svg?style=flat)](http://cocoapods.org/pods/BUKAutoCompleteTextField)
[![Platform](https://img.shields.io/cocoapods/p/BUKAutoCompleteTextField.svg?style=flat)](http://cocoapods.org/pods/BUKAutoCompleteTextField)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
```objc
UITextField *textField = [[UITextField alloc] init];
textField.translatesAutoresizingMaskIntoConstraints = NO;
textField.placeholder = @"enter phone number";
textField.font = [UIFont systemFontOfSize:16.0];
textField.autoCompleteDataSource = @[@"15316699712", @"15416699712", @"18316699712"];
[textField setAutoCompleteLabelDidChangeTextHandler:^(NSString *old, NSString *new) {
    NSLog(@"old: %@, new: %@", old, new);
}];
```

## Requirements

## SnapShots
![img](http://o7b20it1b.bkt.clouddn.com/autocompleteTextField.png)

## Installation

BUKAutoCompleteTextField is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BUKAutoCompleteTextField"
```

## Author

monzy613, monzy613@gmail.com

## License

BUKAutoCompleteTextField is available under the MIT license. See the LICENSE file for more info.
