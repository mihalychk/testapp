//
//  RecordModel.m
//  calories
//
//  Created by Michael on 07/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "RecordModel.h"
#import "Common.h"
#import "Settings.h"
#import "UserModel.h"
#import "Utils.h"




@implementation RecordModel


#pragma mark - init & dealloc

- (nullable instancetype)copyWithZone:(nullable NSZone *)zone {
	RecordModel * copy		= [super copyWithZone:zone];
	
	if (copy) {
		copy.text				= [self.text copyWithZone:zone];
		copy.userId				= [self.userId copyWithZone:zone];
		copy.calories			= [self.calories copyWithZone:zone];
		copy.datetime			= [self.datetime copyWithZone:zone];
		copy.user				= self.user;
	}
	
	return copy;
}


- (void)updateWithDictionary:(nullable NSDictionary *)dictionary {
	[super updateWithDictionary:dictionary];
	
	if (VALID_DICT_1(dictionary)) {
		self.user					= [[UserModel alloc] initWithDictionary:dictionary];
		NSString * fieldName		= [[self class] fieldName];
		
		if (VALID_DICT_1(dictionary[fieldName])) {
			NSDictionary * objDict		= dictionary[fieldName];

			self.text					= STRING_OR_NIL(objDict[@"text"]);
			self.userId					= [Utils numberFromString:objDict[@"user_id"]];
			self.calories				= [Utils numberFromString:objDict[@"calories"]];
			self.datetime				= [Utils dateFromISO8601String:objDict[@"datetime"]];
		}
	}
}


- (void)updateWithModel:(nullable BaseModel *)model {
	if (!model || ![model isKindOfClass:[RecordModel class]])
		return;
	
	[super updateWithModel:model];

	self.text					= ((RecordModel *)model).text;
	self.userId					= ((RecordModel *)model).userId;
	self.calories				= ((RecordModel *)model).calories;
	self.datetime				= ((RecordModel *)model).datetime;
	self.user					= ((RecordModel *)model).user;
}


- (nullable NSDictionary *)toOutput {
	NSMutableDictionary * dict		= [NSMutableDictionary dictionary];
	NSString * fieldName			= [[self class] fieldName];
	
	if (VALID_STRING_1(fieldName)) {
		NSMutableDictionary * objDict	= [NSMutableDictionary dictionary];
		
		if (VALID_UINT_1(self.identifier))
			objDict[@"id"]					= self.identifier;
		
		if (VALID_STRING_1(self.text))
			objDict[@"text"]				= self.text;
		
		if (VALID_NUMBER(self.calories))
			objDict[@"calories"]			= self.calories;
		
		if (VALID_DATE(self.datetime))
			objDict[@"datetime"]			= [Utils stringFromISO8601Date:self.datetime];
		
		if (VALID_DICT_1(objDict))
			dict[fieldName]					= objDict;
	}
	
	return VALID_DICT_1(dict) ? dict : nil;
}


#pragma mark - Access

+ (BOOL)canIDo:(nullable NSString *)action item:(nullable BaseModel *)item {
	if (!VALID_STRING_1(action) || !item || ![item isKindOfClass:[RecordModel class]])
		return NO;
	
	switch ([SETTINGS.currentUser accessLevelForModel:RecordModel.modelName byAction:action]) {
		case PermissionModelPermissionAllRecords:
			return YES;
			
		case PermissionModelPermissionMyOwnRecords:
			return [((RecordModel *)item).userId isEqualToNumber:SETTINGS.currentUser.identifier];
			
		default:
			return NO;
	}
}


+ (BOOL)canICreate {
	switch ([SETTINGS.currentUser createAccessLevelForModel:RecordModel.modelName]) {
		case PermissionModelPermissionMyOwnRecords:
		case PermissionModelPermissionAllRecords:
			return YES;
			
		default:
			return NO;
	}
}


+ (BOOL)canIList {
	switch ([SETTINGS.currentUser readAccessLevelForModel:RecordModel.modelName]) {
		case PermissionModelPermissionAllRecords:
		case PermissionModelPermissionMyOwnRecords:
			return YES;
			
		default:
			return NO;
	}
}


#pragma mark - Override

+ (nonnull NSString *)fieldName {
	return @"Record";
}


+ (nonnull NSString *)modelName {
	return @"records";
}


@end