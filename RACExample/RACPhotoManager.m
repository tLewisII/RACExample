//
//  RACPhotoManager.m
//  RACExample
//
//  Created by Terry Lewis II on 1/18/14.
//  Copyright (c) 2014 Terry Lewis. All rights reserved.
//

#import "RACPhotoManager.h"

@implementation RACPhotoManager

- (id)init {
    self = [super init];
    if(!self) {
        return nil;
    }
    
    self.library = [ALAssetsLibrary new];
    
    return self;
}

- (RACSignal *)photoAlbums {
    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if(group) {
                [subscriber sendNext:group];
            }
            else [subscriber sendCompleted];
        }                         failureBlock:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }]collect];
}

- (RACSignal *)photosFromGroup:(ALAssetsGroup *)group {
    return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        ALAssetsFilter *filter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:filter];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result) {
                [subscriber sendNext:result];
            }
            else [subscriber sendCompleted];
        }];
        return nil;
    }]deliverOn:[RACScheduler mainThreadScheduler]];
}
@end
