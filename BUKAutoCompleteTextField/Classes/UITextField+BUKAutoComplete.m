//
//  UITextField+BUKAutoComplete.m
//  Pods
//
//  Created by Monzy Zhang on 01/08/2016.
//
//

#import "UITextField+BUKAutoComplete.h"
#import <objc/runtime.h>

static void const* autoCompleteLabelKey = &autoCompleteLabelKey;
static void const* autoCompleteDataSourceKey = &autoCompleteDataSourceKey;
static void const* autoCompleteDidChangeTextHandlerKey = &autoCompleteDidChangeTextHandlerKey;

@implementation UITextField (BUKAutoComplete)

#pragma mark - swizzle -
+ (void)bukAutoComplete_SwizzlingMethodOfOriginName:(NSString *)originName;
{
    SEL originalSelector = NSSelectorFromString(originName);
    SEL swizzledSelector = NSSelectorFromString([NSString stringWithFormat:@"bukAutoComplete_%@", originName]);

    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);

    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)bukAutoComplete_setBounds:(CGRect)bounds
{
    [self bukAutoComplete_setBounds:bounds];
    self.buk_autoCompleteLabel.frame = bounds;
}

- (void)bukAutoComplete_setFrame:(CGRect)frame
{
    [self bukAutoComplete_setFrame:frame];
    self.buk_autoCompleteLabel.frame = self.bounds;
}

- (void)bukAutoComplete_setFont:(UIFont *)font
{
    [self bukAutoComplete_setFont:font];
    self.buk_autoCompleteLabel.font = font;
}

#pragma mark - action handler -
- (void)buk_textDidChange
{
    [self buk_updateAutoCompleteTextWithPrefix:self.text];
}

#pragma mark - privates -
- (void)buk_autoCompleteTextField
{
    if (!self.buk_autoCompleteLabel.text.length || !self.buk_autoCompleteDataSource.count) {
        return;
    }
    self.text = self.buk_autoCompleteLabel.text;
}

- (void)buk_updateAutoCompleteTextWithPrefix:(NSString *)prefix
{
    if (!self.buk_autoCompleteDataSource.count) {
        return;
    }
    NSString *trimmed = [prefix stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *newAutoCompleteString = @"";
    for (NSString *string in self.buk_autoCompleteDataSource) {
        if ([string hasPrefix:trimmed]) {
            newAutoCompleteString = string;
            break;
        }
    }

    if (self.buk_autoCompleteLabelDidChangeTextHandler && ![newAutoCompleteString isEqualToString:self.buk_autoCompleteLabel.text]) {
        self.buk_autoCompleteLabelDidChangeTextHandler(self.buk_autoCompleteLabel.text, newAutoCompleteString);
    }
    self.buk_autoCompleteLabel.text = newAutoCompleteString;
}

- (void)buk_initAutoComplete
{
    [[self class] bukAutoComplete_SwizzlingMethodOfOriginName:NSStringFromSelector(@selector(setBounds:))];
    [[self class] bukAutoComplete_SwizzlingMethodOfOriginName:NSStringFromSelector(@selector(setFrame:))];
    [[self class] bukAutoComplete_SwizzlingMethodOfOriginName:NSStringFromSelector(@selector(setFont:))];
    [self addSubview:self.buk_autoCompleteLabel];
    [self addTarget:self action:@selector(buk_textDidChange) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(buk_autoCompleteTextField) forControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - getters && setters -
#pragma mark - setters
- (void)setBuk_autoCompleteDataSource:(NSArray<NSString *> *)buk_autoCompleteDataSource
{
    if (!buk_autoCompleteDataSource.count) {
        return;
    }
    [self buk_initAutoComplete];
    objc_setAssociatedObject(self, autoCompleteDataSourceKey, buk_autoCompleteDataSource, OBJC_ASSOCIATION_RETAIN);
}

- (void)setBuk_autoCompleteLabelDidChangeTextHandler:(void (^)(NSString *, NSString *))buk_autoCompleteLabelDidChangeTextHandler
{
    objc_setAssociatedObject(self, autoCompleteDidChangeTextHandlerKey, buk_autoCompleteLabelDidChangeTextHandler, OBJC_ASSOCIATION_COPY);
}

#pragma mark - getters
- (UILabel *)buk_autoCompleteLabel
{
    UILabel *_autoCompleteLabel = objc_getAssociatedObject(self, autoCompleteLabelKey);
    if (!_autoCompleteLabel) {
        _autoCompleteLabel = [[UILabel alloc] initWithFrame:self.bounds];
        objc_setAssociatedObject(self, autoCompleteLabelKey, _autoCompleteLabel, OBJC_ASSOCIATION_RETAIN);
        _autoCompleteLabel.textColor = [UIColor grayColor];
        _autoCompleteLabel.font = self.font;
    }
    return _autoCompleteLabel;
}

- (NSArray<NSString *> *)buk_autoCompleteDataSource
{
    NSArray<NSString *> * _autoCompleteDataSource = objc_getAssociatedObject(self, autoCompleteDataSourceKey);
    return _autoCompleteDataSource;
}

- (void (^)(NSString *, NSString *))buk_autoCompleteLabelDidChangeTextHandler
{
    void(^handler)(NSString *oldText, NSString *newText) = objc_getAssociatedObject(self, autoCompleteDidChangeTextHandlerKey);
    return handler;
}
@end
