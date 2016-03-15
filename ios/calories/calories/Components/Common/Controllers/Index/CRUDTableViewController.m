//
//  CRUDTableViewController.m
//  calories
//
//  Created by Michael on 08/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "CRUDTableViewController.h"
#import "Common.h"
#import "BaseModel.h"
#import "BaseService.h"




@interface CRUDTableViewController () {

}

@end




@implementation CRUDTableViewController


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.items.count;
}


#pragma mark - Override

- (nullable BaseModel *)itemAtIndexPath:(nullable NSIndexPath *)indexPath {
	return self.items[indexPath.row];
}


- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
	if (!indexPath || indexPath.row >= self.items.count)
		return;

	NSMutableArray * items		= [NSMutableArray arrayWithArray:self.items];
	
	[items removeObjectAtIndex:indexPath.row];
	
	self.items					= items;
	
	[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - UIViewController Stuff

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self reloadSection:0];
}


@end