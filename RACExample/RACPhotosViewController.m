//
//  RACPhotosViewController.m
//  RACExample
//
//  Created by Terry Lewis II on 1/18/14.
//  Copyright (c) 2014 Terry Lewis. All rights reserved.
//

#import "RACPhotosViewController.h"
#import "RACPhotoManager.h"
#import "TLDataSource.h"
#import "RACAlbumDisplayViewController.h"

@interface RACPhotosViewController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TLDataSource *datasource;
@property (strong, nonatomic) RACPhotoManager *photoManager;
@end

@implementation RACPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoManager = [RACPhotoManager new];
    __strong typeof (UITableView *) strongTableView = self.tableView;
    strongTableView.delegate = self;
    RAC(self, datasource) = [[[[self.photoManager photoAlbums]map:^id(NSArray *value) {
        CellConfigureBlock block = ^(UITableViewCell *cell, ALAssetsGroup *result, id indexPath) {
            cell.textLabel.text = [result valueForProperty:ALAssetsGroupPropertyName];
            cell.imageView.image = [UIImage imageWithCGImage:result.posterImage];
        };
        
        TLDataSource *dataSource = [[TLDataSource alloc]initWithItems:value cellIdentifier:@"CELL" configureCellBlock:block];
        return dataSource;
    }]catchTo:[RACSignal empty]]doCompleted:^{
        [strongTableView reloadData];
    }];
    
    RAC(self.tableView, dataSource, nil) = RACObserve(self, datasource);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ALAssetsGroup *group = self.datasource[(NSUInteger)indexPath.row];
    RACSignal *photosSignal = [self.photoManager photosFromGroup:group];
    RACSignal *groupSignal = [RACSignal return:group];
    RACSignal *photosAndGroup = [RACSignal merge:@[photosSignal, groupSignal]];
   RACSignal *segueSignal = [[photosAndGroup collect] map:^id(NSArray *value) {
       return [RACTuple tupleWithObjects:value.firstObject, value.lastObject, nil];
    }];
    [self rac_liftSelector:@selector(performSegueWithIdentifier:sender:) withSignals:[RACSignal return:@"Album Photos"], segueSignal, nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(RACTuple *)sender {
    RACTupleUnpack(ALAssetsGroup *group, NSArray *photos) = sender;
     
    RACAlbumDisplayViewController *albumVC = (RACAlbumDisplayViewController *)segue.destinationViewController;
    albumVC.group = group;
    albumVC.photos = photos;
}
@end
