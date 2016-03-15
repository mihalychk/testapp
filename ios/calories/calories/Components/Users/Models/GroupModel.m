//
//  GroupModel.m
//  calories
//
//  Created by Home on 05/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "GroupModel.h"
#import "Common.h"
#import "PermissionModel.h"
#import "Settings.h"
#import "UserModel.h"




@implementation GroupModel


#pragma mark - init & dealloc

- (nullable instancetype)copyWithZone:(nullable NSZone *)zone {
	GroupModel * copy			= [super copyWithZone:zone];
	
	if (copy) {
		copy.name					= [self.name copyWithZone:zone];
		copy.permissions			= [self.permissions copyWithZone:zone];
	}
	
	return copy;
}


- (void)updateWithDictionary:(nullable NSDictionary *)dictionary {
	[super updateWithDictionary:dictionary];

	if (VALID_DICT_1(dictionary)) {
		NSString * fieldName		= [[self class] fieldName];
		
		if (VALID_DICT_1(dictionary[fieldName])) {
			NSDictionary * objDict		= dictionary[fieldName];

			self.name					= STRING_OR_NIL(objDict[@"name"]);
			self.permissions			= [PermissionModel permissionsFromData:objDict[@"permissions"]];
		}
	}
}


- (void)updateWithModel:(nullable BaseModel *)model {
	if (!model || ![model isKindOfClass:[GroupModel class]])
		return;
	
	[super updateWithModel:model];

	self.name					= ((GroupModel *)model).name;
	self.permissions			= ((GroupModel *)model).permissions;
}


#pragma mark - Override

- (nullable NSDictionary *)toOutput {
	NSMutableDictionary * dict		= [NSMutableDictionary dictionary];
	NSString * fieldName			= [[self class] fieldName];
	
	if (VALID_STRING_1(fieldName)) {
		NSMutableDictionary * objDict	= [NSMutableDictionary dictionary];
		
		if (self.identifier)
			objDict[@"id"]					= self.identifier;
		
		if (self.name)
			objDict[@"name"]				= self.name;
		
		if (VALID_DICT_1(objDict))
			dict[fieldName]					= objDict;
	}
	
	return VALID_DICT_1(dict) ? dict : nil;
}


+ (nonnull NSString *)fieldName {
	return @"Group";
}


+ (nonnull NSString *)modelName {
	return @"groups";
}


#pragma mark - Access

+ (BOOL)canICreate {
	return NO;
}


+ (BOOL)canIList {
	switch ([SETTINGS.currentUser readAccessLevelForModel:GroupModel.modelName]) {
		case PermissionModelPermissionAllRecords:
			return YES;
			
		default:
			return NO;
	}
}


- (BOOL)canIRead {
	switch ([SETTINGS.currentUser readAccessLevelForModel:GroupModel.modelName]) {
		case PermissionModelPermissionAllRecords:
			return YES;
			
		case PermissionModelPermissionMyOwnRecords:
			return [self.identifier isEqualToNumber:SETTINGS.currentUser.group.identifier];
			
		default:
			return NO;
	}
}


- (BOOL)canIUpdate {
	return NO;
}


- (BOOL)canIDelete {
	return NO;
}


#pragma mark - NSObject

- (NSString *)description {
	return FORMAT(@"{\n\tid:\t\t%@,\n\tname:\t\t%@\n}", self.identifier, self.name);
}


@end