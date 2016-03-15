//
//  RecordViewController.m
//  calories
//
//  Created by Michael on 10/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "RecordViewController.h"
#import "Common.h"
#import "RecordModel.h"
#import "UserModel.h"
#import "Utils.h"
#import "RecordCreateUpdateViewController.h"




@interface RecordViewController () <FormViewControllerDelegate>

@property (weak) IBOutlet UILabel * textLabel;
@property (weak) IBOutlet UILabel * caloriesLabel;
@property (weak) IBOutlet UILabel * datetimeLabel;
@property (weak) IBOutlet UILabel * userNameLabel;

@end




@implementation RecordViewController


#pragma mark - FormViewControllerDelegate

- (void)formController:(nonnull FormViewController *)formController didUpdateItem:(nonnull BaseModel *)item {
	[self updateData];
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Actions

- (void)onEditBarButtonItem:(nullable UIBarButtonItem *)sender {
	[self.navigationController pushViewController:[[RecordCreateUpdateViewController alloc] initWithItem:self.item andDelegate:self] animated:YES];
}


#pragma mark - Getters & Setters

- (RecordModel *)record {
	return (RecordModel *)self.item;
}


#pragma mark - Data

- (void)updateData {
	self.title					= self.record.text;
	self.textLabel.text			= self.record.text;
	self.datetimeLabel.text		= [Utils stringFromDate:self.record.datetime withFormat:@"d LLLL yyyy 'at' HH:mm"];
	self.caloriesLabel.text		= self.record.calories.stringValue;
	self.userNameLabel.text		= self.record.user.canIRead ? self.record.user.name : nil;
}


#pragma mark - UIViewController Stuff

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self updateData];
}


@end