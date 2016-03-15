//
//  APIClient.m
//  calories
//
//  Created by Home on 04/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "APIClient.h"
#import "Predefined.h"
#import "Settings.h"
#import "Utils.h"




@interface APIClient () {
	__strong NSOperationQueue * mainQueue;
}

@end




@implementation APIClient


#pragma mark - init & dealloc

- (nonnull instancetype)init {
	if ((self = [super init])) {
		mainQueue								= [[NSOperationQueue alloc] init];
		mainQueue.maxConcurrentOperationCount	= 1;
	}

	return self;
}


#pragma mark - Public Methods

- (void)get:(nullable NSString *)urlString withParams:(nullable NSDictionary *)params callback:(APIClientDataBlock)callback {
	[self addRequestWithURLString:urlString withMethod:@"GET" andParams:params callback:callback];
}


- (void)post:(nullable NSString *)urlString withParams:(nullable NSDictionary *)params callback:(APIClientDataBlock)callback {
	[self addRequestWithURLString:urlString withMethod:@"POST" andParams:params callback:callback];
}


- (void)put:(nullable NSString *)urlString withParams:(nullable NSDictionary *)params callback:(APIClientDataBlock)callback {
	[self addRequestWithURLString:urlString withMethod:@"PUT" andParams:params callback:callback];
}


- (void)delete:(nullable NSString *)urlString withParams:(nullable NSDictionary *)params callback:(APIClientDataBlock)callback {
	[self addRequestWithURLString:urlString withMethod:@"DELETE" andParams:params callback:callback];
}


#pragma mark -

- (NSString *)plainParams:(NSDictionary *)params {
	NSMutableArray * array			= [NSMutableArray array];
	
	[params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
		NSString * value				= nil;
		
		if (VALID_STRING_1(obj))
			value							= obj;
		
		else if (VALID_NUMBER(obj))
			value							= ((NSNumber *)obj).stringValue;
		
		else if (VALID_DATE(obj))
			value							= [Utils stringFromISO8601Date:obj];
		
		else
			value							= [obj description];
		
		[array addObject:FORMAT(@"%@=%@", key, value)];
	}];

	return [array componentsJoinedByString:@"&"];
}


#pragma mark -

- (void)addRequestWithURLString:(nullable NSString *)urlString withMethod:(nullable NSString *)method andParams:(nullable NSDictionary *)params callback:(APIClientDataBlock)callback {
	LOG(@"Request: %@ %@%@", method, API_CLIENT_URL, urlString);
	
	NSMutableString * additional	= [NSMutableString string];
	
	if (SETTINGS.hasToken)
		[additional appendFormat:@"?auth_token=%@", SETTINGS.authToken];

	if ([method isEqualToString:@"GET"] && VALID_DICT_1(params)) {
		NSString * plainParams			= [self plainParams:params];

		if (VALID_STRING_1(plainParams))
			[additional appendFormat:@"&%@", plainParams];
	}

	LOG(@"URL: %@", URLXFORMAT(@"%@%@%@", API_CLIENT_URL, urlString, additional));

	NSMutableURLRequest * request	= [NSMutableURLRequest requestWithURL:URLXFORMAT(@"%@%@%@", API_CLIENT_URL, urlString, additional) cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:API_CLIENT_REQUEST_TIMEOUT];
	request.HTTPMethod				= method;
	
	if (![method isEqualToString:@"GET"] && VALID_DICT_1(params)) {
		NSError * error					= nil;
		NSData * jsonData				= [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
		
		if (error) {
			if (callback)
				callback(nil, APIClientStatusSystemError, error);

			return;
		}
		
		request.HTTPBody				= jsonData;
	}
	
	[self addRequest:request withCallback:callback];
}


- (void)addRequest:(nullable NSURLRequest *)request withCallback:(APIClientDataBlock)callback {
	if (!request)
		return;

	WEAK(self);

	[mainQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
		dispatch_semaphore_t condition	= dispatch_semaphore_create(0);

		[[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
			APIClientStatus statusCode		= APIClientStatusSystemError;
			
			if ([response isKindOfClass:[NSHTTPURLResponse class]])
				statusCode						= ((NSHTTPURLResponse *)response).statusCode;
			
			NSError * parsedError			= nil;
			NSDictionary * parsedData		= nil;

			if (VALID_DATA_1(data))
				parsedData						= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parsedError];

			if (parsedError) {
				WLOG(@"Status 1: %@. Error: %@, %@", @(statusCode), parsedError.localizedFailureReason, parsedError.localizedDescription);

				if (callback)
					callback(parsedData, statusCode, parsedError);
			}
			else {
				if (error) {
					WLOG(@"Status 2: %@. Error: %@, %@", @(statusCode), error.localizedFailureReason, error.localizedDescription);
					
					if (callback)
						callback(parsedData, statusCode, error);
				}
				else {
					if (statusCode < APIClientStatusOK || statusCode >= 300) {
						NSError * error				= [Utils errorWithCode:statusCode reason:NSLocalizedString(@"Server Response", nil) andDescription:NSLocalizedString(@"HTTP Request Error", nil)];

						WLOG(@"Status 3: %@. Error: %@, %@", @(statusCode), error.localizedFailureReason, error.localizedDescription);
						
						if (callback)
							callback(parsedData, statusCode, error);
					}
					else {
						WLOG(@"Status: %@.", @(statusCode));
						
						if (callback)
							callback(parsedData, statusCode, nil);
					}
				}
			}

			dispatch_semaphore_signal(condition);
		}] resume];

		dispatch_semaphore_wait(condition, DISPATCH_TIME_FOREVER);
	}]];
}


#pragma mark - Errors

+ (nonnull NSError *)serverResponseWithDescription:(nullable NSString *)description andStatus:(APIClientStatus)status {
	return [Utils errorWithCode:status reason:NSLocalizedString(@"Server Response", nil) andDescription:description];
}


+ (nonnull NSError *)wrongResponseWithStatus:(APIClientStatus)status {
	return [APIClient serverResponseWithDescription:NSLocalizedString(@"Wrong Response", nil) andStatus:status];
}


+ (nonnull NSError *)unauthorized {
	return [APIClient serverResponseWithDescription:NSLocalizedString(@"Unauthorized", nil) andStatus:APIClientStatusUnauthorized];
}


+ (nonnull NSError *)forbidden {
	return [Utils errorWithCode:APIClientStatusForbidden reason:NSLocalizedString(@"System Error", nil) andDescription:NSLocalizedString(@"You have no rights", nil)];
}


+ (nonnull NSError *)unknownErrorWithStatus:(APIClientStatus)status {
	return [APIClient serverResponseWithDescription:NSLocalizedString(@"Unknown Error", nil) andStatus:status];
}


+ (nonnull NSString *)shortTimeFormat {
	return @"HH:mm";
}


#pragma mark - Singleton

+ (nonnull instancetype)sharedClient {
	static APIClient * sharedClient	= nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		sharedClient					= [[APIClient alloc] init];
	});
	
	return sharedClient;
}


@end