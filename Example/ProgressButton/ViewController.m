//
//  ViewController.m
//  ProgressButton
//
//  Created by Beniamin Sarkisyan on 28.06.15.
//  Copyright (c) 2015 Cleverpumpkin, Ltd. All rights reserved.
//

#import "ViewController.h"

#import "BSProgressButtonView.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet BSProgressButtonView *progressButtonView;

@property (nonatomic, weak) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *lastNameTextField;

- (IBAction)textFieldValueChanged;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.progressButtonView setCompletionBlock:^{
        self.firstNameTextField.text = nil;
        self.lastNameTextField.text = nil;
        
        [self textFieldValueChanged];
    }];
    
    [self.progressButtonView setCompletionButtonDidNonActiveBlock:^{
        _progressButtonView.text = @"Non active state";
    }];
    
    [self.progressButtonView setCompletionButtonDidActiveBlock:^{
        _progressButtonView.text = @"Active state";
    }];
}

- (IBAction)textFieldValueChanged
{
    CGFloat progress = 0.f;
    
    if ( self.firstNameTextField.text.length >= 3 )
    {
        progress += 0.5f;
    }
    
    if ( self.lastNameTextField.text.length >= 4 )
    {
        progress += 0.5f;
    }
    
    [self.progressButtonView updateProgress:progress];
}

@end
