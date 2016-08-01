//
//  UITextField+BUKAutoComplete.h
//  Pods
//
//  Created by Monzy Zhang on 01/08/2016.
//
//

#import <UIKit/UIKit.h>

@interface UITextField (BUKAutoComplete)

@property (nonatomic, strong, readonly) UILabel *hintLabel;
@property (nonatomic, strong) NSArray<NSString *> *autoCompleteDataSource;
@property (nonatomic, copy) void(^autoCompleteLabelDidChangeTextHandler)(NSString *oldText, NSString *newText);

@end
