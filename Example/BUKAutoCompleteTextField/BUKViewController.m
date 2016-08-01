//
//  BUKViewController.m
//  BUKAutoCompleteTextField
//
//  Created by monzy613 on 07/31/2016.
//  Copyright (c) 2016 monzy613. All rights reserved.
//

#import "BUKViewController.h"
#import "BUKAutoCompleteTextField/BUKAutoCompleteTextField.h"

@interface BUKViewController ()

@end

@implementation BUKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    BUKAutoCompleteTextField *textField = [[BUKAutoCompleteTextField alloc] init];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.placeholder = @"enter phone number";
    textField.font = [UIFont systemFontOfSize:16.0];
    textField.autoCompleteDataSource = @[@"15316699712", @"15416699712", @"18316699712"];
    [textField setAutoCompleteLabelDidChangeTextHandler:^(NSString *old, NSString *new) {
        NSLog(@"old: %@, new: %@", old, new);
    }];
    [self.view addSubview:textField];
    [self.view addConstraints:@[
                                [NSLayoutConstraint
                                 constraintWithItem:textField
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.view
                                 attribute:NSLayoutAttributeLeft
                                 multiplier:1.0
                                 constant:0.0],
                                [NSLayoutConstraint
                                 constraintWithItem:textField
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.view
                                 attribute:NSLayoutAttributeRight
                                 multiplier:1.0
                                 constant:0.0],
                                [NSLayoutConstraint
                                 constraintWithItem:textField
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.view
                                 attribute:NSLayoutAttributeTop
                                 multiplier:1.0
                                 constant:20.0],
                                [NSLayoutConstraint
                                 constraintWithItem:textField
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:nil
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                 constant:30.0],
                                ]];
}

@end
