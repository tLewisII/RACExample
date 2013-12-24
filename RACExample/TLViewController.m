//
//  TLViewController.m
//  RACExample
//
//  Created by Terry Lewis II on 7/14/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "TLViewController.h"
#import "TLDataSource.h"

@interface TLViewController () <UITableViewDelegate>
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) TLDataSource *datasource;
@property(strong, nonatomic) RACSubject *delegateSubject;
@property(strong, nonatomic) NSArray *sections;
@end

@implementation TLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.sections = @[ @"Gestures", @"Text Fields", @"Slideshow", @"Sequence" ];
    CellConfigureBlock block = ^(UITableViewCell *cell, NSString *item, id indexPath) {
        cell.textLabel.text = item;
    };
    self.datasource = [[TLDataSource alloc]initWithItems:self.sections cellIdentifier:@"Cell" configureCellBlock:block];
    self.tableView.dataSource = self.datasource;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    ///ReactiveCocoa
    self.delegateSubject = [RACSubject subject]; ///RACSubjects are useful for bridging the gap between the normal world of Objective-C and ReactiveCocoa.
    ///We lift the selector into the RAC world, and it will be invoked every time the delegate subject sends a new value.
    [self rac_liftSelector:@selector(performSegueWithIdentifier:sender:) withSignals:self.delegateSubject,[RACSignal return:nil], nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *item = self.sections[(NSUInteger)indexPath.row];
    ///We want the item from the array to perform the segue with.
    [self.delegateSubject sendNext:item];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *controller = segue.destinationViewController;
    controller.title = segue.identifier;
}
@end
