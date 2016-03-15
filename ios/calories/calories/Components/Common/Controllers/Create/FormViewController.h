//
//  FormViewController.h
//  calories
//
//  Created by Michael on 11/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseFormViewController.h"




@class BaseModel;
@protocol FormViewControllerDelegate;




@interface FormViewController : BaseFormViewController

@property (nonatomic, nullable, weak) id<FormViewControllerDelegate> delegate;
@property (nonatomic, nullable, strong) BaseModel * item;
@property (nonatomic, nullable, strong) BaseModel * itemForSave;
@property (nonatomic, readonly) BOOL isEditMode;

- (nonnull instancetype)initWithItem:(nullable BaseModel *)item andDelegate:(nullable id<FormViewControllerDelegate>)delegate;

@end




@protocol FormViewControllerDelegate <NSObject>

@optional

- (void)formController:(nonnull FormViewController *)formController didCreateItem:(nonnull BaseModel *)item;
- (void)formController:(nonnull FormViewController *)formController didUpdateItem:(nonnull BaseModel *)item;

@end