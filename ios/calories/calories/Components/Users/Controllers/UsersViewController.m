//
//  UsersViewController.m
//  calories
//
//  Created by Michael on 07/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "UsersViewController.h"
#import "Common.h"
#import "BaseService.h"
#import "UserModel.h"
#import "GroupModel.h"
#import "Settings.h"
#import "UsersTableViewCell.h"
#import "UserViewController.h"
#import "UserCreateUpdateViewController.h"




@interface UsersViewController () <FormViewControllerDelegate> {

}

@end




@implementation UsersViewController


#pragma mark - init & dealloc

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.itemClass			= [UserModel class];
		self.title				= NSLocalizedString(@"Users", nil);
		self.tabBarItem			= [[UITabBarItem alloc] initWithTitle:self.title image:IMAGE(@"tabBarUsers") tag:2];
	}
	
	return self;
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UsersTableViewCell * cell	= [tableView dequeueReusableCellWithIdentifier:UsersTableViewCell.cellIdentifier forIndexPath:indexPath];

	UserModel * user			= (UserModel *)self.items[indexPath.row];
	cell.nameLabel.text			= user.name;
	cell.groupNameLabel.text	= user.group.canIRead ? user.group.name : nil;
	cell.accessoryType			= UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}


#pragma mark - FormViewControllerDelegate

- (void)formController:(nonnull FormViewController *)formController didUpdateItem:(nonnull BaseModel *)item {
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)formController:(nonnull FormViewController *)formController didCreateItem:(nonnull BaseModel *)item {
	[self updateData:^{
		[self.navigationController popViewControllerAnimated:YES];
	}];
}


#pragma mark - Override

- (void)onRefreshControl:(nullable UIRefreshControl *)sender {
	[self updateData:^{
		[sender endRefreshing];
	}];
}


- (void)onAddBarButtonItem:(nullable UIBarButtonItem *)sender {
	[self.navigationController pushViewController:[[UserCreateUpdateViewController alloc] initWithItem:nil andDelegate:self] animated:YES];
}


- (void)onReadItem:(nullable BaseModel *)item {
	[self.navigationController pushViewController:[[UserViewController alloc] initWithItem:[SETTINGS.currentUser isEqual:item] ? SETTINGS.currentUser : item] animated:YES];
}


- (void)onUpdateItem:(nullable BaseModel *)item {
	[self.navigationController pushViewController:[[UserCreateUpdateViewController alloc] initWithItem:[SETTINGS.currentUser isEqual:item] ? SETTINGS.currentUser : item andDelegate:self] animated:YES];
}


#pragma mark - Data

- (void)updateData:(void(^__nullable)(void))callback {
	[BaseService index:[UserModel class] callback:^(NSArray<BaseModel *> * _Nullable array, NSError * _Nullable error) {
		if ([self checkForErrors:error]) {
			[self loader:NO animated:YES];

			self.items				= array;

			[self.tableView reloadData];
		}

		if (callback)
			callback();
	}];
}


#pragma mark - UIViewController Stuff

- (void)viewDidLoad {
	[super viewDidLoad];

	[UsersTableViewCell registerForTableView:self.tableView];

	[self updateData:nil];
}


@end