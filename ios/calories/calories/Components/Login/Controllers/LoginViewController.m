//
//  LoginViewController.m
//  calories
//
//  Created by Home on 04/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "LoginViewController.h"
#import "Common.h"
#import "Settings.h"
#import "Auth.h"
#import "Utils.h"
#import "ValidationError.h"




@interface LoginViewController () <UITextFieldDelegate> {
	BOOL isRegisterMode;
}

@property (weak) IBOutlet UIView      * loginView;
@property (weak) IBOutlet UITextField * email1TextField;
@property (weak) IBOutlet UITextField * password1TextField;
@property (weak) IBOutlet UIButton    * loginButton;

@property (weak) IBOutlet UIView      * registerView;
@property (weak) IBOutlet UITextField * email2TextField;
@property (weak) IBOutlet UITextField * name2TextField;
@property (weak) IBOutlet UITextField * password2TextField;
@property (weak) IBOutlet UIButton    * registerButton;

@property (weak) IBOutlet UIButton    * toggleButton;

@end



@implementation LoginViewController


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if (isRegisterMode) {
		if (textField == self.email2TextField)
			textField.returnKeyType		= VALID_STRING_1(self.name2TextField.text) && VALID_STRING_1(self.password2TextField.text) ? UIReturnKeyGo : UIReturnKeyNext;

		else if (textField == self.name2TextField)
			textField.returnKeyType		= VALID_STRING_1(self.email2TextField.text) && VALID_STRING_1(self.password2TextField.text) ? UIReturnKeyGo : UIReturnKeyNext;

		else
			textField.returnKeyType		= VALID_STRING_1(self.email2TextField.text) && VALID_STRING_1(self.name2TextField.text) ? UIReturnKeyGo : UIReturnKeyNext;
	}
	else {
		if (textField == self.email1TextField)
			textField.returnKeyType		= VALID_STRING_1(self.password1TextField.text) ? UIReturnKeyGo : UIReturnKeyNext;

		else
			textField.returnKeyType		= VALID_STRING_1(self.email1TextField.text) ? UIReturnKeyGo : UIReturnKeyNext;
	}

	return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (isRegisterMode) {
		if (textField.returnKeyType == UIReturnKeyGo) {
			[textField resignFirstResponder];
			[self onRegisterButton:nil];
		}
		else {
			if (textField == self.email2TextField)
				[self.name2TextField becomeFirstResponder];

			else if (textField == self.name2TextField)
				[self.password2TextField becomeFirstResponder];

			else
				[self.email2TextField becomeFirstResponder];
		}
	}
	else {
		if (textField.returnKeyType == UIReturnKeyGo) {
			[textField resignFirstResponder];
			[self onLoginButton:nil];
		}
		else {
			if (textField == self.email1TextField)
				[self.password1TextField becomeFirstResponder];

			else
				[self.email1TextField becomeFirstResponder];
		}
	}

	return NO;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField == self.email1TextField)
		SETTINGS.email					= self.email1TextField.text;

	else if (textField == self.password1TextField)
		SETTINGS.password				= self.password1TextField.text;
}


- (IBAction)textFieldEditingChanged:(UITextField *)textField {
	if (isRegisterMode)
		[self updateRegisterButton];

	else
		[self updateLoginButton];
}


#pragma mark - Actions

- (IBAction)onToggleButton:(UIButton *)sender {
	isRegisterMode					= !isRegisterMode;

	[self updateViews:YES];
}


- (IBAction)onLoginButton:(UIButton *)sender {
	[self.firstResponder resignFirstResponder];

	[self loginWithEmail:self.email1TextField.text andPassword:self.password1TextField.text];
}


- (IBAction)onRegisterButton:(UIButton *)sender {
	[self.firstResponder resignFirstResponder];
	
	[self registerWithEmail:self.email2TextField.text name:self.name2TextField.text andPassword:self.password2TextField.text];
}


#pragma mark - UIView Helpers

- (void)updateViews:(BOOL)animated {
	[self.toggleButton setTitle:isRegisterMode ? NSLocalizedString(@"Login an Existing User", nil) : NSLocalizedString(@"Create a New User", nil) forState:UIControlStateNormal];
	[self updateLoginButton];
	[self updateRegisterButton];

	void(^animation)(void)			= ^{
		self.loginView.alpha			= isRegisterMode ? 0.0f : 1.0f;
		self.registerView.alpha			= isRegisterMode ? 1.0f : 0.0f;
	};

	if (animated)
		[UIView animateWithDuration:0.5f animations:animation];

	else
		animation();
}


- (void)updateLoginButton {
	self.loginButton.enabled		= VALID_STRING_1([Utils trimString:self.email1TextField.text]) && VALID_STRING_1(self.password1TextField.text);
}


- (void)updateRegisterButton {
	self.registerButton.enabled		= VALID_STRING_1([Utils trimString:self.email2TextField.text]) && VALID_STRING_1([Utils trimString:self.name2TextField.text]) && VALID_STRING_1(self.password2TextField.text);
}


#pragma mark - Auth Helpers

- (void(^)(id _Nullable data, NSArray<ValidationError *> * _Nullable validationErrors, NSError * _Nullable error))callbackForLoginRegister {
	return ^(id _Nullable data, NSArray<ValidationError *> * _Nullable validationErrors, NSError * _Nullable error) {
		if ([self checkForErrors:error])
			if ([self validateForm:validationErrors]) {
				[self loader:NO animated:YES];

				if ([self.delegate respondsToSelector:@selector(loginControllerWantsToDismiss:)])
					[self.delegate loginControllerWantsToDismiss:self];
			}
	};
}


#pragma mark - Login & Register

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password {
	[self loader:YES animated:YES];

	[Auth loginWithEmail:email password:password callback:self.callbackForLoginRegister];
}


- (void)registerWithEmail:(NSString *)email name:(NSString *)name andPassword:(NSString *)password {
	[self loader:YES animated:YES];

	[Auth registerWithEmail:email name:name password:password callback:self.callbackForLoginRegister];
}


#pragma mark - UIViewController Stuff

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.navigationController setNavigationBarHidden:YES animated:NO];

	self.email1TextField.text		= SETTINGS.email;
	self.password1TextField.text	= SETTINGS.password;

	[self updateViews:NO];
}


@end