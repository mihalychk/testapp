//
//  BaseCRUDTableViewController.h
//  calories
//
//  Created by Michael on 10/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseCRUDViewController.h"




@class BaseModel;




@interface BaseCRUDTableViewController : BaseCRUDViewController

@property (weak) IBOutlet UITableView * tableView;

- (nullable BaseModel *)itemAtIndexPath:(nullable NSIndexPath *)indexPath;

- (void)onRefreshControl:(nullable UIRefreshControl *)sender;
- (void)onAddBarButtonItem:(nullable UIBarButtonItem *)sender;			// On Create
- (void)onReadItem:(nullable BaseModel *)item;							// On Read
- (void)onUpdateItem:(nullable BaseModel *)item;						// On Update
- (void)onDeleteItemAtIndexPath:(nullable NSIndexPath *)indexPath;		// On Delete

- (void)removeItemAtIndexPath:(nullable NSIndexPath *)indexPath;		// After Delete

- (void)reloadSection:(NSUInteger)section;

@end