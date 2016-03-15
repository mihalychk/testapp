//
//  APIClient.h
//  calories
//
//  Created by Home on 04/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import <Foundation/Foundation.h>




typedef NS_ENUM(NSUInteger, APIClientStatus) {
	APIClientStatusSystemError			= 0,
	APIClientStatusOK					= 200,
	APIClientStatusCreated				= 201,
	APIClientStatusAccepted				= 202,
	APIClientStatusNoContent			= 204,
	APIClientStatusNotModified			= 304,
	APIClientStatusBadRequest			= 400,
	APIClientStatusUnauthorized			= 401,
	APIClientStatusForbidden			= 403,
	APIClientStatusNotFound				= 404,
	APIClientStatusInternalServerError	= 500
};




@class ValidationError, BaseModel;




typedef void(^__nullable APIClientDataBlock)(id _Nullable data, APIClientStatus statusCode, NSError * _Nullable error);
typedef void(^__nullable APIClientModelBlock)(BaseModel * _Nullable model, NSError * _Nullable error);
typedef void(^__nullable APIClientArrayBlock)(NSArray<BaseModel *> * _Nullable array, NSError * _Nullable error);
typedef void(^__nullable APIClientFormBlock)(BaseModel * _Nullable model, NSArray<ValidationError *> * _Nullable validationErrors, NSError * _Nullable error);
typedef void(^__nullable APIClientNoDataBlock)(NSError * _Nullable error);




@interface APIClient : NSObject

+ (nonnull instancetype)sharedClient;

- (void)get:(nullable NSString *)urlString withParams:(nullable NSDictionary *)params callback:(APIClientDataBlock)callback;
- (void)post:(nullable NSString *)urlString withParams:(nullable NSDictionary *)params callback:(APIClientDataBlock)callback;
- (void)put:(nullable NSString *)urlString withParams:(nullable NSDictionary *)params callback:(APIClientDataBlock)callback;
- (void)delete:(nullable NSString *)urlString withParams:(nullable NSDictionary *)params callback:(APIClientDataBlock)callback;

+ (nonnull NSError *)wrongResponseWithStatus:(APIClientStatus)status;
+ (nonnull NSError *)unauthorized;
+ (nonnull NSError *)forbidden;
+ (nonnull NSError *)unknownErrorWithStatus:(APIClientStatus)status;

+ (nonnull NSString *)shortTimeFormat;

@end




#define API ([APIClient sharedClient])