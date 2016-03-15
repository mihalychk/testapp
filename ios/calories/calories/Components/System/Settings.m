//
//  Settings.m
//  calories
//
//  Created by Home on 04/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "Settings.h"
#import "Common.h"
#import "Lockbox.h"




#define GET_VALUE(key)			[[NSUserDefaults standardUserDefaults] objectForKey:key]
#define SET_VALUE(key,value)	{ [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]; }
#define STR_KEY(enumValue)		[storeKeys objectAtIndex:enumValue]
#define DICT_KEY(dict, key)		[dict objectForKey:STR_KEY(key)]




@interface Settings () {
	__strong NSArray  * storeKeys;
	__strong NSString * cachedEmail;
	__strong NSString * cachedPassword;
	__strong NSString * cachedAuthToken;
}

@property (nonatomic, readonly) Lockbox * lockbox;

@property (nonatomic, nullable, copy) NSString * cachedEmail;
@property (nonatomic, nullable, copy) NSString * cachedPassword;
@property (nonatomic, nullable, copy) NSString * cachedAuthToken;

@end




@implementation Settings


@synthesize cachedEmail, cachedPassword, cachedAuthToken;


#pragma mark - init & dealloc

- (nonnull instancetype)init {
	if ((self = [super init])) {
		storeKeys					= @[
										@"email",
										@"password",
										@"authtoken",
										@"time_from",
										@"time_to",
										@"date_from",
										@"date_to"
										];

		__strong Lockbox * lockbox	= self.lockbox;

		self.cachedEmail			= [lockbox unarchiveObjectForKey:STR_KEY(SettingsKeyEmail)];
		self.cachedPassword			= [lockbox unarchiveObjectForKey:STR_KEY(SettingsKeyPassword)];
		self.cachedAuthToken		= [lockbox unarchiveObjectForKey:STR_KEY(SettingsKeyAuthToken)];
	}

	return self;
}


#pragma mark - Getters & Setters

- (Lockbox *)lockbox {
	__autoreleasing Lockbox * lockbox	= [[Lockbox alloc] initWithKeyPrefix:[NSBundle mainBundle].bundleIdentifier];
	
	return lockbox;
}


#pragma mark - Auth

- (void)setEmail:(nullable NSString *)email {
	[self setValue:email forKey:SettingsKeyEmail];
}


- (nullable NSString *)email {
	return [self valueForKey:SettingsKeyEmail];
}


- (void)setPassword:(nullable NSString *)password {
	[self setValue:password forKey:SettingsKeyPassword];
}


- (nullable NSString *)password {
	return [self valueForKey:SettingsKeyPassword];
}


- (void)setAuthToken:(nullable NSString *)authToken {
	[self setValue:authToken forKey:SettingsKeyAuthToken];
}


- (nullable NSString *)authToken {
	return [self valueForKey:SettingsKeyAuthToken];
}


- (BOOL)hasToken {
	return VALID_STRING_1(self.authToken);
}


#pragma mark - Filter

- (void)setTimeFrom:(NSDate *)timeFrom {
	[self setValue:timeFrom forKey:SettingsKeyTimeFrom];
}


- (void)setTimeTo:(NSDate *)timeTo {
	[self setValue:timeTo forKey:SettingsKeyTimeTo];
}


- (void)setDateFrom:(NSDate *)dateFrom {
	[self setValue:dateFrom forKey:SettingsKeyDateFrom];
}


- (void)setDateTo:(NSDate *)dateTo {
	[self setValue:dateTo forKey:SettingsKeyDateTo];
}


- (NSDate *)timeFrom {
	return [self valueForKey:SettingsKeyTimeFrom];
}


- (NSDate *)timeTo {
	return [self valueForKey:SettingsKeyTimeTo];
}


- (NSDate *)dateFrom {
	return [self valueForKey:SettingsKeyDateFrom];
}


- (NSDate *)dateTo {
	return [self valueForKey:SettingsKeyDateTo];
}


#pragma mark - Public Methods

- (void)setValue:(nullable id)value forKey:(SettingsKey)key {
	switch (key) {
		case SettingsKeyEmail: {
			self.cachedEmail		= value;
			
			[self.lockbox archiveObject:value forKey:STR_KEY(SettingsKeyEmail) accessibility:kSecAttrAccessibleAfterFirstUnlock];
			
			break;
		}
			
		case SettingsKeyPassword: {
			self.cachedPassword		= value;
			
			[self.lockbox archiveObject:value forKey:STR_KEY(SettingsKeyPassword) accessibility:kSecAttrAccessibleAfterFirstUnlock];
			
			break;
		}
			
		case SettingsKeyAuthToken: {
			self.cachedAuthToken	= value;
			
			[self.lockbox archiveObject:value forKey:STR_KEY(SettingsKeyAuthToken) accessibility:kSecAttrAccessibleAfterFirstUnlock];
			
			break;
		}
			
		default:
			SET_VALUE(STR_KEY(key), value);
			
			break;
	}
}


- (nullable id)valueForKey:(SettingsKey)key {
	switch (key) {
		case SettingsKeyEmail: {
			if (!cachedEmail)
				self.cachedEmail		= [self.lockbox unarchiveObjectForKey:STR_KEY(SettingsKeyEmail)];
			
			return cachedEmail;
		}
			
		case SettingsKeyPassword: {
			if (!cachedPassword)
				self.cachedPassword		= [self.lockbox unarchiveObjectForKey:STR_KEY(SettingsKeyPassword)];
			
			return cachedPassword;
		}
			
		case SettingsKeyAuthToken: {
			if (!cachedAuthToken)
				self.cachedAuthToken	= [self.lockbox unarchiveObjectForKey:STR_KEY(SettingsKeyAuthToken)];
			
			return cachedAuthToken;
		}
			
		default:
			return GET_VALUE(STR_KEY(key));
	}
}


- (void)clearSession:(BOOL)onLogout {
	if (onLogout) {
		self.email				= nil;
		self.password			= nil;
	}

	self.authToken			= nil;
	self.currentUser		= nil;

	self.timeFrom			= nil;
	self.timeTo				= nil;
	self.dateFrom			= nil;
	self.dateTo				= nil;
}


#pragma mark - Singleton

+ (nonnull instancetype)sharedSettings {
	static Settings * sharedSettings	= nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedSettings						= [[Settings alloc] init];
	});
	
	return sharedSettings;
}


@end