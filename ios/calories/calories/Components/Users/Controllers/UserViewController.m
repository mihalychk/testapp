//
//  UserViewController.m
//  calories
//
//  Created by Michael on 08/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "UserViewController.h"
#import "Common.h"
#import "UserModel.h"
#import "GroupModel.h"
#import "Settings.h"
#import "UserCreateUpdateViewController.h"




@interface UserViewController () <FormViewControllerDelegate> {
	
}

@property (weak) IBOutlet UILabel * nameLabel;
@property (weak) IBOutlet UILabel * emailLabel;
@property (weak) IBOutlet UILabel * groupNameLabel;

@end




@implementation UserViewController


#pragma mark - FormViewControllerDelegate

- (void)formController:(nonnull FormViewController *)formController didUpdateItem:(nonnull BaseModel *)item {
	[self updateData];
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Actions

- (void)onEditBarButtonItem:(nullable UIBarButtonItem *)sender {
	[self.navigationController pushViewController:[[UserCreateUpdateViewController alloc] initWithItem:self.user andDelegate:self] animated:YES];
}


#pragma mark - Getters & Setters

- (UserModel *)user {
	return (UserModel *)self.item;
}


#pragma mark - Data

- (void)updateData {
	self.title					= self.user.name;
	self.nameLabel.text			= self.user.name;
	self.emailLabel.text		= self.user.email;
	self.groupNameLabel.text	= self.user.group.canIRead ? self.user.group.name : nil;
}


#pragma mark - UIViewController Stuff

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self updateData];
}


@end