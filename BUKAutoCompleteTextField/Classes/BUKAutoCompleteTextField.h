//
//  BUKAutoCompleteTextField.h
//  Pods
//
//  Created by Monzy Zhang on 31/07/2016.
//
//

#import <UIKit/UIKit.h>

@interface BUKAutoCompleteTextField : UITextField

@property (nonatomic, strong, readonly) UILabel *hintLabel;
@property (nonatomic, strong) NSArray<NSString *> *autoCompleteDataSource;
@property (nonatomic, copy) void(^autoCompleteLabelDidChangeTextHandler)(NSString *oldText, NSString *newText);

@end
