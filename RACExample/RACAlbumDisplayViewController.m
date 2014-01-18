//
//  RACAlbumDisplayViewController.m
//  RACExample
//
//  Created by Terry Lewis II on 1/18/14.
//  Copyright (c) 2014 Terry Lewis. All rights reserved.
//

#import "RACAlbumDisplayViewController.h"
#import "TLDataSource.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface RACAlbumDisplayViewController ()
@property (strong, nonatomic) ALAssetsGroup *group;
@property(strong, nonatomic) NSArray *photos;
@property(strong, nonatomic) TLDataSource *datasource;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
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
	self.datasource = [[TLDataSource alloc]initWithItems:self.photos cellIdentifier:@"CELL" configureCellBlock:^(UICollectionViewCell *cell, ALAsset *item, id indexPath) {
        cell.backgroundView = [[UIImageView alloc]initWithImage:[[UIImage alloc]initWithCGImage:item.thumbnail]];
    }];
    self.collectionView.dataSource = self.datasource;
}


@end
