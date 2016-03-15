//
//  UsersTableViewCell.m
//  calories
//
//  Created by Michael on 08/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "UsersTableViewCell.h"




@implementation UsersTableViewCell


- (void)prepareForReuse {
	[super prepareForReuse];

	self.nameLabel.text			= nil;
	self.groupNameLabel.text	= nil;
}


@end