//
//  RACAlbumDisplayViewController.h
//  RACExample
//
//  Created by Terry Lewis II on 1/18/14.
//  Copyright (c) 2014 Terry Lewis. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALAssetsGroup;
@interface RACAlbumDisplayViewController : UIViewController
- (instancetype)initWithGroup:(ALAssetsGroup *)group photos:(NSArray *)photos;
@end
