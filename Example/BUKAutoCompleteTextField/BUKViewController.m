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
    textField.frame = CGRectMake(20, 20, 335, 50);
    textField.placeholder = @"enter phone number";
    textField.font = [UIFont systemFontOfSize:16.0];
    textField.autoCompleteDataSource = @[@"15316699712", @"15416699712", @"18316699712"];
    [textField setAutoCompleteLabelDidChangeTextHandler:^(NSString *old, NSString *new) {
        NSLog(@"old: %@, new: %@", old, new);
    }];
    [self.view addSubview:textField];
}

@end
