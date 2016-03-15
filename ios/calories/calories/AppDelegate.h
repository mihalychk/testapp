//
//  AppDelegate.h
//  calories
//
//  Created by Home on 03/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import <UIKit/UIKit.h>




@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (void)loader:(BOOL)show animated:(BOOL)animated;
- (void)showLoginAnimated:(BOOL)animated completion:(void(^__nullable)(void))completion;

@end