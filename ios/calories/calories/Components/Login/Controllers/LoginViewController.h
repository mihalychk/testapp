//
//  LoginViewController.h
//  calories
//
//  Created by Home on 04/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseFormViewController.h"




@protocol LoginViewControllerDelegete;




@interface LoginViewController : BaseFormViewController

@property (nonatomic, nullable, weak) id<LoginViewControllerDelegete> delegate;

@end




@protocol LoginViewControllerDelegete <NSObject>

@optional

- (void)loginControllerWantsToDismiss:(nonnull LoginViewController *)loginController;

@end