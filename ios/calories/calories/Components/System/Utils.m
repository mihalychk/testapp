//
//  Utils.m
//  calories
//
//  Created by Home on 04/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "Utils.h"
#import "Common.h"




@implementation Utils


#pragma mark - Formatters

static __strong NSNumberFormatter * numberFormatter			= nil;
static __strong NSDateFormatter   * dateFormatter			= nil;
static __strong NSDateFormatter   * dateGMTFormatter		= nil;
static __strong NSDateFormatter   * ISO8601DateFormatter	= nil;


+ (NSNumberFormatter *)numberFormatter {
	if (!numberFormatter) {
		numberFormatter						= [[NSNumberFormatter alloc] init];
		numberFormatter.numberStyle			= NSNumberFormatterDecimalStyle;
		numberFormatter.locale				= [NSLocale currentLocale];
		numberFormatter.decimalSeparator	= @".";
	}
	
	return numberFormatter;
}


+ (NSDateFormatter *)dateFormatter {
	if (dateFormatter == nil) {
		dateFormatter						= [[NSDateFormatter alloc] init];
		dateFormatter.locale				= [NSLocale currentLocale];
		dateFormatter.timeZone				= [NSTimeZone localTimeZone];
	}
	
	return dateFormatter;
}


+ (NSDateFormatter *)dateGMTFormatter {
	if (dateGMTFormatter == nil) {
		dateGMTFormatter					= [[NSDateFormatter alloc] init];
		dateGMTFormatter.locale				= [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
		dateGMTFormatter.timeZone			= [NSTimeZone timeZoneForSecondsFromGMT:0];
	}
	
	return dateGMTFormatter;
}


+ (NSDateFormatter *)ISO8601DateFormatter {
	if (ISO8601DateFormatter == nil) {
		ISO8601DateFormatter				= [[NSDateFormatter alloc] init];
		ISO8601DateFormatter.locale			= [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
		ISO8601DateFormatter.dateFormat		= @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
		ISO8601DateFormatter.timeZone		= [NSTimeZone timeZoneForSecondsFromGMT:0];
	}
	
	return ISO8601DateFormatter;
}


#pragma mark - NSDate

+ (nullable NSDate *)dateFromISO8601String:(nullable NSString *)string {
	return [[Utils ISO8601DateFormatter] dateFromString:string];
}


+ (nullable NSDate *)dateFromString:(nullable NSString *)string withFormat:(nullable NSString *)format {
	if (!VALID_STRING_1(string) || !VALID_STRING_1(format))
		return nil;
	
	[[Utils dateFormatter] setDateFormat:format];
	
	return [[Utils dateFormatter] dateFromString:string];
}


+ (nullable NSString *)stringFromISO8601Date:(nullable NSDate *)date {
	return [[Utils ISO8601DateFormatter] stringFromDate:date];
}


+ (nullable NSString *)stringFromGMTDate:(nullable NSDate *)date withFormat:(nullable NSString *)format {
	if (!VALID_DATE(date) || !VALID_STRING_1(format))
		return nil;
	
	[[Utils dateGMTFormatter] setDateFormat:format];
	
	return [[Utils dateGMTFormatter] stringFromDate:date];
}


+ (nullable NSString *)stringFromDate:(nullable NSDate *)date withFormat:(nullable NSString *)format {
	if (!VALID_DATE(date) || !VALID_STRING_1(format))
		return nil;
	
	[[Utils dateFormatter] setDateFormat:format];
	
	return [[Utils dateFormatter] stringFromDate:date];
}


+ (nullable NSDate *)trimSeconds:(nullable NSDate *)date {
	NSTimeInterval time		= floor(date.timeIntervalSinceReferenceDate / 60.0f) * 60.0f;

	return [NSDate dateWithTimeIntervalSinceReferenceDate:time];
}


+ (nullable NSDate *)setHours:(NSInteger)hours minutes:(NSInteger)minutes andSeconds:(NSInteger)seconds toDate:(nullable NSDate *)date {
	NSCalendar * calendar			= [NSCalendar currentCalendar];

	NSDateComponents * components	= [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
	components.hour					= hours;
	components.minute				= minutes;
	components.second				= seconds;

	return [calendar dateFromComponents:components];
}


+ (nullable NSDate *)setSeconds:(NSInteger)seconds toDate:(nullable NSDate *)date {
	NSCalendar * calendar			= [NSCalendar currentCalendar];
	
	NSDateComponents * components	= [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
	components.second				= seconds;
	
	return [calendar dateFromComponents:components];
}


#pragma mark - NSString

+ (NSNumber *)numberFromString:(id)string {
	if (VALID_NUMBER(string))
		return (NSNumber *)string;
	
	if (!VALID_STRING(string))
		return nil;

	string					= [string stringByReplacingOccurrencesOfString:@"," withString:@"."];
	
	return [[Utils numberFormatter] numberFromString:string];
}


+ (NSString *)trimString:(NSString *)string {
	if (!VALID_STRING_1(string))
		return nil;
	
	__autoreleasing NSString * result	= [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	return VALID_STRING_1(result) ? result : nil;
}


#pragma mark - NSError

+ (NSError *)errorWithCode:(NSUInteger)code reason:(NSString *)reason andDescription:(NSString *)description {
	NSMutableDictionary * dictionary	= [NSMutableDictionary dictionary];
	
	if (VALID_STRING_1(reason))
		[dictionary setObject:reason forKey:NSLocalizedFailureReasonErrorKey];
	
	if (VALID_STRING_1(description))
		[dictionary setObject:description forKey:NSLocalizedDescriptionKey];

	return [NSError errorWithDomain:[NSBundle mainBundle].bundleIdentifier code:code userInfo:dictionary];
}


@end