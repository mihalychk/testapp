//
//  Settings.h
//  calories
//
//  Created by Home on 04/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import <Foundation/Foundation.h>




typedef NS_ENUM(NSInteger, SettingsKey) {
	SettingsKeyEmail	= 0,
	SettingsKeyPassword,
	SettingsKeyAuthToken,
	SettingsKeyTimeFrom,
	SettingsKeyTimeTo,
	SettingsKeyDateFrom,
	SettingsKeyDateTo,
};




@class UserModel;




@interface Settings : NSObject

@property (nonatomic, nullable, copy)   NSString  * email;
@property (nonatomic, nullable, copy)   NSString  * password;
@property (nonatomic, nullable, copy)   NSString  * authToken;
@property (nonatomic, nullable, strong) UserModel * currentUser;

@property (nonatomic, nullable, copy)   NSDate    * timeFrom;
@property (nonatomic, nullable, copy)   NSDate    * timeTo;
@property (nonatomic, nullable, copy)   NSDate    * dateFrom;
@property (nonatomic, nullable, copy)   NSDate    * dateTo;

@property (nonatomic, readonly) BOOL hasToken;

+ (nonnull instancetype)sharedSettings;

- (void)setValue:(nullable id)value forKey:(SettingsKey)key;
- (nullable id)valueForKey:(SettingsKey)key;

- (void)clearSession:(BOOL)onLogout;

@end




#define SETTINGS ([Settings sharedSettings])