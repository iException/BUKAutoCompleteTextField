//
//  UITextField+BUKAutoComplete.h
//  Pods
//
//  Created by Monzy Zhang on 01/08/2016.
//
//

#import <UIKit/UIKit.h>

@interface UITextField (BUKAutoComplete)

@property (nonatomic, strong, readonly) UILabel *buk_autoCompleteLabel;
@property (nonatomic, strong) NSArray<NSString *> *buk_autoCompleteDataSource;
@property (nonatomic, copy) void(^buk_autoCompleteLabelDidChangeTextHandler)(NSString *oldText, NSString *newText);

@end
