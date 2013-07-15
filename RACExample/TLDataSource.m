//
//  JSDataSource.m
//
//
//  Created by Terry Lewis II on 6/14/13.
//  
//

#import "TLDataSource.h"

@interface TLDataSource ()
@property(nonatomic, strong) NSArray *items;
@property(nonatomic, copy) NSString *cellIdentifier;
@property(nonatomic, copy) CellConfigureBlock configureCellBlock;
@end

@implementation TLDataSource

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
    return self.items[(NSUInteger)indexPath.row];
}
#pragma mark - UITableView datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemForIndexPath:indexPath];
    self.configureCellBlock(cell, item, indexPath);

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}
@end
