//
//  SettingsViewController.m
//  calories
//
//  Created by Michael on 07/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "SettingsViewController.h"
#import "Predefined.h"
#import "SettingsTableViewCell.h"
#import "Auth.h"
#import "UserCreateUpdateViewController.h"
#import "Settings.h"




@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate, FormViewControllerDelegate>

@property (nonatomic, strong) NSArray * items;

@property (weak) IBOutlet UITableView * tableView;

@end




@implementation SettingsViewController


#pragma mark - init & dealloc

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.title				= NSLocalizedString(@"Settings", nil);
		self.tabBarItem			= [[UITabBarItem alloc] initWithTitle:self.title image:IMAGE(@"tabBarSettings") tag:2];

		self.items				= @[
									@{
										@"title"  : NSLocalizedString(@"Edit Profile", nil),
										@"action" : [NSValue valueWithPointer:@selector(onEditProfile:)]
										},
									@{
										@"title"  : NSLocalizedString(@"Logout", nil),
										@"action" : [NSValue valueWithPointer:@selector(onLogout:)],
										@"color"  : [UIColor redColor]
										}
									];
	}
	
	return self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	SettingsTableViewCell * cell	= [tableView dequeueReusableCellWithIdentifier:[SettingsTableViewCell cellIdentifier] forIndexPath:indexPath];

	NSDictionary * menuItem			= self.items[indexPath.row];

	cell.titleLabel.text			= menuItem[@"title"];
	cell.titleLabel.textColor		= menuItem[@"color"] ? menuItem[@"color"] : [UIColor blackColor];
	cell.accessoryType				= UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary * menuItem					= self.items[indexPath.row];
	
	if (!menuItem[@"action"])
		return;
	
	SEL action								= [menuItem[@"action"] pointerValue];
	IMP implementation						= [self methodForSelector:action];
	void(* func)(id, SEL, NSDictionary *)	= (void *)implementation;
	
	func(self, action, menuItem);
	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - FormViewControllerDelegate

- (void)formController:(nonnull FormViewController *)formController didUpdateItem:(nonnull BaseModel *)item {
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Actions

- (void)onEditProfile:(NSDictionary *)menuItem {
	[self.navigationController pushViewController:[[UserCreateUpdateViewController alloc] initWithItem:(BaseModel *)SETTINGS.currentUser andDelegate:self] animated:YES];
}


- (void)onLogout:(NSDictionary *)menuItem {
	[self presentConfirmationWithMessage:NSLocalizedString(@"Do you want to logout?", nil) buttonTitle:NSLocalizedString(@"Logout", nil) cancelHandler:nil yesHandler:^(UIAlertAction * _Nonnull action) {
		[Auth logout:^(NSError * _Nullable error) {
			if ([self checkForErrors:error])
				[Auth notifyUnathorized];
		}];
	} animated:YES];
}


#pragma mark - UIViewController Stuff

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.tableView.rowHeight		= PREDEFINED_TABLE_CELL_HEIGHT;
	self.tableView.tableFooterView	= [[UIView alloc] initWithFrame:CGRectZero];

	[SettingsTableViewCell registerForTableView:self.tableView];
}


@end