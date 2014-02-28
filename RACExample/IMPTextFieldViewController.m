//
//  IMPTextFieldViewController.m
//  RACExample
//
//  Created by Terry Lewis II on 2/28/14.
//  Copyright (c) 2014 Terry Lewis. All rights reserved.
//

#define GreenStar [UIImage imageNamed:@"GreenStar"]
#define RedStar [UIImage imageNamed:@"RedStar"]

#import "IMPTextFieldViewController.h"

@interface IMPTextFieldViewController () <UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UITextField *nameField;
@property(weak, nonatomic) IBOutlet UITextField *emailField;
@property(weak, nonatomic) IBOutlet UITextField *passwordField;
@property(weak, nonatomic) IBOutlet UIImageView *nameIndicator;
@property(weak, nonatomic) IBOutlet UIImageView *emailIndicator;
@property(weak, nonatomic) IBOutlet UIImageView *passwordIndicator;
@property(weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property(strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation IMPTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameField.delegate = self;
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == self.nameField) {
        
    }
    if(textField == self.emailField) {

    }
    if(textField == self.passwordField) {

    }
    return YES;
}

@end
