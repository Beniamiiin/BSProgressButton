//
//  BSProgressButtonView.m
//
//  Created by Beniamin Sarkisyan on 08/06/15.
//  Copyright (c) 2015 Cleverpumpkin, Ltd. All rights reserved.
//

#import "BSProgressButtonView.h"

@interface BSProgressButtonView ()

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIView *progressView;
@property (nonatomic, weak) UIButton *completionButton;

@property (nonatomic, strong) UIColor *p_bgColor;
@property (nonatomic, strong) UIColor *p_bgViewColor;
@property (nonatomic, strong) UIColor *p_progressViewColor;
@property (nonatomic, strong) UIColor *p_textColor;
@property (nonatomic, assign) CGFloat p_textFontSize;
@property (nonatomic, strong) UIFont *p_textFont;
@property (nonatomic, copy) NSString *p_text;
@property (nonatomic, assign) NSInteger p_progress;
@property (nonatomic, assign) BOOL p_animateUpdateProgress;
@property (nonatomic, assign) NSTimeInterval p_animationUpdateProgressDuration;

@property (nonatomic, strong) NSLayoutConstraint *bgViewWidthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *progressViewWidthConstraint;

@end

@implementation BSProgressButtonView

+ (instancetype)progressButtonWithFrame:(CGRect)frame completionBlock:(BSProgressButtonCompletionBlock)completion
{
    return [[self alloc] initProgressButtonWithFrame:frame completionBlock:completion];
}

- (instancetype)initProgressButtonWithFrame:(CGRect)frame completionBlock:(BSProgressButtonCompletionBlock)completion
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        _completionBlock = completion;
        
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if ( self )
    {
        [self setup];
    }
    
    return self;
}

#pragma mark - Setup methods
- (void)setup
{
    [self setupDefaultSettings];
    
    [self setupSelf];
    [self setupBGView];
    [self setupProgressView];
    [self setupCompletionButton];
    [self setupCommonConstraints];
}

- (void)setupDefaultSettings
{
    self.p_bgColor = [UIColor clearColor];
    self.p_bgViewColor = [[UIColor redColor] colorWithAlphaComponent:0.55f];
    self.p_progressViewColor = [self.p_bgViewColor colorWithAlphaComponent:1.f];
    self.p_textColor = [UIColor colorWithWhite:1.f alpha:0.95f];
    self.p_textFontSize = 16.f;
    self.p_textFont = [UIFont systemFontOfSize:self.p_textFontSize];
    self.p_animateUpdateProgress = YES;
    self.p_animationUpdateProgressDuration = 0.3f;
    self.p_text = @"Button";
}

- (void)setupSelf
{
    self.backgroundColor = self.p_bgColor;
}

