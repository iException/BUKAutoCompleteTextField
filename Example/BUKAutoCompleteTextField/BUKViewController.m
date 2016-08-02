//
//  BUKViewController.m
//  BUKAutoCompleteTextField
//
//  Created by monzy613 on 07/31/2016.
//  Copyright (c) 2016 monzy613. All rights reserved.
//

#import "BUKViewController.h"
#import "BUKAutoCompleteTextField/UITextField+BUKAutoComplete.h"

@interface BUKViewController ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation BUKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textField = [[UITextField alloc] init];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.placeholder = @"enter phone number";
    self.textField.font = [UIFont systemFontOfSize:16.0];
    self.textField.buk_autoCompleteDataSource = @[@"15316699712", @"15416699712", @"18316699712"];
    [self.view addSubview:self.textField];
    [self.view addConstraints:@[
                                [NSLayoutConstraint
                                 constraintWithItem:self.textField
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.view
                                 attribute:NSLayoutAttributeLeft
                                 multiplier:1.0
                                 constant:0.0],
                                [NSLayoutConstraint
                                 constraintWithItem:self.textField
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.view
                                 attribute:NSLayoutAttributeRight
                                 multiplier:1.0
                                 constant:0.0],
                                [NSLayoutConstraint
                                 constraintWithItem:self.textField
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self.view
                                 attribute:NSLayoutAttributeTop
                                 multiplier:1.0
                                 constant:20.0],
                                [NSLayoutConstraint
                                 constraintWithItem:self.textField
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:nil
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                 constant:30.0],
                                ]];
}

- (IBAction)complete:(id)sender
{
    [self.view endEditing:YES];
    [self.textField removeFromSuperview];
    self.textField = nil;
}

@end
