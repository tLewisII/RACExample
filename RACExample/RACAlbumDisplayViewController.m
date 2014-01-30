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
#import "RACLargeDisplayViewController.h"

@interface RACAlbumDisplayViewController () <UICollectionViewDelegateFlowLayout>
@property(strong, nonatomic) TLDataSource *datasource;
@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(strong, nonatomic) RACSignal *photoScrollSignal;
@end

@implementation RACAlbumDisplayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.datasource = [[TLDataSource alloc]initWithItems:self.photos cellIdentifier:@"CELL" configureCellBlock:^(UICollectionViewCell *cell, ALAsset *item, id indexPath) {
        cell.backgroundView = [[UIImageView alloc]initWithImage:[[UIImage alloc]initWithCGImage:item.thumbnail]];
    }];
    self.collectionView.dataSource = self.datasource;
    self.collectionView.delegate = self;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RACLargeDisplayViewController *largeVC = [RACLargeDisplayViewController new];
    largeVC.photoArray = self.datasource.items;
    largeVC.index = indexPath.row;

    self.photoScrollSignal = largeVC.photoIndexSignal;
    [self.collectionView rac_liftSelector:@selector(scrollToItemAtIndexPath:atScrollPosition:animated:) withSignals:self.photoScrollSignal, [RACSignal return:@(UICollectionViewScrollPositionCenteredVertically)], [RACSignal return:@NO], nil];

    [self.navigationController pushViewController:largeVC animated:YES];
}

@end
