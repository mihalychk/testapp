//
//  CRUDMultiTableViewController.m
//  calories
//
//  Created by Michael on 10/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "CRUDMultiTableViewController.h"
#import "Common.h"
#import "TableSection.h"
#import "BaseService.h"




@interface CRUDMultiTableViewController ()

@end




@implementation CRUDMultiTableViewController


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.sections[section].items.count;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return self.sections[section].title;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 32.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.01f;
}


#pragma mark - Override

- (nullable BaseModel *)itemAtIndexPath:(nullable NSIndexPath *)indexPath {
	return self.sections[indexPath.section].items[indexPath.row];
}


- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
	if (!indexPath || indexPath.section >= self.sections.count || indexPath.row >= self.sections[indexPath.section].items.count)
		return;
	
	[self.sections[indexPath.section].items removeObjectAtIndex:indexPath.row];
	[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - UIViewController Stuff

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.tableView reloadData];
}


@end