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

#pragma mark - UITableView datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = self.items[(NSUInteger)indexPath.row];
    self.configureCellBlock(cell, item, indexPath);

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

#pragma mark - UICollectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = self.items[(NSUInteger)indexPath.row];
    self.configureCellBlock(cell, item, indexPath);
    
    return cell;
}

#pragma mark - object at indexed subscript
- (id)objectAtIndexedSubscript:(NSUInteger)index {
    return self.items[index];
}
@end
