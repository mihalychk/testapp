//
//  CRUDMultiTableViewController.h
//  calories
//
//  Created by Michael on 10/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseCRUDTableViewController.h"




@class TableSection;




@interface CRUDMultiTableViewController : BaseCRUDTableViewController

@property (nonatomic, nullable, strong) NSArray<TableSection *> * sections;

@end