//
//  Model.m
//  calories
//
//  Created by Michael on 07/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "Model.h"



@implementation Model


#pragma mark - init & dealloc

- (nonnull instancetype)initWithDictionary:(nullable NSDictionary *)dictionary {
	if ((self = [super init]))
		[self updateWithDictionary:dictionary];
	
	return self;
}


- (void)updateWithDictionary:(nullable NSDictionary *)dictionary {

}


+ (nonnull NSString *)fieldName {
	return nil;
}


+ (nonnull NSString *)modelName {
	return nil;
}


@end