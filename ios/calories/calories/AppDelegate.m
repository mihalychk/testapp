//
//  AppDelegate.m
//  calories
//
//  Created by Home on 03/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "AppDelegate.h"
#import "Settings.h"
#import "LoginViewController.h"
#import "TabBarViewController.h"
#import "LoaderView.h"
#import "Common.h"




@interface AppDelegate () <LoginViewControllerDelegete> {
	__strong UIWindow            * window;
	__strong LoaderView          * loaderView;
	__strong LoginViewController * loginController;
}

@end




@implementation AppDelegate


#pragma mark - Public Methods

- (void)loader:(BOOL)show animated:(BOOL)animated {
	if (show) {
		if (!loaderView)
			loaderView						= [[NSBundle mainBundle] loadNibNamed:@"LoaderView" owner:self options:nil].firstObject;

		if (animated)
			loaderView.alpha                = 0.0f;

		[window addSubview:loaderView];

		loaderView.frame				= [UIScreen mainScreen].bounds;

		if (animated)
			[UIView animateWithDuration:0.25f animations:^{
				loaderView.alpha                = 1.0f;
			}];

		else
			loaderView.alpha                = 1.0f;
	}
	else {
		if (!loaderView)
			return;

		if (animated)
			[UIView animateWithDuration:0.125f animations:^{
				loaderView.alpha                = 0.0f;
			} completion:^(BOOL finished) {
				[loaderView removeFromSuperview];
			}];

		else
			[loaderView removeFromSuperview];
	}
}


- (void)showLoginAnimated:(BOOL)animated completion:(void(^__nullable)(void))completion {
	if (loginController) {
		LOG(@"showLoginAnimated:%@ completion:func(), pass", SBOOL(animated));

		return;
	}

	loginController						= [[LoginViewController alloc] init];
	loginController.delegate			= self;

	[window.rootViewController presentViewController:loginController animated:animated completion:completion];
}


#pragma mark - LoginViewControllerDelegete

- (void)loginControllerWantsToDismiss:(nonnull LoginViewController *)_loginController {
	[loginController dismissViewControllerAnimated:YES completion:^{
		loginController						= nil;
	}];
}


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { //SETTINGS.authToken = @"pikachu";
	window								= [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	window.backgroundColor				= [UIColor whiteColor];
	window.autoresizesSubviews			= YES;
	window.rootViewController			= [[TabBarViewController alloc] init];
	
	[window makeKeyAndVisible];

	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end