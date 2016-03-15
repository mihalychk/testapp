//
//  Utils.h
//  calories
//
//  Created by Home on 04/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import <Foundation/Foundation.h>




@interface Utils : NSObject

+ (nullable NSDate *)dateFromISO8601String:(nullable NSString *)string;
+ (nullable NSDate *)dateFromString:(nullable NSString *)string withFormat:(nullable NSString *)format;
+ (nullable NSString *)stringFromISO8601Date:(nullable NSDate *)date;
+ (nullable NSString *)stringFromGMTDate:(nullable NSDate *)date withFormat:(nullable NSString *)format;
+ (nullable NSString *)stringFromDate:(nullable NSDate *)date withFormat:(nullable NSString *)format;
+ (nullable NSDate *)trimSeconds:(nullable NSDate *)date;
+ (nullable NSDate *)setHours:(NSInteger)hours minutes:(NSInteger)minutes andSeconds:(NSInteger)seconds toDate:(nullable NSDate *)date;
+ (nullable NSDate *)setSeconds:(NSInteger)seconds toDate:(nullable NSDate *)date;

+ (nullable NSNumber *)numberFromString:(nullable id)string;
+ (nullable NSString *)trimString:(nullable NSString *)string;

+ (nullable NSError *)errorWithCode:(NSUInteger)code reason:(nullable NSString *)reason andDescription:(nullable NSString *)description;

@end