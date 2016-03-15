//
//  UserCreateUpdateViewController.m
//  calories
//
//  Created by Michael on 08/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "UserCreateUpdateViewController.h"
#import "Common.h"
#import "UserModel.h"
#import "GroupModel.h"
#import "BaseService.h"
#import "Utils.h"




@interface UserCreateUpdateViewController () {

}

@property (weak) IBOutlet UIView             * userView;
@property (weak) IBOutlet UITextField        * emailTextField;
@property (weak) IBOutlet UITextField        * nameTextField;
@property (weak) IBOutlet UITextField        * passwordTextField;
@property (weak) IBOutlet UITextField        * caloriesPerDayTextField;
@property (weak) IBOutlet UIButton           * groupButton;
@property (weak) IBOutlet NSLayoutConstraint * groupButtonHeight;
@property (weak) IBOutlet UIButton           * saveButton;

@end




@implementation UserCreateUpdateViewController


#pragma mark - init & dealloc

- (nonnull instancetype)initWithItem:(nullable BaseModel *)item andDelegate:(nullable id<FormViewControllerDelegate>)delegate {
	if ((self = [super initWithItem:item andDelegate:delegate])) {
		self.itemForSave			= item ? [item copy] : [[UserModel alloc] init];
	}
	
	return self;
}


#pragma mark - Getters & Setters

- (UserModel *)userForSave {
	return (UserModel *)self.itemForSave;
}


#pragma mark - Actions

- (IBAction)onGroupButton:(UIButton *)sender {
	[self chooseGroup];
}


- (void)onGroupChanged:(GroupModel *)newGroup {
	self.userForSave.group		= newGroup;

	[self updateGroup];
}


- (IBAction)onSaveButton:(UIButton *)sender {
	[self.firstResponder resignFirstResponder];
	[self save];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if (textField == self.emailTextField)
		textField.returnKeyType		= VALID_STRING_1(self.nameTextField.text) && VALID_STRING_1(self.passwordTextField.text) ? UIReturnKeyGo : UIReturnKeyNext;
	
	else if (textField == self.nameTextField)
		textField.returnKeyType		= VALID_STRING_1(self.emailTextField.text) && VALID_STRING_1(self.passwordTextField.text) ? UIReturnKeyGo : UIReturnKeyNext;
	
	else
		textField.returnKeyType		= VALID_STRING_1(self.emailTextField.text) && VALID_STRING_1(self.nameTextField.text) ? UIReturnKeyGo : UIReturnKeyNext;
	
	return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField.returnKeyType == UIReturnKeyGo)
		[self onSaveButton:nil];

	else {
		if (textField == self.emailTextField)
			[self.nameTextField becomeFirstResponder];
		
		else if (textField == self.nameTextField)
			[self.passwordTextField becomeFirstResponder];
		
		else if (textField == self.passwordTextField)
			[self.caloriesPerDayTextField becomeFirstResponder];
		
		else
			[self.emailTextField becomeFirstResponder];
	}
	
	return NO;
}


- (IBAction)textFieldEditingChanged:(UITextField *)textField {
	if (textField == self.emailTextField)
		self.userForSave.email				= self.emailTextField.text;
	
	else if (textField == self.nameTextField)
		self.userForSave.name				= self.nameTextField.text;
	
	else if (textField == self.passwordTextField)
		self.userForSave.password			= self.passwordTextField.text;
	
	else if (textField == self.caloriesPerDayTextField) {
		NSString * text						= [self.caloriesPerDayTextField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
		self.caloriesPerDayTextField.text	= text;
		self.userForSave.caloriesPerDay		= [Utils numberFromString:text];
	}

	[self updateSaveButton];
}


#pragma mark - Groups

- (void)_chooseGroup:(NSArray<GroupModel *> *)groups {
	NSMutableArray * actions	= [NSMutableArray array];

	for (GroupModel * group in groups) {
		NSString * name				= [group isEqual:self.userForSave.group] ? FORMAT(@"• %@", group.name) : group.name;
		UIAlertAction * action		= [UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[self onGroupChanged:group];
		}];

		if (action)
			[actions addObject:action];
	}

	[self presentSheetWithTitle:NSLocalizedString(@"Shoose Group", nil) message:nil andActions:actions animated:YES];
}


- (void)chooseGroup {
	[self loader:YES animated:YES];

	[BaseService index:[GroupModel class] callback:^(NSArray<BaseModel *> * _Nullable array, NSError * _Nullable error) {
		if ([self checkForErrors:error]) {
			[self loader:NO animated:YES];
			[self _chooseGroup:(NSArray<GroupModel *> *)array];
		}
	}];
}


#pragma mark - UI

- (void)updateGroup {
	if (GroupModel.canIList) {
		[self.groupButton setTitle:VALID_STRING_1(self.userForSave.group.name) ? self.userForSave.group.name : NSLocalizedString(@"Choose Group", nil) forState:UIControlStateNormal];
		
		self.groupButton.enabled			= YES;
		self.groupButtonHeight.constant		= 44.0f;
	}
	else {
		[self.groupButton setTitle:nil forState:UIControlStateNormal];
		
		self.groupButton.enabled			= NO;
		self.groupButtonHeight.constant		= 0.01f;
	}
}


- (void)updateView {
	if (self.isEditMode) {
		self.title							= NSLocalizedString(@"Edit", nil);
		self.emailTextField.text			= self.userForSave.email;
		self.nameTextField.text				= self.userForSave.name;
		self.caloriesPerDayTextField.text	= self.userForSave.caloriesPerDay.stringValue;
		self.passwordTextField.placeholder	= NSLocalizedString(@"New Password", nil);

		[self.saveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
	}
	else {
		self.title							= NSLocalizedString(@"Create", nil);
		self.passwordTextField.placeholder	= NSLocalizedString(@"Password", nil);
		
		[self.saveButton setTitle:NSLocalizedString(@"Create", nil) forState:UIControlStateNormal];
	}

	[self updateGroup];
	[self updateSaveButton];
}


- (void)updateSaveButton {
	self.saveButton.enabled		= VALID_STRING_1([Utils trimString:self.emailTextField.text]) && VALID_STRING_1([Utils trimString:self.nameTextField.text]) && (!self.isEditMode ? VALID_STRING_1(self.passwordTextField.text) : YES);
}


#pragma mark - Data

- (void)save {
	[self loader:YES animated:YES];

	if (self.isEditMode)
		[BaseService update:self.userForSave callback:^(BaseModel * _Nullable model, NSArray<ValidationError *> * _Nullable validationErrors, NSError * _Nullable error) {
			if ([self checkForErrors:error]) {
				if ([self validateForm:validationErrors]) {
					[self.item updateWithModel:model];
					[self loader:NO animated:YES];

					if ([self.delegate respondsToSelector:@selector(formController:didUpdateItem:)])
						[self.delegate formController:self didUpdateItem:self.item];
				}
			}
		}];

	else
		[BaseService create:self.userForSave callback:^(BaseModel * _Nullable model, NSArray<ValidationError *> * _Nullable validationErrors, NSError * _Nullable error) {
			if ([self checkForErrors:error])
				if ([self validateForm:validationErrors])
					if ([self.delegate respondsToSelector:@selector(formController:didCreateItem:)])
						[self.delegate formController:self didCreateItem:model];
		}];
}


#pragma mark - UIViewController Stuff

- (void)viewDidLoad {
	[super viewDidLoad];

	[self updateView];
}


@end