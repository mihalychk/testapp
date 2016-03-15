//
//  RecordCreateUpdateViewController.m
//  calories
//
//  Created by Michael on 10/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "RecordCreateUpdateViewController.h"
#import "Predefined.h"
#import "RecordModel.h"
#import "BaseService.h"
#import "Utils.h"




@interface RecordCreateUpdateViewController ()

@property (weak) IBOutlet UIView      * recordView;
@property (weak) IBOutlet UITextField * textTextField;
@property (weak) IBOutlet UITextField * caloriesTextField;
@property (weak) IBOutlet UITextField * datetimeTextField;
@property (weak) IBOutlet UIButton    * saveButton;

@end




@implementation RecordCreateUpdateViewController


#pragma mark - init & dealloc

- (nonnull instancetype)initWithItem:(nullable BaseModel *)item andDelegate:(nullable id<FormViewControllerDelegate>)delegate {
	if ((self = [super initWithItem:item andDelegate:delegate])) {
		self.itemForSave			= item ? [item copy] : [[RecordModel alloc] init];
	}
	
	return self;
}


#pragma mark - Getters & Setters

- (RecordModel *)recordForSave {
	return (RecordModel *)self.itemForSave;
}


#pragma mark - Actions

- (void)onDatePickerValueChanged:(UIDatePicker *)sender {
	self.recordForSave.datetime		= [Utils trimSeconds:sender.date];

	[self updateDateTime];
	[self updateSaveButton];
}


- (IBAction)onSaveButton:(UIButton *)sender {
	[self.firstResponder resignFirstResponder];
	[self save];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if (textField == self.textTextField)
		textField.returnKeyType		= VALID_STRING_1(self.caloriesTextField.text) && VALID_STRING_1(self.datetimeTextField.text) ? UIReturnKeyGo : UIReturnKeyNext;
	
	else if (textField == self.caloriesTextField)
		textField.returnKeyType		= VALID_STRING_1(self.textTextField.text) && VALID_STRING_1(self.datetimeTextField.text) ? UIReturnKeyGo : UIReturnKeyNext;
	
	else
		textField.returnKeyType		= VALID_STRING_1(self.textTextField.text) && VALID_STRING_1(self.caloriesTextField.text) ? UIReturnKeyGo : UIReturnKeyNext;
	
	return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField.returnKeyType == UIReturnKeyGo)
		[self onSaveButton:nil];

	else {
		if (textField == self.textTextField)
			[self.caloriesTextField becomeFirstResponder];
		
		else if (textField == self.caloriesTextField)
			[self.datetimeTextField becomeFirstResponder];
		
		else
			[self.textTextField becomeFirstResponder];
	}
	
	return NO;
}


- (IBAction)textFieldEditingChanged:(UITextField *)textField {
	if (textField == self.textTextField)
		self.recordForSave.text			= self.textTextField.text;
	
	else if (textField == self.caloriesTextField) {
		NSString * text					= [self.caloriesTextField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
		self.caloriesTextField.text		= text;
		self.recordForSave.calories		= [Utils numberFromString:text];
	}
	
	[self updateSaveButton];
}


#pragma mark - UI

- (void)updateView {
	if (self.isEditMode) {
		self.title						= NSLocalizedString(@"Edit", nil);
		self.textTextField.text			= self.recordForSave.text;
		self.caloriesTextField.text		= self.recordForSave.calories.stringValue;

		[self updateDateTime];
		[self.saveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
	}
	else {
		self.title							= NSLocalizedString(@"Create", nil);
		
		[self.saveButton setTitle:NSLocalizedString(@"Create", nil) forState:UIControlStateNormal];
	}

	[self updateSaveButton];
}


- (void)updateDateTime {
	self.datetimeTextField.text		= VALID_DATE(self.recordForSave.datetime) ? [Utils stringFromDate:self.recordForSave.datetime withFormat:@"d LLLL yyyy 'at' HH:mm"] : nil;
}


- (void)updateSaveButton {
	self.saveButton.enabled			= VALID_STRING_1([Utils trimString:self.textTextField.text]) && VALID_NUMBER(self.recordForSave.calories) && VALID_DATE(self.recordForSave.datetime);
}


#pragma mark - Data

- (void)save {
	[self loader:YES animated:YES];
	
	if (self.isEditMode)
		[BaseService update:self.recordForSave callback:^(BaseModel * _Nullable model, NSArray<ValidationError *> * _Nullable validationErrors, NSError * _Nullable error) {
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
		[BaseService create:self.recordForSave callback:^(BaseModel * _Nullable model, NSArray<ValidationError *> * _Nullable validationErrors, NSError * _Nullable error) {
			if ([self checkForErrors:error])
				if ([self validateForm:validationErrors]) {
					if ([self.delegate respondsToSelector:@selector(formController:didCreateItem:)])
						[self.delegate formController:self didCreateItem:model];
				}
		}];
}


- (void)viewDidLoad {
	[super viewDidLoad];

	UIDatePicker * datePicker			= [[UIDatePicker alloc]init];
	datePicker.date						= VALID_DATE(self.recordForSave.datetime) ? self.recordForSave.datetime : [NSDate date];
	datePicker.datePickerMode			= UIDatePickerModeDateAndTime;
	datePicker.minuteInterval			= PREDEFINED_TIMEPICKER_INTERVAL;
	self.datetimeTextField.inputView	= datePicker;

	[datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
	
	[self updateView];
}


@end