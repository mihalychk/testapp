//
//  RecordsTableViewCell.m
//  calories
//
//  Created by Michael on 09/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "RecordsTableViewCell.h"




@implementation RecordsTableViewCell


- (void)prepareForReuse {
	[super prepareForReuse];
	
	self.textValueLabel.text	= nil;
	self.userNameLabel.text		= nil;
	self.timeLabel.text			= nil;
	self.caloriesLabel.text		= nil;
}


@end