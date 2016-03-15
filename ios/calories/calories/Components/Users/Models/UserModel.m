//
//  UserModel.m
//  calories
//
//  Created by Home on 04/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "UserModel.h"
#import "Common.h"
#import "GroupModel.h"
#import "Settings.h"
#import "Utils.h"




@implementation UserModel


#pragma mark - init & dealloc

- (nullable instancetype)copyWithZone:(nullable NSZone *)zone {
	UserModel * copy		= [super copyWithZone:zone];

	if (copy) {
		copy.email				= [self.email copyWithZone:zone];
		copy.name				= [self.name copyWithZone:zone];
		copy.password			= [self.password copyWithZone:zone];
		copy.caloriesPerDay		= [self.caloriesPerDay copyWithZone:zone];
		copy.group				= self.group;
	}
	
	return copy;
}


- (void)updateWithDictionary:(nullable NSDictionary *)dictionary {
	[super updateWithDictionary:dictionary];

	if (VALID_DICT_1(dictionary)) {
		self.group					= [[GroupModel alloc] initWithDictionary:dictionary];
		NSString * fieldName		= [[self class] fieldName];
		
		if (VALID_DICT_1(dictionary[fieldName])) {
			NSDictionary * objDict		= dictionary[fieldName];
			
			self.email					= STRING_OR_NIL(objDict[@"email"]);
			self.name					= STRING_OR_NIL(objDict[@"name"]);
			self.caloriesPerDay			= [Utils numberFromString:objDict[@"calories_per_day"]];
		}
	}
}


- (void)updateWithModel:(nullable BaseModel *)model {
	if (!model || ![model isKindOfClass:[UserModel class]])
		return;

	[super updateWithModel:model];
	
	self.email					= ((UserModel *)model).email;
	self.name					= ((UserModel *)model).name;
	self.password				= ((UserModel *)model).password;
	self.caloriesPerDay			= ((UserModel *)model).caloriesPerDay;
	self.group					= ((UserModel *)model).group;
}


- (nullable NSDictionary *)toOutput {
	NSMutableDictionary * dict		= [NSMutableDictionary dictionary];
	NSString * fieldName			= [[self class] fieldName];
	
	if (VALID_STRING_1(fieldName)) {
		NSMutableDictionary * objDict	= [NSMutableDictionary dictionary];
		
		if (VALID_UINT_1(self.identifier))
			objDict[@"id"]					= self.identifier;
		
		if (VALID_UINT_1(self.group.identifier))
			objDict[@"group_id"]			= self.group.identifier;
		
		if (VALID_STRING_1(self.email))
			objDict[@"email"]				= self.email;
		
		if (VALID_STRING_1(self.name))
			objDict[@"name"]				= self.name;
		
		if (VALID_STRING_1(self.password))
			objDict[@"password"]			= self.password;
		
		if (VALID_NUMBER(self.caloriesPerDay))
			objDict[@"calories_per_day"]	= self.caloriesPerDay;
		
		if (VALID_DICT_1(objDict))
			dict[fieldName]					= objDict;
	}
	
	return VALID_DICT_1(dict) ? dict : nil;
}


#pragma mark - Public Methods

- (PermissionModelPermission)accessLevelForModel:(nullable NSString *)model byAction:(nullable NSString *)action {
	if (!VALID_STRING_1(model) || !VALID_STRING_1(action) || !self.group || !VALID_ARRAY_1(self.group.permissions))
		return PermissionModelPermissionNoAccess;
	
	PermissionModelPermission result	= PermissionModelPermissionNoAccess;
	model								= model.lowercaseString;
	action								= action.lowercaseString;
	
	for (PermissionModel * permission in self.group.permissions)
		if ([permission.model isEqualToString:model] || [permission.model isEqualToString:@"*"]) {
			NSUInteger value					= [[permission valueForKey:action] unsignedIntegerValue];
			result								= value > result ? value : result;
		}
	
	return result;
}


#pragma mark - Permissions for User

- (PermissionModelPermission)createAccessLevelForModel:(nullable NSString *)model {
	return [self accessLevelForModel:model byAction:@"create"];
}


- (PermissionModelPermission)readAccessLevelForModel:(nullable NSString *)model {
	return [self accessLevelForModel:model byAction:@"read"];
}


- (PermissionModelPermission)updateAccessLevelForModel:(nullable NSString *)model {
	return [self accessLevelForModel:model byAction:@"update"];
}


- (PermissionModelPermission)deleteAccessLevelForModel:(nullable NSString *)model {
	return [self accessLevelForModel:model byAction:@"delete"];
}


#pragma mark - Access

+ (BOOL)canIDo:(nullable NSString *)action item:(nullable BaseModel *)item {
	if (!VALID_STRING_1(action) || !item || ![item isKindOfClass:[UserModel class]])
		return NO;
	
	switch ([SETTINGS.currentUser accessLevelForModel:UserModel.modelName byAction:action]) {
		case PermissionModelPermissionAllRecords:
			return YES;
			
		case PermissionModelPermissionMyOwnRecords:
			return [item.identifier isEqualToNumber:SETTINGS.currentUser.identifier];
			
		default:
			return NO;
	}
}


- (BOOL)canIDelete {
	switch ([SETTINGS.currentUser deleteAccessLevelForModel:UserModel.modelName]) {
		case PermissionModelPermissionAllRecords:
			return ![self.identifier isEqualToNumber:SETTINGS.currentUser.identifier];

		default:
			return NO;
	}
}


#pragma mark - Override

+ (nonnull NSString *)fieldName {
	return @"User";
}


+ (nonnull NSString *)modelName {
	return @"users";
}


#pragma mark - NSObject

- (NSString *)description {
	return FORMAT(@"{\n\tid:\t\t%@,\n\temail:\t%@,\n\tpassword:\t%@,\n\tname:\t\t%@\n}", self.identifier, self.email, self.password, self.name);
}


@end