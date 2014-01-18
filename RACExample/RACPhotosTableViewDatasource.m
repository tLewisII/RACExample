//
//  RACPhotosTableViewDatasource.m
//  RACExample
//
//  Created by Terry Lewis II on 1/18/14.
//  Copyright (c) 2014 Terry Lewis. All rights reserved.
//

#import "RACPhotosTableViewDatasource.h"
@interface RACPhotosTableViewDatasource()
@property(nonatomic, copy) NSString *cellIdentifier;
@property(nonatomic, copy) CellConfigureBlock configureCellBlock;
@end
@implementation RACPhotosTableViewDatasource

- (instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)identifier configureCellBlock:(CellConfigureBlock)block {
    self = [super init];
    if(self) {
        _items = items;
        _cellIdentifier = identifier;
        _configureCellBlock = [block copy];
    }
    return self;
    
}

- (id)itemForIndexPath:(NSIndexPath *)indexPath {
    if([self.items[0] respondsToSelector:@selector(objectAtIndex:)])
        return self.items[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
    else
        return self.items[(NSUInteger)indexPath.row];
}
#pragma mark - UITableView datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self itemForIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    self.configureCellBlock(cell, item, indexPath);
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([self.items[0] respondsToSelector:@selector(objectAtIndex:)]) return self.items.count;
    else return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.items[0] respondsToSelector:@selector(objectAtIndex:)]) return [self.items[section] count];
    else return self.items.count;
}

- (id)objectAtIndexedSubscript:(NSUInteger)index {
    return self.items[index];
}
@end
