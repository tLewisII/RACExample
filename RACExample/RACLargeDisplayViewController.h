//
//  RACLargeDisplayViewController.h
//  RACExample
//
//  Created by Terry Lewis II on 1/20/14.
//  Copyright (c) 2014 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RACLargeDisplayViewController : UIViewController
@property(strong, nonatomic) NSArray *photoArray;
@property(nonatomic) NSUInteger index;

@property(strong, nonatomic, readonly) RACSignal *photoIndexSignal;
@end
