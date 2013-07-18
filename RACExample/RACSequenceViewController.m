//
//  RACSequenceViewController.m
//  RACExample
//
//  Created by Terry Lewis II on 7/17/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "RACSequenceViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <EXTScope.h>
@interface RACSequenceViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *stringLabel;
@property (weak, nonatomic) IBOutlet UILabel *anyLabel;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;

@end

@implementation RACSequenceViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.stringLabel.text = @"";
    @weakify(self)
    ///Here we can easily change the case of a string, as each `next` event will be each value from the sequence in order. So we simply map and return the switched case string.
    RAC(self.stringLabel.text) = [[@"StRiNgS".rac_sequence.signal map:^id(NSString *value) {
        @strongify(self)
        if([value isEqualToString:value.uppercaseString])
            return [self.stringLabel.text stringByAppendingString:value.lowercaseString];
        else
            return [self.stringLabel.text stringByAppendingString:value.uppercaseString];
    }]deliverOn:[RACScheduler scheduler]];
    ///Returns a Boolean indicating if any value in the sequence passes the test.
    BOOL anyTest = [@[@1,@2,@3].rac_sequence any:^BOOL(NSNumber *value) {
        return (value.integerValue % 2 == 0);
    }];
    ///Returns a Boolean indicating if all values in the sequence pass the test
    BOOL allTest = [@[@1,@2,@3].rac_sequence all:^BOOL(NSNumber *value) {
        return (value.integerValue > 4);
    }];
    ///Simply display the results of the above tests.
    RAC(self.anyLabel.text) = [[RACSignal return:@(anyTest)] map:^id(NSNumber *value) {
        return (value.boolValue == YES ? @"YES" : @"NO");
    }];
    RAC(self.allLabel.text) = [[RACSignal return:@(allTest)] map:^id(NSNumber *value) {
        return (value.boolValue == YES ? @"YES" : @"NO");
    }];
}

@end
