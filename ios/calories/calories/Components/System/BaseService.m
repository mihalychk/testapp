//
//  BaseService.m
//  calories
//
//  Created by Michael on 09/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseService.h"
#import "Predefined.h"
#import "Utils.h"
#import "BaseModel.h"
#import "ValidationError.h"
#import "Settings.h"




#define BASE_SERVICE_WRONG_RESPONSE			{ IN_MAINTHREAD(^{ if (callback) { callback(nil, [APIClient wrongResponseWithStatus:statusCode]); } }); }
#define BASE_SERVICE_HANDLE_UNAUTHORIZED	{ \
	switch (statusCode) { \
		case APIClientStatusUnauthorized: { \
			[BaseService notifyUnathorized]; \
			break; \
		} \
		default: { \
			IN_MAINTHREAD(^{ if (callback) { callback(nil, error); } }); \
			break; \
		} \
	} \
}




@implementation BaseService


#pragma mark - REST Methods

+ (void)create:(nullable BaseModel *)model callback:(APIClientFormBlock)callback {
	if (!SETTINGS.currentUser || ![[model class] canICreate]) {
		IN_MAINTHREAD(^{
			if (callback)
				callback(nil, nil, APIClient.forbidden);
		});
		
		return;
	}

	model.identifier			= nil;
	
	[API post:FORMAT(@"/%@", [[model class] modelName]) withParams:model.toOutput callback:[self callbackForFormRequest:^BaseModel * _Nullable(NSDictionary * _Nullable result) {
		[model updateWithDictionary:result];
		
		return model;
	} callback:callback]];
}


+ (void)read:(nullable BaseModel *)model callback:(APIClientModelBlock)callback {
	if (!SETTINGS.currentUser || !model.canIRead) {
		IN_MAINTHREAD(^{
			if (callback)
				callback(nil, APIClient.forbidden);
		});
		
		return;
	}

	[API get:FORMAT(@"/%@/%@", [[model class] modelName], model.identifier) withParams:nil callback:[self callbackForModelRequest:^BaseModel * _Nullable(NSDictionary * _Nullable result) {
		[model updateWithDictionary:result];
		
		return model;
	} callback:callback]];
}


+ (void)update:(nullable BaseModel *)model callback:(APIClientFormBlock)callback {
	if (!SETTINGS.currentUser || !model.canIUpdate) {
		IN_MAINTHREAD(^{
			if (callback)
				callback(nil, nil, APIClient.forbidden);
		});
		
		return;
	}

	[API put:FORMAT(@"/%@/%@", [[model class] modelName], model.identifier) withParams:model.toOutput callback:[self callbackForFormRequest:^BaseModel * _Nullable(NSDictionary * _Nullable result) {
		[model updateWithDictionary:result];
		
		return model;
	} callback:callback]];
}


+ (void)delete:(nullable BaseModel *)model callback:(APIClientNoDataBlock)callback {
	if (!SETTINGS.currentUser || !model.canIDelete) {
		IN_MAINTHREAD(^{
			if (callback)
				callback(APIClient.forbidden);
		});

		return;
	}

	[API delete:FORMAT(@"/%@/%@", [[model class] modelName], model.identifier) withParams:nil callback:[self callbackForNoDataRequest:nil callback:callback]];
}


+ (void)index:(Class)baseClass callback:(APIClientArrayBlock)callback {
	if (!SETTINGS.currentUser || ![baseClass canIList]) {
		IN_MAINTHREAD(^{
			if (callback)
				callback(nil, APIClient.forbidden);
		});
		
		return;
	}

	[API get:FORMAT(@"/%@", [baseClass modelName]) withParams:nil callback:[self callbackForArrayRequest:^NSArray<BaseModel *> * _Nullable(NSArray * _Nullable result) {
		NSMutableArray * array				= [NSMutableArray array];
		
		for (NSDictionary * item in result) {
			__strong typeof(baseClass) model	= [[baseClass alloc] initWithDictionary:item];
			
			if (model)
				[array addObject:model];
		}
		
		return array;
	} callback:callback]];
}


#pragma mark - Notifications

+ (void)notifyUnathorized {
	IN_MAINTHREAD(^{
		[[NSNotificationCenter defaultCenter] postNotificationName:API_UNAUTHORIZED_NOTIFICATION object:nil];
	});
}


#pragma mark - Handlers

+ (APIClientDataBlock)callbackForModelRequest:(BaseServiceModelHandler)handler callback:(APIClientModelBlock)callback {
	return ^(id _Nullable data, APIClientStatus statusCode, NSError * _Nullable error) {
		if (statusCode == APIClientStatusOK || statusCode == APIClientStatusCreated) {
			if (VALID_DICT_1(data[@"result"])) {
				IN_MAINTHREAD(^{
					if (callback) {
						if (handler)
							callback(handler(data[@"result"]), nil);
					}
				});
			}
			else
				BASE_SERVICE_WRONG_RESPONSE;
		}
		else
			BASE_SERVICE_HANDLE_UNAUTHORIZED;
	};
}


+ (APIClientDataBlock)callbackForArrayRequest:(BaseServiceArrayHandler)handler callback:(APIClientArrayBlock)callback {
	return ^(id _Nullable data, APIClientStatus statusCode, NSError * _Nullable error) {
		if (statusCode == APIClientStatusOK) {
			if (VALID_ARRAY(data[@"result"])) {
				IN_MAINTHREAD(^{
					if (callback) {
						if (handler)
							callback(handler(data[@"result"]), nil);
					}
				});
			}
			else
				BASE_SERVICE_WRONG_RESPONSE;
		}
		else
			BASE_SERVICE_HANDLE_UNAUTHORIZED;
	};
}


+ (APIClientDataBlock)callbackForNoDataRequest:(BaseServiceNoDataHandler)handler callback:(APIClientNoDataBlock)callback {
	return ^(id _Nullable data, APIClientStatus statusCode, NSError * _Nullable error) {
		if (statusCode == APIClientStatusNoContent) {
			IN_MAINTHREAD(^{
				if (handler)
					handler();

				if (callback)
					callback(error);
			});
		}
		else
			switch (statusCode) {
				case APIClientStatusUnauthorized: {
					[BaseService notifyUnathorized];
					
					break;
				}
		
				default: {
					IN_MAINTHREAD(^{
						if (callback)
							callback(error);
					});
					
					break;
				}
			}
	};
}


+ (APIClientDataBlock)callbackForFormRequest:(BaseServiceFormHandler)handler callback:(APIClientFormBlock)callback {
	return ^(id _Nullable data, APIClientStatus statusCode, NSError * _Nullable error) {
		if (statusCode == APIClientStatusOK || statusCode == APIClientStatusCreated) {
			if (VALID_DICT_1(data[@"result"])) {
				IN_MAINTHREAD(^{
					if (callback) {
						if (handler)
							callback(handler(data[@"result"]), nil, nil);
					}
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
					[BaseService notifyUnathorized];

					break;
				}
					
				case APIClientStatusBadRequest: {
					IN_MAINTHREAD(^{
						if (callback)
							callback(nil, [ValidationError errorsFromData:data], nil);
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


@end