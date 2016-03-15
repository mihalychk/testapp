//
//  ValidationError.m
//  calories
//
//  Created by Michael on 07/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "ValidationError.h"
#import "Common.h"




@implementation ValidationError


#pragma mark - init & dealloc

- (void)updateWithDictionary:(nullable NSDictionary *)dictionary {
	[super updateWithDictionary:dictionary];
	
	if (VALID_DICT_1(dictionary)) {
		NSString * fieldName		= [[self class] fieldName];
		
		if (VALID_STRING_1(fieldName) && VALID_DICT_1(dictionary[fieldName])) {
			NSDictionary * objDict		= dictionary[fieldName];
			
			self.field					= objDict[@"field"];
			self.message				= objDict[@"message"];
		}
	}
}


#pragma mark - Public Methods

+ (nonnull NSString *)fieldName {
	return @"ValidationError";
}


+ (nonnull NSString *)modelName {
	return @"";
}


+ (nullable NSArray<ValidationError *> *)errorsFromData:(nullable id)data {
	if (!VALID_DICT_1(data) && !VALID_ARRAY_1(data))
		return nil;

	if (VALID_DICT_1(data)) {
		if (VALID_ARRAY_1(data[@"errors"]))
			data					= data[@"errors"];

		else
			data					= [NSArray arrayWithObject:data];
	}

	__autoreleasing NSMutableArray * result	= [NSMutableArray array];

	for (NSDictionary * item in data) {
		if (!VALID_DICT_1(item))
			continue;

		ValidationError * error					= [[ValidationError alloc] initWithDictionary:item];

		if (error)
			[result addObject:error];
	}

	return result;
}


#pragma mark - NSObject

- (NSString *)description {
	return FORMAT(@"{\n\tfield:\t%@\n\tmessage:\t\"%@\"\n}", self.field, self.message);
}


- (NSUInteger)hash {
	return self.field.hash + self.message.hash;
}


- (BOOL)isEqual:(id)object {
	if (object == self)
		return YES;
	
	if (![object isKindOfClass:[self class]])
		return NO;
	
	return [((ValidationError *)object).field.lowercaseString isEqualToString:self.field.lowercaseString] && [((ValidationError *)object).message.lowercaseString isEqualToString:self.message.lowercaseString];
}


@end