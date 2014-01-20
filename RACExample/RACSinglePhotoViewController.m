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
    if (!self) {
        return nil;
    }
    
    _photoIndex = index;
    _photo = image;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
