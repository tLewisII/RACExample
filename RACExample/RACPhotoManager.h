//
//  RACPhotoManager.h
//  RACExample
//
//  Created by Terry Lewis II on 1/18/14.
//  Copyright (c) 2014 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface RACPhotoManager : NSObject
@property(strong, nonatomic) ALAssetsLibrary *library;

- (RACSignal *)photoAlbums;

- (RACSignal *)photosFromGroup:(ALAssetsGroup *)group;
@end
