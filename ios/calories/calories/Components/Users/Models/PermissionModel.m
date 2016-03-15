//
//  PermissionModel.m
//  calories
//
//  Created by Michael on 07/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "PermissionModel.h"
#import "Common.h"
#import "Utils.h"




@implementation PermissionModel


#pragma mark - init & dealloc

- (nullable instancetype)copyWithZone:(nullable NSZone *)zone {
	PermissionModel * copy	= [super copyWithZone:zone];
	
	if (copy) {
		copy.model				= [self.model copyWithZone:zone];
		copy.create				= self.create;
		copy.read				= self.read;
		copy.update				= self.update;
		copy.delete				= self.delete;
	}
	
	return copy;
}


- (void)updateWithDictionary:(nullable NSDictionary *)dictionary {
	[super updateWithDictionary:dictionary];
	
	if (VALID_DICT_1(dictionary)) {
		NSString * fieldName		= [[self class] fieldName];
		
		if (VALID_DICT_1(dictionary[fieldName])) {
			NSDictionary * objDict		= dictionary[fieldName];
			
			self.model					= STRING_OR_NIL(objDict[@"model"]).lowercaseString;
			self.create					= [Utils numberFromString:objDict[@"create"]].unsignedIntegerValue;
			self.read					= [Utils numberFromString:objDict[@"read"]].unsignedIntegerValue;
			self.update					= [Utils numberFromString:objDict[@"update"]].unsignedIntegerValue;
			self.delete					= [Utils numberFromString:objDict[@"delete"]].unsignedIntegerValue;
		}
	}
}


#pragma mark - Public Methods

+ (nullable NSArray<PermissionModel *> *)permissionsFromData:(nullable id)data {
	if (!VALID_DICT_1(data) && !VALID_ARRAY_1(data))
		return nil;
	
	if (VALID_DICT_1(data)) {
		if (VALID_ARRAY_1(data[@"permissions"]))
			data					= data[@"permissions"];
		
		else
			data					= [NSArray arrayWithObject:data];
	}
	
	__autoreleasing NSMutableArray * result	= [NSMutableArray array];
	
	for (NSDictionary * item in data) {
		if (!VALID_DICT_1(item))
			continue;
		
		PermissionModel * permission			= [[PermissionModel alloc] initWithDictionary:item];
		
		if (permission)
			[result addObject:permission];
	}
	
	return result;
}


#pragma mark - Override

+ (nonnull NSString *)fieldName {
	return @"Permission";
}


+ (nonnull NSString *)modelName {
	return @"permissions";
}


@end