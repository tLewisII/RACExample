//
//  RACSinglePhotoViewController.h
//  RACExample
//
//  Created by Terry Lewis II on 1/20/14.
//  Copyright (c) 2014 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RACSinglePhotoViewController : UIViewController
- (instancetype)initWithImage:(UIImage *)image index:(NSUInteger)index;

@property(nonatomic, readonly) NSInteger photoIndex;
@end
