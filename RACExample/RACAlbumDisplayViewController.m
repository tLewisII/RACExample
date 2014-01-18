//
//  RACAlbumDisplayViewController.m
//  RACExample
//
//  Created by Terry Lewis II on 1/18/14.
//  Copyright (c) 2014 Terry Lewis. All rights reserved.
//

#import "RACAlbumDisplayViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface RACAlbumDisplayViewController ()
@property (strong, nonatomic) ALAssetsGroup *group;
@property(strong, nonatomic) NSArray *photos;
@end

@implementation RACAlbumDisplayViewController

- (instancetype)initWithGroup:(ALAssetsGroup *)group photos:(NSArray *)photos {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _group = group;
    _photos = photos;
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


@end
