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
#import <EXTScope.h>

@interface RACTextFieldViewController () <UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UITextField *nameField;
@property(weak, nonatomic) IBOutlet UITextField *emailField;
@property(weak, nonatomic) IBOutlet UITextField *passwordField;
@property(weak, nonatomic) IBOutlet UIImageView *nameIndicator;
@property(weak, nonatomic) IBOutlet UIImageView *emailIndicator;
@property(weak, nonatomic) IBOutlet UIImageView *passwordIndicator;
@property(weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property(strong,nonatomic)UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation RACTextFieldViewController

- (void)viewDidLoad {
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
    RACSignal *correctnessSignal = [RACSignal combineLatest:@[nameSignal, emailSignal, passwordSignal] reduce:^(NSNumber *name, NSNumber *email, NSNumber *password) {
        return @((name.boolValue && email.boolValue && password.boolValue));
    }];
    ///A RACCommand is used for buttons in place of adding target actions. In this case, we only want the command to be able to execute if the correctnessSignal returns true.
    RACCommand *command = [RACCommand commandWithCanExecuteSignal:correctnessSignal];
    ///Here we return a signal block that execute a network request on a background thread. If the success parameter is set = NO, then the error will be sent.
    RACSignal *comnandSignal = [command addSignalBlock:^RACSignal *(id value) {
        return [RACSignal start:^id(BOOL *success, NSError *__autoreleasing *error) {
           NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8109/8631724728_48c13f7733_b.jpg"]];
            *success = (data != nil);
            return [UIImage imageWithData:data];
        }];
    }];
    ///Here we catch the error and suppress it, otherwise the signal would complete and the textViews text would never be able to receive a value.
    RACSignal *commandSignalMapped = [comnandSignal map:^id(RACSignal *request) {
        return [request catch:^RACSignal *(NSError *error) {
            ///handle the error;
            NSLog(@"The error is %@", error);
            return [RACSignal empty];
        }];
    }];
    ///We set the command to be executed whenever the button is pressed.
    RACSignal *buttonSignal = [self.createAccountButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    [buttonSignal executeCommand:command];
    @weakify(self);
    ///Hide the keyboard whenever the button is pressed. This would be considered a side effect.
    [buttonSignal subscribeNext:^(id x) {
        @strongify(self)
        [self.nameField resignFirstResponder];
        [self.emailField resignFirstResponder];
        [self.passwordField resignFirstResponder];
    }];
    ///We don't want the button to be pressed while the command is executing, so we set its enabledness based on the command's canExecute property. Note that we deliver it on the main thread, since we are binding to a UIKit property.
    RAC(self.createAccountButton.enabled) = [RACAbleWithStart(command, canExecute) deliverOn:[RACScheduler mainThreadScheduler]];
    ///Here we bind the imageView's image property to the signal sent from the command. We flatten it because the commandSignalMapped is a signal of signals, and flattening is the same as merging, so we get one signal that represents the value of all of the signals. Note again the delivery on the main thread.
    RAC(self.imageView.image) = [[commandSignalMapped flatten]deliverOn:[RACScheduler mainThreadScheduler]];
    ///The activityIndicator will be spin while the command is being executed.
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]init];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:self.activityIndicatorView];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 20; //make the activity spinner offset from the edge of the nav bar
    self.activityIndicatorView.color = [UIColor blackColor];
    self.navigationItem.rightBarButtonItems = @[space, item];
    ///Since we cannot set the activityIndicators animating property directly, we have to invoke its methods as side effects.
    RACSignal *commandSignal = [RACAble(command, executing) deliverOn:[RACScheduler mainThreadScheduler]];
    [commandSignal subscribeNext:^(NSNumber *x) {
        @strongify(self)
        if(x.boolValue)
            [self.activityIndicatorView startAnimating];
        else
            [self.activityIndicatorView stopAnimating];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
