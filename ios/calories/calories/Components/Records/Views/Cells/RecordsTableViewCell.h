//
//  RecordsTableViewCell.h
//  calories
//
//  Created by Michael on 09/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseTableViewCell.h"




@interface RecordsTableViewCell : BaseTableViewCell

@property (weak) IBOutlet UILabel * textValueLabel;
@property (weak) IBOutlet UILabel * userNameLabel;
@property (weak) IBOutlet UILabel * timeLabel;
@property (weak) IBOutlet UILabel * caloriesLabel;

@end