//
//  TabBarViewController.m
//  calories
//
//  Created by Michael on 07/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "TabBarViewController.h"
#import "Predefined.h"
#import "Settings.h"
#import "AppDelegate.h"
#import "Auth.h"
#import "UserModel.h"
#import "RecordModel.h"
#import "RecordsViewController.h"
#import "UsersViewController.h"
#import "SettingsViewController.h"




@interface TabBarViewController ()

@end




@implementation TabBarViewController


#pragma mark - init & dealloc

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUnauthorized:) name:API_UNAUTHORIZED_NOTIFICATION object:nil];

	return self;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 

- (void)showLoginAnimated:(BOOL)animated completion:(void(^__nullable)(void))completion {
	[(AppDelegate *)[UIApplication sharedApplication].delegate showLoginAnimated:animated completion:completion];
}


- (void)loader:(BOOL)show animated:(BOOL)animated {
	[(AppDelegate *)[UIApplication sharedApplication].delegate loader:show animated:animated];
}


- (void)onUnauthorized:(NSNotification *)notification {
	[self loader:NO animated:YES];
	[self showLoginAnimated:YES completion:nil];
	[self setViewControllers:@[] animated:NO];
}


#pragma mark - Data

- (void)updateTabs:(BOOL)forced {
	LOG(@"updateTabs: %@", SBOOL(forced));

	if (!forced) {
		if (VALID_ARRAY_1(self.viewControllers))
			return;
	}

	NSMutableArray * controllers	= [NSMutableArray array];
	
	if (RecordModel.canIList)
		[controllers addObject:[[UINavigationController alloc] initWithRootViewController:[[RecordsViewController alloc] init]]];
	
	if (UserModel.canIList)
		[controllers addObject:[[UINavigationController alloc] initWithRootViewController:[[UsersViewController alloc] init]]];

	if (SETTINGS.currentUser.canIRead && SETTINGS.currentUser.canIUpdate)
		[controllers addObject:[[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] init]]];

	[self setViewControllers:controllers animated:NO];
}


#pragma mark -

- (void)checkForSession {
	if (!SETTINGS.hasToken) {
		[self showLoginAnimated:NO completion:nil];
		
		return;
	}
	
	if (SETTINGS.currentUser)
		[self updateTabs:NO];
	
	else {
		[self loader:YES animated:NO];
		
		WEAK(self);

		[Auth session:^(BaseModel * _Nullable model, NSError * _Nullable error) {
			[WEAK_self loader:NO animated:NO];

			if (error)
				WLOG(@"DATA: %@, ERROR: %@", model, error);
			
			else
				[WEAK_self updateTabs:YES];
		}];
	}
}


#pragma mark - UIViewController Stuff

- (void)viewDidLoad {
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	IN_MAINTHREAD(^{
		[self checkForSession];
	});
	
}


@end