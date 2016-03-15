//
//  BaseViewController.m
//  calories
//
//  Created by Home on 05/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseViewController.h"
#import "Predefined.h"
#import "AppDelegate.h"
#import "BaseModel.h"
#import "ValidationError.h"




@interface BaseViewController () {
	__strong ViewControllerBlock beforePresentation;
	__weak UIScrollView * mainScrollView;

	BOOL moveScreenOnEdit;
}

@end




@implementation BaseViewController


@synthesize beforePresentation, mainScrollView, moveScreenOnEdit;


#pragma mark - init & dealloc

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardDidShow:)  name:UIKeyboardDidShowNotification  object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardDidHide:)  name:UIKeyboardDidHideNotification  object:nil];

		moveScreenOnEdit			= YES;
	}
	
	return self;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	self.beforePresentation		= nil;
}


#pragma mark - Private Methods

- (nullable id)_viewFirstResponder:(UIView *)view {
	if (view.isFirstResponder)
		return view;
	
	for (UIView * subView in view.subviews) {
		id result		= [self _viewFirstResponder:subView];
		
		if (result)
			return result;
	}
	
	return nil;
}


- (void)_presentPopupWithStyle:(UIAlertControllerStyle)style title:(nullable NSString *)title message:(nullable NSString *)message andActions:(nullable NSArray<UIAlertAction *> *)actions animated:(BOOL)animated {
	UIAlertController * controller			= [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
	
	for (UIAlertAction * action in actions)
		[controller addAction:action];
	
	[self presentViewController:controller animated:animated completion:nil];
}


#pragma mark - API

- (BOOL)validateForm:(nullable NSArray<ValidationError *> *)validationErrors {
	if (!VALID_ARRAY_1(validationErrors))
		return YES;

	[self loader:NO animated:YES];
	
	NSMutableArray * messages		= [NSMutableArray array];
	
	for (ValidationError * error in validationErrors)
		if (VALID_STRING_1(error.message))
			[messages addObject:error.message];
	
	NSString * message				= [messages componentsJoinedByString:@"\n• "];
	
	if (messages.count > 1)
		message							= FORMAT(@"• %@", message);
	
	[self presentAlertOKWithTitle:NSLocalizedString(@"Validation error", nil) message:message animated:YES];

	return NO;
}


- (BOOL)checkForErrors:(nullable NSError *)error {
	if (error) {
		[self loader:NO animated:YES];
		[self presentAlertError:error animated:YES];

		return NO;
	}
	
	return YES;
}


#pragma mark - Public Methods

- (nullable id)firstResponder {
	return [self _viewFirstResponder:self.view];
}


- (void)loader:(BOOL)show animated:(BOOL)animated {
	[(AppDelegate *)[UIApplication sharedApplication].delegate loader:show animated:animated];
}


- (void)presentSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message andActions:(nullable NSArray<UIAlertAction *> *)actions animated:(BOOL)animated {
	[self _presentPopupWithStyle:UIAlertControllerStyleActionSheet title:title message:message andActions:actions animated:animated];
}


- (void)presentAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message andActions:(nullable NSArray<UIAlertAction *> *)actions animated:(BOOL)animated {
	[self _presentPopupWithStyle:UIAlertControllerStyleAlert title:title message:message andActions:actions animated:animated];
}


- (void)presentAlertOKWithTitle:(nullable NSString *)title message:(nullable NSString *)message animated:(BOOL)animated {
	[self presentAlertWithTitle:title message:message andActions:@[[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil]] animated:animated];
}


- (void)presentAlertError:(nullable NSError *)error animated:(BOOL)animated {
	[self presentAlertOKWithTitle:error.localizedFailureReason message:error.localizedDescription animated:animated];
}


- (void)presentConfirmationWithMessage:(nullable NSString *)message buttonTitle:(nullable NSString *)buttonTitle cancelHandler:(void(^__nullable)(UIAlertAction * _Nonnull action))cancelHandler yesHandler:(void(^__nullable)(UIAlertAction * _Nonnull action))yesHandler animated:(BOOL)animated {
	NSMutableArray * actions		= [NSMutableArray array];

	[actions addObject:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:cancelHandler]];
	[actions addObject:[UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:yesHandler]];

	[self presentAlertWithTitle:NSLocalizedString(@"Confirmation", nil) message:message andActions:actions animated:animated];
}


#pragma mark -

- (nonnull UIRefreshControl *)refreshControlWithAction:(nullable SEL)action {
	__autoreleasing UIRefreshControl * control	= [[UIRefreshControl alloc] init];

	if (action)
		[control addTarget:self action:action forControlEvents:UIControlEventValueChanged];
	
	return control;
}


#pragma mark - Keyboard Notifications

- (void)_keyboardWillShow:(nonnull NSNotification *)notification {
	UIView * view							= self.firstResponder;
	CGRect frame							= [mainScrollView convertRect:view.frame fromView:view.superview];
	CGSize keyboardSize						= [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	CGFloat keyboardHeight					= MIN(keyboardSize.height, keyboardSize.width);
	CGFloat visibleHeight					= mainScrollView.frame.size.height - keyboardHeight;

	[UIView animateWithDuration:0.15f animations:^{
		mainScrollView.contentInset				= UIEdgeInsetsMake(0.0f, 0.0f, keyboardHeight, 0.0f);
		mainScrollView.scrollIndicatorInsets	= mainScrollView.contentInset;
		
		if (moveScreenOnEdit)
			mainScrollView.contentOffset			= CGPointMake(0.0f, frame.origin.y - (visibleHeight > frame.size.height ? ((visibleHeight - frame.size.height) * 0.5f) : (visibleHeight * 0.33f)));
	}];
}


- (void)_keyboardWillHide:(nonnull NSNotification *)notification {
	[UIView animateWithDuration:0.15f animations:^{
		mainScrollView.contentInset				= UIEdgeInsetsZero;
		mainScrollView.scrollIndicatorInsets	= mainScrollView.contentInset;
	}];
}


- (void)_keyboardDidShow:(nonnull NSNotification *)notification {

}


- (void)_keyboardDidHide:(nonnull NSNotification *)notification {

}


#pragma mark - UIViewController Stuff

- (void)viewDidLoad {
	[super viewDidLoad];
	
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
		self.edgesForExtendedLayout	= UIRectEdgeNone;
	
	IN_MAINTHREAD(^{
		if (beforePresentation)
			beforePresentation();
	});
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	[self.firstResponder resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end