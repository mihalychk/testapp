//
//  TableSection.m
//  calories
//
//  Created by Michael on 10/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "TableSection.h"




@implementation TableSection


#pragma mark - init & dealloc

+ (nonnull instancetype)tableSectionWithTitle:(nonnull NSString *)title andItems:(nullable NSMutableArray<BaseModel *> *)items {
	__autoreleasing TableSection * section	= [[[self class] alloc] init];

	section.title							= title;
	section.items							= items;

	return section;
}


#pragma mark - NSObject

- (NSUInteger)hash {
	return self.title.hash;
}


- (BOOL)isEqual:(id)object {
	if (object == self)
		return YES;

	if (![object isKindOfClass:[TableSection class]])
		return NO;

	return [((TableSection *)object).title isEqualToString:self.title];
}


@end