    //
//  UITextField+BUKAutoComplete.m
//  Pods
//
//  Created by Monzy Zhang on 01/08/2016.
//
//

#import "UITextField+BUKAutoComplete.h"
#import <objc/runtime.h>

static void const* hintLabelKey = &hintLabelKey;
static void const* autoCompleteDataSourceKey = &autoCompleteDataSourceKey;
static void const* autoCompleteDidChangeTextHandlerKey = &autoCompleteDidChangeTextHandlerKey;

@implementation UITextField (BUKAutoComplete)

+ (void)load
{
    [self exchange_implementations:@selector(sw_dealloc) selector2:NSSelectorFromString(@"dealloc")];
    [self exchange_implementations:@selector(initWithFrame:) selector2:@selector(sw_initWithFrame:)];
}

+ (void)exchange_implementations:(SEL)selector1 selector2:(SEL)selector2
{
    Method m1 = class_getInstanceMethod(self, selector1);
    Method m2 = class_getInstanceMethod(self, selector2);
    method_exchangeImplementations(m1, m2);
}

#pragma mark - swizzle -
- (void)sw_dealloc
{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(bounds))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(font))];
    [self sw_dealloc];
}

- (instancetype)sw_initWithFrame:(CGRect)frame
{
    [self sw_initWithFrame:frame];
    if (self) {
        [self addSubview:self.hintLabel];
        [self setupObservers];
        [self addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

#pragma mark - public -
- (void)updateTextFieldTextWithHintLabel
{
    if (!self.hintLabel.text.length || !self.autoCompleteDataSource.count) {
        return;
    }
    self.text = self.hintLabel.text;
}

#pragma mark - kvo -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:NSStringFromSelector(@selector(bounds))]) {
        self.hintLabel.frame = self.bounds;
    } else if (object == self && [keyPath isEqualToString:NSStringFromSelector(@selector(font))]) {
        self.hintLabel.font = self.font;
    }
}

#pragma mark - action handlers -
- (void)textDidChange
{
    [self updateAutoCompleteTextWithPrefix:self.text];
}

#pragma mark - privates -
- (void)setupObservers
{
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(bounds)) options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(font)) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)updateAutoCompleteTextWithPrefix:(NSString *)prefix
{
    if (!self.autoCompleteDataSource.count) {
        return;
    }
    NSString *trimmed = [prefix stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *newAutoCompleteString = @"";
    for (NSString *string in self.autoCompleteDataSource) {
        if ([string hasPrefix:trimmed]) {
            newAutoCompleteString = string;
            break;
        }
    }

    if (self.autoCompleteLabelDidChangeTextHandler && ![newAutoCompleteString isEqualToString:self.hintLabel.text]) {
        self.autoCompleteLabelDidChangeTextHandler(self.hintLabel.text, newAutoCompleteString);
    }
    self.hintLabel.text = newAutoCompleteString;
}

#pragma mark - getters && setters -
#pragma mark - setters
- (void)setAutoCompleteDataSource:(NSArray<NSString *> *)autoCompleteDataSource
{
    objc_setAssociatedObject(self, autoCompleteDataSourceKey, autoCompleteDataSource, OBJC_ASSOCIATION_RETAIN);
}

- (void)setAutoCompleteLabelDidChangeTextHandler:(void (^)(NSString *, NSString *))autoCompleteLabelDidChangeTextHandler
{
    objc_setAssociatedObject(self, autoCompleteDidChangeTextHandlerKey, autoCompleteLabelDidChangeTextHandler, OBJC_ASSOCIATION_COPY);
}

#pragma mark - getters
- (UILabel *)hintLabel
{
    UILabel *_hintLabel = objc_getAssociatedObject(self, hintLabelKey);
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] initWithFrame:self.bounds];
        objc_setAssociatedObject(self, hintLabelKey, _hintLabel, OBJC_ASSOCIATION_RETAIN);
        _hintLabel.textColor = [UIColor grayColor];
        _hintLabel.font = self.font;
    }
    return _hintLabel;
}

- (NSArray<NSString *> *)autoCompleteDataSource
{
    NSArray<NSString *> * _autoCompleteDataSource = objc_getAssociatedObject(self, autoCompleteDataSourceKey);
    return _autoCompleteDataSource;
}

- (void (^)(NSString *, NSString *))autoCompleteLabelDidChangeTextHandler
{
    void(^handler)(NSString *oldText, NSString *newText) = objc_getAssociatedObject(self, autoCompleteDidChangeTextHandlerKey);
    return handler;
}

@end
