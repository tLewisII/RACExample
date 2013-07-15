//
//  RACTextFieldViewController.m
//  RACExample
//
//  Created by Terry Lewis II on 7/14/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//
#define GreenStar [UIImage imageNamed:@"GreenStar"]
#define RedStar [UIImage imageNamed:@"RedStar"]
#import "RACTextFieldViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface RACTextFieldViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UIImageView *nameIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *emailIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIndicator;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;


@end

@implementation RACTextFieldViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameField.delegate = self;
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    ///We want to constantly monitor the correctness of the text fields so that we can update the indicators in real time. These are arbitrary values used for correctness, you could use whatever you desired.
    RACSignal *nameSignal = [self.nameField.rac_textSignal map:^id(NSString *value) {
        return @(value.length > 4);
    }];
    RACSignal *emailSignal = [self.emailField.rac_textSignal map:^id(NSString *value) {
        return @(value.length > 4 && [value rangeOfString:@"@"].location != NSNotFound);
    }];
    RACSignal *passwordSignal = [self.passwordField.rac_textSignal map:^id(NSString *value) {
        return @(value.length > 6 && ![value isEqualToString:@"password"]);
    }];
    ///We want to indicate to the user exactly when each field goes from incorrect to correct, or vice-versa;
    RAC(self.nameIndicator.image) = [nameSignal map:^id(NSNumber *value) {
        if(value.boolValue)
            return GreenStar;
        else
            return RedStar;
    }];
    RAC(self.emailIndicator.image) = [emailSignal map:^id(NSNumber *value) {
        if(value.boolValue)
            return GreenStar;
        else
            return RedStar;
    }];
    RAC(self.passwordIndicator.image) = [passwordSignal map:^id(NSNumber *value) {
        if(value.boolValue)
            return GreenStar;
        else
            return RedStar;
    }];
    ///Only enable the create account button when each field is filled out correctly.
    RAC(self.createAccountButton.enabled) = [RACSignal combineLatest:@[nameSignal,emailSignal,passwordSignal] reduce:^(NSNumber *name, NSNumber *email, NSNumber *password)  {
        return @((name.boolValue && email.boolValue && password.boolValue));
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
