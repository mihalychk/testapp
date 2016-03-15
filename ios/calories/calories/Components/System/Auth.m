//
//  Auth.m
//  calories
//
//  Created by Home on 04/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "Auth.h"
#import "Common.h"
#import "UserModel.h"
#import "Settings.h"
#import "Utils.h"
#import "ValidationError.h"




@implementation Auth


#pragma mark -

+ (void(^)(id _Nullable data, APIClientStatus statusCode, NSError * _Nullable error))callbackForLoginRegister:(APIClientFormBlock)callback {
	return ^(id _Nullable data, APIClientStatus statusCode, NSError * _Nullable error) {
		if (statusCode == APIClientStatusOK) {
			if (VALID_DICT_1(data[@"result"])) {
				UserModel * user				= [[UserModel alloc] initWithDictionary:data[@"result"]];

				[SETTINGS clearSession:NO];

				if (VALID_NUMBER(user.identifier))
					SETTINGS.currentUser			= user;
				
				if (VALID_STRING_1(data[@"result"][@"auth_token"]))
					SETTINGS.authToken				= data[@"result"][@"auth_token"];

				IN_MAINTHREAD(^{
					if (callback)
						callback(user, nil, nil);
				});
			}
			else
				IN_MAINTHREAD(^{
					if (callback)
						callback(nil, nil, [APIClient wrongResponseWithStatus:statusCode]);
				});
		}
		else
			switch (statusCode) {
				case APIClientStatusUnauthorized: {
					IN_MAINTHREAD(^{
						if (callback)
							callback(nil, nil, [Utils errorWithCode:statusCode reason:NSLocalizedString(@"Authorization Error", nil) andDescription:NSLocalizedString(@"Wrong Email or Password", nil)]);
					});

					break;
				}

				case APIClientStatusBadRequest: {
					IN_MAINTHREAD(^{
						if (callback)
							callback(nil, [ValidationError errorsFromData:data], error);
					});
					
					break;
				}
					
				default: {
					IN_MAINTHREAD(^{
						if (callback)
							callback(nil, nil, error);
					});
					
					break;
				}
			}
	};
}


#pragma mark - 

+ (void)loginWithEmail:(nullable NSString *)email password:(nullable NSString *)password callback:(APIClientFormBlock)callback {
	NSMutableDictionary * params	= [NSMutableDictionary dictionary];
	
	if (VALID_STRING_1(email))
		params[@"email"]				= email;
	
	if (VALID_STRING_1(password))
		params[@"password"]				= password;

	[API post:@"/auth" withParams:params callback:[self callbackForLoginRegister:callback]];
}


+ (void)registerWithEmail:(nullable NSString *)email name:(nullable NSString *)name password:(nullable NSString *)password callback:(APIClientFormBlock)callback {
	NSMutableDictionary * params	= [NSMutableDictionary dictionary];
	
	if (VALID_STRING_1(email))
		params[@"email"]				= email;
	
	if (VALID_STRING_1(name))
		params[@"name"]					= name;
	
	if (VALID_STRING_1(password))
		params[@"password"]				= password;
	
	[API post:@"/auth/new" withParams:params callback:[self callbackForLoginRegister:callback]];
	
}


+ (void)session:(APIClientModelBlock)callback {
	[API get:@"/auth" withParams:nil callback:[self callbackForModelRequest:^BaseModel * _Nullable(NSDictionary * _Nullable result) {
		UserModel * user				= [[UserModel alloc] initWithDictionary:result];
		
		if (VALID_NUMBER(user.identifier))
			SETTINGS.currentUser			= user;

		return user;
	} callback:callback]];
}


+ (void)logout:(APIClientNoDataBlock)callback {
	[API delete:@"/auth" withParams:nil callback:[self callbackForNoDataRequest:^{
		[SETTINGS clearSession:YES];
	} callback:callback]];
}


@end