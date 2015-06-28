//
//  BSProgressButtonView.h
//
//  Created by Beniamin Sarkisyan on 08/06/15.
//  Copyright (c) 2015 Cleverpumpkin, Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BSProgressButtonCompletionBlock)();

@protocol BSProgressButtonViewDelegate <NSObject>

@optional
- (void)completionButtonAction;
- (void)completionButtonDidNonActive;
- (void)completionButtonDidActive;

@end

@interface BSProgressButtonView : UIView

@property (nonatomic, weak) id<BSProgressButtonViewDelegate> delegate;

@property (nonatomic, strong) IBInspectable UIColor *bgColor;
@property (nonatomic, strong) IBInspectable UIColor *bgViewColor;
@property (nonatomic, strong) IBInspectable UIColor *progressViewColor;

@property (nonatomic, strong) IBInspectable UIColor *textColor;
@property (nonatomic, assign) IBInspectable CGFloat textFontSize;
@property (nonatomic, copy) IBInspectable NSString *textFontName;
@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, copy) IBInspectable NSString *text;

@property (nonatomic, assign) IBInspectable CGFloat progress;
@property (nonatomic, assign) IBInspectable BOOL animateUpdateProgress;
@property (nonatomic, assign) IBInspectable NSTimeInterval animationUpdateProgressDuration;

@property (nonatomic, copy) BSProgressButtonCompletionBlock completionBlock;
@property (nonatomic, copy) BSProgressButtonCompletionBlock completionButtonDidNonActiveBlock;
@property (nonatomic, copy) BSProgressButtonCompletionBlock completionButtonDidActiveBlock;

+ (instancetype)progressButtonWithFrame:(CGRect)frame completionBlock:(BSProgressButtonCompletionBlock)completion;
- (instancetype)initProgressButtonWithFrame:(CGRect)frame completionBlock:(BSProgressButtonCompletionBlock)completion;

- (void)updateProgress:(CGFloat)progress;
- (void)updateProgress:(CGFloat)progress withAnimation:(BOOL)animation;

- (void)enable;
- (void)disable;

@end
