//
//  BaseTableViewCell.h
//  calories
//
//  Created by Michael on 08/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import <UIKit/UIKit.h>




@interface BaseTableViewCell : UITableViewCell

+ (nonnull NSString *)cellIdentifier;
+ (void)registerForTableView:(nonnull UITableView *)tableView;

@end