//
//  CRUDViewController.h
//  calories
//
//  Created by Michael on 09/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseCRUDViewController.h"




@class BaseModel;




@interface CRUDViewController : BaseCRUDViewController

@property (nonatomic, nullable, strong) BaseModel * item;

- (nonnull instancetype)initWithItem:(nullable BaseModel *)item;
- (void)onEditBarButtonItem:(nullable UIBarButtonItem *)sender;			// On Update

@end