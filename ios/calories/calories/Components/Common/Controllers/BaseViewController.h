//
//  BaseViewController.h
//  calories
//
//  Created by Home on 05/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import <UIKit/UIKit.h>




@class BaseModel, ValidationError;
typedef void(^__nullable ViewControllerBlock)(void);




@interface BaseViewController : UIViewController

@property (nonatomic, nullable, weak) UIScrollView * mainScrollView;
@property (nonatomic, nullable, copy) ViewControllerBlock beforePresentation;
@property (nonatomic, assign) BOOL moveScreenOnEdit;

- (nullable id)firstResponder;
- (void)loader:(BOOL)show animated:(BOOL)animated;

- (void)presentSheetWithTitle:(nullable NSString *)title message:(nullable NSString *)message andActions:(nullable NSArray<UIAlertAction *> *)actions animated:(BOOL)animated;
- (void)presentAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message andActions:(nullable NSArray<UIAlertAction *> *)actions animated:(BOOL)animated;
- (void)presentAlertOKWithTitle:(nullable NSString *)title message:(nullable NSString *)message animated:(BOOL)animated;
- (void)presentAlertError:(nullable NSError *)error animated:(BOOL)animated;
- (void)presentConfirmationWithMessage:(nullable NSString *)message buttonTitle:(nullable NSString *)buttonTitle cancelHandler:(void(^__nullable)(UIAlertAction * _Nonnull action))cancelHandler yesHandler:(void(^__nullable)(UIAlertAction * _Nonnull action))yesHandler animated:(BOOL)animated;

- (nonnull UIRefreshControl *)refreshControlWithAction:(nullable SEL)action;

- (BOOL)checkForErrors:(nullable NSError *)error;
- (BOOL)validateForm:(nullable NSArray<ValidationError *> *)validationErrors;

- (void)_keyboardWillShow:(nonnull NSNotification *)notification;
- (void)_keyboardWillHide:(nonnull NSNotification *)notification;
- (void)_keyboardDidShow:(nonnull NSNotification *)notification;
- (void)_keyboardDidHide:(nonnull NSNotification *)notification;

@end