- (void)setupBGView
{
    UIView *bgView = [UIView new];
    bgView.translatesAutoresizingMaskIntoConstraints = NO;
    bgView.backgroundColor = self.p_bgViewColor;
    
    [self addSubview:bgView];
    
    self.bgView = bgView;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(bgView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[bgView]-(0)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

- (void)setupProgressView
{
    UIView *progressView = [UIView new];
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    progressView.backgroundColor = self.p_progressViewColor;
    
    [self addSubview:progressView];
    
    self.progressView = progressView;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(progressView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[progressView]-(0)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    
}

- (void)setupCompletionButton
{
    UIButton *completionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    completionButton.translatesAutoresizingMaskIntoConstraints = NO;
    completionButton.backgroundColor = [UIColor clearColor];
    completionButton.titleLabel.font = self.p_textFont;
    
    [completionButton setTitleColor:self.p_textColor forState:UIControlStateNormal];
    [completionButton setTitle:self.p_text forState:UIControlStateNormal];
    
    completionButton.userInteractionEnabled = NO;
    
    [completionButton addTarget:self
                         action:@selector(completionButtonAction)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:completionButton];
    
    self.completionButton = completionButton;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(completionButton);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[completionButton]-(0)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[completionButton]-(0)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

- (void)setupCommonConstraints
{
    NSDictionary *views = @{
                            @"bgView"		: self.bgView,
                            @"progressView" : self.progressView
                            };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[progressView]-(0)-[bgView]-(0)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
    self.progressViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.progressView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:0.f
                                                                     constant:0.f];
    [self addConstraint:self.progressViewWidthConstraint];
}

#pragma mark - Helpers
- (void)updateSubviews
{
    self.backgroundColor = self.bgColor ?: self.p_bgColor;
    self.bgView.backgroundColor = self.bgViewColor ?: self.p_bgViewColor;
    self.progressView.backgroundColor = self.progressViewColor ?: self.p_progressViewColor;
    
    UIColor *titleColor = self.textColor ?: self.p_textColor;
    [self.completionButton setTitleColor:titleColor forState:UIControlStateNormal];
    
    // font
    {
        UIFont *titleFont;
        
        if ( self.textFont )
        {
            titleFont = self.textFont ?: self.p_textFont;
            
            if ( self.textFontSize )
            {
                titleFont = [titleFont fontWithSize:self.textFontSize];
            }
        }
        else if ( self.textFontName )
        {
            CGFloat fontSize = self.textFontSize ?: self.p_textFontSize;
            NSString *fontName = self.textFontName;
            titleFont = [UIFont fontWithName:fontName size:fontSize];
        }
        
        if ( titleFont )
        {
            self.completionButton.titleLabel.font = titleFont;
        }
    }
    
    NSString *text = self.text ?: self.p_text;
    [self.completionButton setTitle:text forState:UIControlStateNormal];
}

- (void)updateProgress:(CGFloat)progress
{
    [self updateProgress:progress withAnimation:self.animateUpdateProgress];
}

- (void)updateProgress:(CGFloat)progress withAnimation:(BOOL)animation
{
    _progress = progress > 1.f ? 1.f : progress;
    
    BOOL lastUserInteractionEnabled = self.completionButton.userInteractionEnabled;
    BOOL currentUserInteractionEnabled = (self.progress == 1);
    
    self.completionButton.userInteractionEnabled = currentUserInteractionEnabled;
    
    if ( !lastUserInteractionEnabled && currentUserInteractionEnabled )
    {
        [self completionButtonDidActive];
    }
    else if ( lastUserInteractionEnabled && !currentUserInteractionEnabled )
    {
        [self completionButtonDidNonActive];
    }
    
    self.progressViewWidthConstraint.constant = self.bounds.size.width * self.progress;
    
    if ( animation )
    {
        NSTimeInterval duration = self.animationUpdateProgressDuration ?: self.p_animationUpdateProgressDuration;
        
        [UIView animateWithDuration:duration delay:0.f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self layoutIfNeeded];
        } completion:NULL];
    }
}

- (void)enable
{
    self.userInteractionEnabled = YES;
    self.alpha = 1.f;
}

- (void)disable
{
    self.userInteractionEnabled = NO;
    self.alpha = 0.9f;
}

- (void)completionButtonAction
{
    if ( [self.delegate respondsToSelector:@selector(completionButtonAction)] )
    {
        [self.delegate completionButtonAction];
    }
    
    if ( self.completionBlock )
    {
        self.completionBlock();
    }
}

- (void)completionButtonDidNonActive
{
    if ( [self.delegate respondsToSelector:@selector(completionButtonDidNonActive)] )
    {
        [self.delegate completionButtonDidNonActive];
    }
    
    if ( self.completionButtonDidNonActiveBlock )
    {
        self.completionButtonDidNonActiveBlock();
    }
}

- (void)completionButtonDidActive
{
    if ( [self.delegate respondsToSelector:@selector(completionButtonDidActive)] )
    {
        [self.delegate completionButtonDidActive];
    }
    
    if ( self.completionButtonDidActiveBlock )
    {
        self.completionButtonDidActiveBlock();
    }
}

#pragma mark - IBInspectable
- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    
    [self updateSubviews];
}

- (void)setBgViewColor:(UIColor *)bgViewColor
{
    _bgViewColor = bgViewColor;
    
    [self updateSubviews];
}

- (void)setProgressViewColor:(UIColor *)progressViewColor
{
    _progressViewColor = progressViewColor;
    
    [self updateSubviews];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    [self updateSubviews];
}

- (void)setTextFontSize:(CGFloat)textFontSize
{
    _textFontSize = textFontSize;
    
    [self updateSubviews];
}

- (void)setTextFontName:(NSString *)textFontName
{
    _textFontName = textFontName;
    
    [self updateSubviews];
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    
    [self updateSubviews];
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    [self updateSubviews];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress > 1.f ? 1.f : progress;
    
    [self updateProgress:_progress withAnimation:NO];
}

@end
