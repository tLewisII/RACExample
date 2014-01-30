//
//  RACSinglePhotoViewController.m
//  RACExample
//
//  Created by Terry Lewis II on 1/20/14.
//  Copyright (c) 2014 Terry Lewis. All rights reserved.
//

#import "RACSinglePhotoViewController.h"

@interface RACSinglePhotoViewController ()
@property(strong, nonatomic) UIImage *photo;
@end

@implementation RACSinglePhotoViewController

- (instancetype)initWithImage:(UIImage *)image index:(NSUInteger)index {
    self = [super init];
    if(!self) {
        return nil;
    }

    _photoIndex = index;
    _photo = image;

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *photoView = [[UIImageView alloc]initWithImage:self.photo];
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    photoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;

    CGFloat width = MIN(CGRectGetWidth(self.view.frame), self.photo.size.width);
    CGFloat height = MIN(CGRectGetHeight(self.view.frame), self.photo.size.height);
    [self.view addSubview:photoView];

    [self.view addConstraints:@[
            [NSLayoutConstraint
                    constraintWithItem:photoView
                             attribute:NSLayoutAttributeCenterX
                             relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                             attribute:NSLayoutAttributeCenterX
                            multiplier:1.0
                              constant:0],
            [NSLayoutConstraint
                    constraintWithItem:photoView
                             attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                             attribute:NSLayoutAttributeCenterY
                            multiplier:1.0
                              constant:0],
            [NSLayoutConstraint
                    constraintWithItem:photoView
                             attribute:NSLayoutAttributeWidth
                             relatedBy:NSLayoutRelationEqual
                                toItem:nil
                             attribute:NSLayoutAttributeNotAnAttribute
                            multiplier:1.0
                              constant:width],
            [NSLayoutConstraint
                    constraintWithItem:photoView
                             attribute:NSLayoutAttributeHeight
                             relatedBy:NSLayoutRelationEqual
                                toItem:nil
                             attribute:NSLayoutAttributeNotAnAttribute
                            multiplier:1.0
                              constant:height]
    ]];
}

@end
