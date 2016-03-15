//
//  BaseCRUDTableViewController.m
//  calories
//
//  Created by Michael on 10/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseCRUDTableViewController.h"
#import "Predefined.h"
#import "BaseModel.h"
#import "BaseService.h"




@interface BaseCRUDTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end




@implementation BaseCRUDTableViewController


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	BaseModel * item				= [self itemAtIndexPath:indexPath];
	
	return item.canIUpdate || item.canIDelete;
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
	BaseModel * item				= [self itemAtIndexPath:indexPath];
	NSMutableArray * actions		= [NSMutableArray array];
	
	if (item.canIDelete)
		[actions addObject:[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"Delete", nil) handler:^(UITableViewRowAction * action, NSIndexPath * indexPath) {
			[self onDeleteItemAtIndexPath:indexPath];
		}]];
	
	if (item.canIUpdate)
		[actions addObject:[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"Edit", nil) handler:^(UITableViewRowAction * action, NSIndexPath * indexPath) {
			[self onUpdateItem:item];
		}]];
	
	return actions;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self onReadItem:[self itemAtIndexPath:indexPath]];
}


#pragma mark - Actions

- (void)onRefreshControl:(UIRefreshControl *)sender {
	LOG(@"ON UPDATE LIST");
}


- (void)onAddBarButtonItem:(nullable UIBarButtonItem *)sender {
	LOG(@"ON CREATE");
}


#pragma mark -

- (nullable BaseModel *)itemAtIndexPath:(nullable NSIndexPath *)indexPath {
	return nil;
}


- (void)onReadItem:(nullable BaseModel *)item {
	LOG(@"ON READ: %@", item);
}


- (void)onUpdateItem:(nullable BaseModel *)item {
	LOG(@"ON UPDATE: %@", item);
}


- (void)onDeleteItemAtIndexPath:(nullable NSIndexPath *)indexPath {
	if (!indexPath)
		return;
	
	[self presentConfirmationWithMessage:NSLocalizedString(@"Are you sure?", nil) buttonTitle:NSLocalizedString(@"Yes", nil) cancelHandler:^(UIAlertAction * _Nonnull action) {
		[self.tableView setEditing:NO animated:YES];
	} yesHandler:^(UIAlertAction * _Nonnull action) {
		BaseModel * model		= [self itemAtIndexPath:indexPath];
		
		if (model) {
			[BaseService delete:model callback:^(NSError * _Nullable error) {
				if ([self checkForErrors:error])
					[self removeItemAtIndexPath:indexPath];
			}];
		}
		else
			[self.tableView setEditing:NO animated:YES];
	} animated:YES];
}


- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark -

- (void)reloadSection:(NSUInteger)section {
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - UIViewController Stuff

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.tableView.rowHeight		= PREDEFINED_TABLE_CELL_HEIGHT;
	self.tableView.tableFooterView	= [[UIView alloc] initWithFrame:CGRectZero];
	
	if ([self.itemClass canICreate])
		self.navigationItem.rightBarButtonItem	= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddBarButtonItem:)];
	
	[self.tableView addSubview:[self refreshControlWithAction:@selector(onRefreshControl:)]];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[self.tableView setEditing:NO animated:YES];
}



@end