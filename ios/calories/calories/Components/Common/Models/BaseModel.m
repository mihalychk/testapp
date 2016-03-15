//
//  BaseModel.m
//  calories
//
//  Created by Home on 04/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseModel.h"
#import "Common.h"
#import "Utils.h"
#import "Settings.h"
#import "UserModel.h"




@implementation BaseModel


#pragma mark - init & dealloc

- (nullable instancetype)copyWithZone:(nullable NSZone *)zone {
	BaseModel * copy		= [[[self class] alloc] init];

	if (copy)
		copy.identifier			= [self.identifier copyWithZone:zone];

	return copy;
}


- (void)updateWithDictionary:(NSDictionary *)dictionary {
	[super updateWithDictionary:dictionary];

	if (VALID_DICT_1(dictionary)) {
		NSString * fieldName		= [[self class] fieldName];
		
		if (VALID_STRING_1(fieldName) && VALID_DICT_1(dictionary[fieldName])) {
			NSDictionary * objDict		= dictionary[fieldName];
			
			self.identifier				= [Utils numberFromString:objDict[@"id"]];
		}
	}
}


- (void)updateWithModel:(nullable BaseModel *)model {
	if (!model || ![model isKindOfClass:[BaseModel class]])
		return;

	self.identifier					= model.identifier;
}


- (nullable NSDictionary *)toOutput {
	NSMutableDictionary * dict		= [NSMutableDictionary dictionary];
	NSString * fieldName			= [[self class] fieldName];

	if (VALID_STRING_1(fieldName)) {
		NSMutableDictionary * objDict	= [NSMutableDictionary dictionary];

		if (self.identifier)
			objDict[@"id"]					= self.identifier;

		if (VALID_DICT_1(objDict))
			dict[fieldName]					= objDict;
	}
	
	return VALID_DICT_1(dict) ? dict : nil;
}


#pragma mark - Access

+ (BOOL)canICreate {			// Default behavior for AllRecords access
	switch ([SETTINGS.currentUser createAccessLevelForModel:[self class].modelName]) {
		case PermissionModelPermissionAllRecords:
			return YES;
			
		default:
			return NO;
	}
}


+ (BOOL)canIList {				// Default behavior for AllRecords access
	switch ([SETTINGS.currentUser readAccessLevelForModel:[self class].modelName]) {
		case PermissionModelPermissionAllRecords:
			return YES;
			
		default:
			return NO;
	}
}


+ (BOOL)canIDo:(nullable NSString *)action item:(nullable BaseModel *)item {
	return NO;
}


- (BOOL)canIRead {
	return [[self class] canIDo:@"read" item:self];
}


- (BOOL)canIUpdate {
	return [[self class] canIDo:@"update" item:self];
}


- (BOOL)canIDelete {
	return [[self class] canIDo:@"delete" item:self];
}


#pragma mark - NSObject

- (NSString *)description {
	return FORMAT(@"{\n\tid :\t%@\n}", self.identifier);
}


- (NSUInteger)hash {
	return self.identifier.unsignedIntegerValue;
}


- (BOOL)isEqual:(id)object {
	if (object == self)
		return YES;

	if (![object isKindOfClass:[self class]])
		return NO;

	return [((BaseModel *)object).identifier isEqualToNumber:self.identifier];
}


@end