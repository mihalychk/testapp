//
//  BaseTableViewCell.m
//  calories
//
//  Created by Michael on 08/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseTableViewCell.h"




@implementation BaseTableViewCell


#pragma mark - init & dealloc

- (void)awakeFromNib {
	[super awakeFromNib];

	[self prepareForReuse];
}


#pragma mark - Public Methods

+ (nonnull NSString *)cellIdentifier {
	return NSStringFromClass([self class]);
}


+ (void)registerForTableView:(nonnull UITableView *)tableView {
	NSString * cellId			= self.cellIdentifier;
	
	[tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
}


@end