//
//  UsersTableViewCell.h
//  calories
//
//  Created by Michael on 08/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseTableViewCell.h"




@interface UsersTableViewCell : BaseTableViewCell

@property (weak) IBOutlet UILabel * nameLabel;
@property (weak) IBOutlet UILabel * groupNameLabel;

@end