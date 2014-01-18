//
//  RACPhotosTableViewDatasource.h
//  RACExample
//
//  Created by Terry Lewis II on 1/18/14.
//  Copyright (c) 2014 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RACPhotosTableViewDatasource : NSObject <UITableViewDataSource>
typedef void (^CellConfigureBlock)(id cell, id item, id indexPath);

/**
 * A datasource class that can serve as a UITableView datasource.
 *\param items the array that will serve as the datasource.
 *\param identifier the cell identifier.
 *\param block the configuration block that is used to configure the cell, contains the cell, the item for the indexPath from the array and the indexPath.
 *\returns an instance of the class that will serve as a datasource for a UITableView.
 */
- (instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)identifier configureCellBlock:(CellConfigureBlock)block;

- (instancetype)itemForIndexPath:(NSIndexPath *)indexPath;

- (id)objectAtIndexedSubscript:(NSUInteger)index;

@property(nonatomic, strong) NSArray *items;


@end
