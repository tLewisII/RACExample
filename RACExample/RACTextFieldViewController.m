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
    RAC(self.nameIndicator,image) = [nameSignal map:^id(NSNumber *value) {
        if(value.boolValue) return GreenStar;
        else return RedStar;
    }];
    RAC(self.emailIndicator,image) = [emailSignal map:^id(NSNumber *value) {
        if(value.boolValue) return GreenStar;
        else return RedStar;
    }];
    RAC(self.passwordIndicator,image) = [passwordSignal map:^id(NSNumber *value) {
        if(value.boolValue) return GreenStar;
        else return RedStar;
    }];
    ///Only enable the create account button when each field is filled out correctly.
    RACSignal *correctnessSignal = [RACSignal combineLatest:@[nameSignal, emailSignal, passwordSignal] reduce:^(NSNumber *name, NSNumber *email, NSNumber *password) {
        return @((name.boolValue && email.boolValue && password.boolValue));
    }];
    ///A RACCommand is used for buttons in place of adding target actions. In this case, we only want the command to be able to execute if the correctnessSignal returns true.
    ///Here we return a signal block that executes a network request on a background thread. We send an error if there is an error, or the image and `complete` if it is successful.
    RACCommand *command = [[RACCommand alloc]initWithEnabled:correctnessSignal signalBlock:^RACSignal *(id input) {
        return [RACSignal startLazilyWithScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground] block:^(id<RACSubscriber> subscriber) {
            NSError *error;
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://farm9.staticflickr.com/8109/8631724728_48c13f7733_b.jpg"] options:NSDataReadingMappedAlways error:&error];
            if(error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:[UIImage imageWithData:data]];
                [subscriber sendCompleted];
            }
        }];
    }];

    ///Here we handle any errors that the command sends.
    [command.errors subscribeNext:^(NSError *x) {
        NSLog(@"%@",x);
    }];
    ///We set the command to be executed whenever the button is pressed.
    self.createAccountButton.rac_command = command;
    
    @weakify(self);
    ///Hide the keyboard whenever the button is pressed. This would be considered a side effect.
    [[self.createAccountButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.nameField resignFirstResponder];
        [self.emailField resignFirstResponder];
        [self.passwordField resignFirstResponder];
    }];
    
    ///Here we bind the imageView's image property to the signal sent from the command. We flatten it because `executionSignals` is a signal of signals, and flattening is the same as merging, so we get one signal that represents the value of all of the signals. Note the delivery on the main thread.
    RAC(self.imageView,image) = [[[command executionSignals]flatten]deliverOn:[RACScheduler mainThreadScheduler]];
    ///The activityIndicator will be spin while the command is being executed.
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]init];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:self.activityIndicatorView];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 20; //make the activity spinner offset from the edge of the nav bar
    self.activityIndicatorView.color = [UIColor blackColor];
    self.navigationItem.rightBarButtonItems = @[space, item];
    ///Since we cannot set the activityIndicators animating property directly, we have to invoke its methods as side effects.
    RACSignal *commandSignal = command.executing;
    [commandSignal subscribeNext:^(NSNumber *x) {
        @strongify(self)
        if(x.boolValue) [self.activityIndicatorView startAnimating];
        else [self.activityIndicatorView stopAnimating];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
