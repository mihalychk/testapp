//
//  RecordsFilterViewController.h
//  calories
//
//  Created by Michael on 11/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseFormViewController.h"




@protocol RecordsFilterViewControllerDelegate;




@interface RecordsFilterViewController : BaseFormViewController

@property (nonatomic, nullable, weak) id<RecordsFilterViewControllerDelegate> delegate;

- (nullable instancetype)initWithDelegate:(nullable id<RecordsFilterViewControllerDelegate>)delegate;

@end




@protocol RecordsFilterViewControllerDelegate <NSObject>

@optional

- (void)recordsFilterControllerDidChangeFilter:(nonnull RecordsFilterViewController *)recordsFilterController;

@end