//
//  RecordsViewController.m
//  calories
//
//  Created by Home on 04/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "RecordsViewController.h"
#import "Common.h"
#import "Settings.h"
#import "Records.h"
#import "RecordModel.h"
#import "UserModel.h"
#import "RecordsTableViewCell.h"
#import "RecordViewController.h"
#import "RecordCreateUpdateViewController.h"
#import "Utils.h"
#import "RecordTableSection.h"
#import "RecordsFilterViewController.h"




@interface RecordsViewController () <FormViewControllerDelegate, RecordsFilterViewControllerDelegate>

@end



@implementation RecordsViewController


#pragma mark - init & dealloc

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.itemClass			= [RecordModel class];
		self.title				= NSLocalizedString(@"Calories", nil);
		self.tabBarItem			= [[UITabBarItem alloc] initWithTitle:self.title image:IMAGE(@"tabBarRecords") tag:1];
	}

	return self;
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	RecordsTableViewCell * cell		= [tableView dequeueReusableCellWithIdentifier:RecordsTableViewCell.cellIdentifier forIndexPath:indexPath];
	
	RecordModel * record			= (RecordModel *)[self itemAtIndexPath:indexPath];

	cell.textValueLabel.text		= record.text;
	cell.userNameLabel.text			= record.user.name;
	cell.caloriesLabel.text			= record.calories.stringValue;
	cell.timeLabel.text				= [Utils stringFromDate:record.datetime withFormat:@"HH:mm"];
	cell.accessoryType				= UITableViewCellAccessoryDisclosureIndicator;

	if ([record.userId isEqualToNumber:SETTINGS.currentUser.identifier]) {
		if (((RecordTableSection *)self.sections[indexPath.section]).markRed)
			cell.caloriesLabel.textColor	= [UIColor colorWithRed:0.75f green:0.0f blue:0.0f alpha:1.0f];

		else
			cell.caloriesLabel.textColor	= [UIColor colorWithRed:0.0f green:0.75f blue:0.0f alpha:1.0f];
	}
	else
		cell.caloriesLabel.textColor	= [UIColor blackColor];
	
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


#pragma mark - RecordsFilterViewControllerDelegate

- (void)recordsFilterControllerDidChangeFilter:(nonnull RecordsFilterViewController *)recordsFilterController {
	[self loader:YES animated:YES];

	[self updateData:^{
		[self.navigationController popViewControllerAnimated:YES];
	}];
}


#pragma mark - Actions

- (void)onFilterBarButtonItem:(nullable UIBarButtonItem *)sender {
	[self.navigationController pushViewController:[[RecordsFilterViewController alloc] initWithDelegate:self] animated:YES];
}


#pragma mark - Override

- (void)onRefreshControl:(nullable UIRefreshControl *)sender {
	[self updateData:^{
		[sender endRefreshing];
	}];
}


- (void)onAddBarButtonItem:(nullable UIBarButtonItem *)sender {
	[self.navigationController pushViewController:[[RecordCreateUpdateViewController alloc] initWithItem:nil andDelegate:self] animated:YES];
}


- (void)onReadItem:(nullable BaseModel *)item {
	[self.navigationController pushViewController:[[RecordViewController alloc] initWithItem:item] animated:YES];
}


- (void)onUpdateItem:(nullable BaseModel *)item {
	[self.navigationController pushViewController:[[RecordCreateUpdateViewController alloc] initWithItem:item andDelegate:self] animated:YES];
}


- (NSArray<TableSection *> *)sectionsFromItems:(NSArray<BaseModel *> *)items {
	__autoreleasing NSMutableArray * result	= [NSMutableArray array];

	for (RecordModel * record in items) {
		RecordTableSection * section	= [RecordTableSection tableSectionWithTitle:[Utils stringFromDate:record.datetime withFormat:@"EEE d MMMM yyyy"] andItems:[NSMutableArray array]];
		NSUInteger index				= [result indexOfObject:section];

		if (index == NSNotFound)
			[result addObject:section];

		else
			section						= result[index];

		[section.items insertObject:record atIndex:0];
	}

	CGFloat limitValue				= SETTINGS.currentUser.caloriesPerDay.floatValue;

	for (RecordTableSection * section in result) {
		CGFloat calories				= 0.0f;

		for (RecordModel * item in section.items)
			if ([item.userId isEqualToNumber:SETTINGS.currentUser.identifier])
				calories						+= item.calories.floatValue;

		section.markRed					= calories > limitValue;
	}

	return result;
}


#pragma mark - Data

- (void)updateData:(void(^__nullable)(void))callback {
	[Records index:[RecordModel class] callback:^(NSArray<BaseModel *> * _Nullable array, NSError * _Nullable error) {
		if ([self checkForErrors:error]) {
			[self loader:NO animated:YES];

			self.sections				= [self sectionsFromItems:array];
			
			[self.tableView reloadData];
		}
		
		if (callback)
			callback();
	}];
}


#pragma mark - UIViewController Stuff

- (void)viewDidLoad {
	[super viewDidLoad];

	self.navigationItem.leftBarButtonItem	= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(onFilterBarButtonItem:)];

	[RecordsTableViewCell registerForTableView:self.tableView];

	[self updateData:nil];
}


@end