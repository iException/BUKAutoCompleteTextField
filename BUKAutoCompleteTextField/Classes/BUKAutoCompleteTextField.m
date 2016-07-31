//
//  BUKAutoCompleteTextField.m
//  Pods
//
//  Created by Monzy Zhang on 31/07/2016.
//
//

#import "BUKAutoCompleteTextField.h"

@implementation BUKAutoCompleteTextField
@synthesize hintLabel = _hintLabel;

#pragma mark - lifecycle -
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.hintLabel];
        [self setupObservers];
        [self addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(frame))];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(font))];
}

#pragma mark - kvo -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    [self.superview addSubview:self.hintLabel];
    if (object == self && [keyPath isEqualToString:NSStringFromSelector(@selector(frame))]) {
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
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(frame)) options:NSKeyValueObservingOptionNew context:nil];
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


#pragma mark - getters -

- (UILabel *)hintLabel
{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _hintLabel.textColor = [UIColor grayColor];
        _hintLabel.font = self.font;
    }
    return _hintLabel;
}
@end
