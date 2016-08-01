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
static void const* autoCompleteKVOManagerKey = &autoCompleteKVOManagerKey;
static void const* autoCompleteDataSourceKey = &autoCompleteDataSourceKey;
static void const* autoCompleteDidChangeTextHandlerKey = &autoCompleteDidChangeTextHandlerKey;


#pragma mark - kvo manager -
@interface BUKAutoCompleteKVOManager : NSObject

@property (nonatomic, weak) UITextField *textField;

- (instancetype)initWithTextField:(UITextField *)textField;

@end

@implementation BUKAutoCompleteKVOManager

- (instancetype)initWithTextField:(UITextField *)textField
{
    self = [super init];
    if (self) {
        _textField = textField;
        [self setupObservers];
    }
    return self;
}

#pragma mark - kvo -
- (void)setupObservers
{
    [self.textField addObserver:self forKeyPath:NSStringFromSelector(@selector(bounds)) options:NSKeyValueObservingOptionNew context:nil];
    [self.textField addObserver:self forKeyPath:NSStringFromSelector(@selector(font)) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context
{
    if (!self.textField.autoCompleteDataSource.count) {
        return;
    }
    if (object == self.textField && [keyPath isEqualToString:NSStringFromSelector(@selector(bounds))]) {
        self.textField.hintLabel.frame = self.textField.bounds;
    } else if (object == self.textField && [keyPath isEqualToString:NSStringFromSelector(@selector(font))]) {
        self.textField.hintLabel.font = self.textField.font;
    }
}

@end

#pragma mark - category -
@implementation UITextField (BUKAutoComplete)

#pragma mark - action handlers -
- (void)textDidChange
{
    [self updateAutoCompleteTextWithPrefix:self.text];
}

#pragma mark - privates -
- (void)autoCompleteTextField
{
    if (!self.hintLabel.text.length || !self.autoCompleteDataSource.count) {
        return;
    }
    self.text = self.hintLabel.text;
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

- (void)initAutoComplete
{
    [self addSubview:self.hintLabel];
    [self addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(autoCompleteTextField) forControlEvents:UIControlEventEditingDidEnd];
    objc_setAssociatedObject(self, autoCompleteKVOManagerKey, [[BUKAutoCompleteKVOManager alloc] initWithTextField:self], OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - getters && setters -
#pragma mark - setters
- (void)setAutoCompleteDataSource:(NSArray<NSString *> *)autoCompleteDataSource
{
    if (!autoCompleteDataSource.count) {
        return;
    }
    [self initAutoComplete];
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
