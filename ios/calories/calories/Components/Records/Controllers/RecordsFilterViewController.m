//
//  RecordsFilterViewController.m
//  calories
//
//  Created by Michael on 11/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "RecordsFilterViewController.h"
#import "Predefined.h"
#import "Utils.h"
#import "Settings.h"




@interface RecordsFilterViewController ()

@property (weak) IBOutlet UITextField * timeFromTextField;
@property (weak) IBOutlet UITextField * timeToTextField;
@property (weak) IBOutlet UITextField * dateFromTextField;
@property (weak) IBOutlet UITextField * dateToTextField;

@end




#define _DATE(_textField_)	(((UIDatePicker *)_textField_.inputView).date)




@implementation RecordsFilterViewController


static __strong NSString * timeFormat	= @"HH:mm";
static __strong NSString * dateFormat	= @"d MMM yyyy";


#pragma mark - init & dealloc

- (nullable instancetype)initWithDelegate:(nullable id<RecordsFilterViewControllerDelegate>)delegate {
	if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil]))
		self.delegate			= delegate;

	return self;
}


#pragma mark - Actions

- (void)onDatePickerValueChanged:(UIDatePicker *)sender {
	if (sender == self.timeFromTextField.inputView)
		self.timeFromTextField.text		= [Utils stringFromDate:sender.date withFormat:timeFormat];

	else if (sender == self.timeToTextField.inputView)
		self.timeToTextField.text		= [Utils stringFromDate:sender.date withFormat:timeFormat];

	else if (sender == self.dateFromTextField.inputView)
		self.dateFromTextField.text		= [Utils stringFromDate:sender.date withFormat:dateFormat];

	else if (sender == self.dateToTextField.inputView)
		self.dateToTextField.text		= [Utils stringFromDate:sender.date withFormat:dateFormat];
}


- (IBAction)onApplyButton:(UIButton *)sender {
	[self apply];
}


#pragma mark - Helpers

- (UIDatePicker *)dateTimePickerWithMode:(UIDatePickerMode)mode andInitDate:(NSDate *)initDate {
	__autoreleasing UIDatePicker * timePicker	= [[UIDatePicker alloc]init];
	
	timePicker.date					= VALID_DATE(initDate) ? initDate : [NSDate date];
	timePicker.datePickerMode		= mode;
	timePicker.minuteInterval		= PREDEFINED_TIMEPICKER_INTERVAL;
	
	[timePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
	
	return timePicker;
}


#pragma mark -

- (void)apply {
	SETTINGS.timeFrom				= VALID_STRING_1(self.timeFromTextField.text) ? _DATE(self.timeFromTextField) : nil;
	SETTINGS.timeTo					= VALID_STRING_1(self.timeToTextField.text)   ? _DATE(self.timeToTextField)   : nil;
	SETTINGS.dateFrom				= VALID_STRING_1(self.dateFromTextField.text) ? [Utils setHours:0  minutes:0  andSeconds:0  toDate:_DATE(self.dateFromTextField)] : nil;
	SETTINGS.dateTo					= VALID_STRING_1(self.dateToTextField.text)   ? [Utils setHours:23 minutes:59 andSeconds:59 toDate:_DATE(self.dateToTextField)]   : nil;

	if ([self.delegate respondsToSelector:@selector(recordsFilterControllerDidChangeFilter:)])
		[self.delegate recordsFilterControllerDidChangeFilter:self];
}


#pragma mark - UI

- (void)updateView {
	self.timeFromTextField.text		= [Utils stringFromDate:SETTINGS.timeFrom withFormat:timeFormat];
	self.timeToTextField.text		= [Utils stringFromDate:SETTINGS.timeTo withFormat:timeFormat];
	
	self.dateFromTextField.text		= [Utils stringFromDate:SETTINGS.dateFrom withFormat:dateFormat];
	self.dateToTextField.text		= [Utils stringFromDate:SETTINGS.dateTo withFormat:dateFormat];
}


#pragma mark - UIViewController Stuff

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title							= NSLocalizedString(@"Filter", nil);
	
	self.timeFromTextField.inputView	= [self dateTimePickerWithMode:UIDatePickerModeTime andInitDate:SETTINGS.timeFrom];
	self.timeToTextField.inputView		= [self dateTimePickerWithMode:UIDatePickerModeTime andInitDate:SETTINGS.timeTo];
	
	self.dateFromTextField.inputView	= [self dateTimePickerWithMode:UIDatePickerModeDate andInitDate:SETTINGS.dateFrom];
	self.dateToTextField.inputView		= [self dateTimePickerWithMode:UIDatePickerModeDate andInitDate:SETTINGS.dateTo];

	[self updateView];
}


@end