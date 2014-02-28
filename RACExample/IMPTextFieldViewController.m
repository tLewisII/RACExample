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

    [self.nameField addTarget:self action:@selector(nameValidity:) forControlEvents:UIControlEventEditingDidBegin | UIControlEventEditingChanged];
    [self.emailField addTarget:self action:@selector(emailValidity:) forControlEvents:UIControlEventEditingDidBegin | UIControlEventEditingChanged];
    [self.passwordField addTarget:self action:@selector(passwordValidity:) forControlEvents:UIControlEventEditingDidBegin | UIControlEventEditingChanged];

    self.nameIndicator.image = RedStar;
    self.emailIndicator.image = RedStar;
    self.passwordIndicator.image = RedStar;

    self.createAccountButton.enabled = NO;
    [self.createAccountButton addTarget:self action:@selector(getChinchilla:) forControlEvents:UIControlEventTouchUpInside];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 20;
    self.activityIndicatorView.color = [UIColor blackColor];
    self.navigationItem.rightBarButtonItems = @[space, item];
}

- (void)passwordValidity:(UITextField *)textField {
    self.passwordIndicator.image = (textField.text.length > 6 && ![textField.text isEqualToString:@"password"]) ? GreenStar : RedStar;
}

- (void)emailValidity:(UITextField *)textField {
    self.emailIndicator.image = (textField.text.length > 4 && [textField.text rangeOfString:@"@"].location != NSNotFound) ? GreenStar : RedStar;
}

- (void)nameValidity:(UITextField *)textField {
    self.nameIndicator.image = textField.text.length > 4 ? GreenStar : RedStar;
}

- (void)getChinchilla:(UIButton *)getChinchilla {
    [self.nameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.activityIndicatorView startAnimating];
    __block NSError *error;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8109/8631724728_48c13f7733_b.jpg"]
                                             options:0
                                               error:&error];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if(error) NSLog(@"%@", error);
            else self.imageView.image = [UIImage imageWithData:data];
            [self.activityIndicatorView stopAnimating];

        });
    });
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.createAccountButton.enabled = (self.passwordField.text.length > 6 && ![self.passwordField.text isEqualToString:@"password"] && self.nameField.text.length > 4 && self.emailField.text.length > 4 && [self.emailField.text rangeOfString:@"@"].location != NSNotFound);

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
