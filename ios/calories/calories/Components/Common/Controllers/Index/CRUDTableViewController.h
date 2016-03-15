//
//  CRUDTableViewController.h
//  calories
//
//  Created by Michael on 08/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseCRUDTableViewController.h"




@class BaseModel;




@interface CRUDTableViewController : BaseCRUDTableViewController

@property (nonatomic, nullable, strong) NSArray<BaseModel *> * items;

@end