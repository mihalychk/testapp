//
//  BaseService.h
//  calories
//
//  Created by Michael on 09/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "APIClient.h"




typedef NSArray<BaseModel *> * _Nullable (^__nullable BaseServiceArrayHandler)(NSArray * _Nullable result);
typedef BaseModel * _Nullable (^__nullable BaseServiceModelHandler)(NSDictionary * _Nullable result);
typedef BaseModel * _Nullable (^__nullable BaseServiceFormHandler)(NSDictionary * _Nullable result);
typedef void(^__nullable BaseServiceNoDataHandler)(void);




@interface BaseService : NSObject

+ (void)create:(nullable BaseModel *)model callback:(APIClientFormBlock)callback;
+ (void)read:(nullable BaseModel *)model callback:(APIClientModelBlock)callback;
+ (void)update:(nullable BaseModel *)model callback:(APIClientFormBlock)callback;
+ (void)delete:(nullable BaseModel *)model callback:(APIClientNoDataBlock)callback;
+ (void)index:(nonnull Class)baseClass callback:(APIClientArrayBlock)callback;

+ (void)notifyUnathorized;

+ (APIClientDataBlock)callbackForModelRequest:(BaseServiceModelHandler)handler callback:(APIClientModelBlock)callback;
+ (APIClientDataBlock)callbackForFormRequest:(BaseServiceFormHandler)handler callback:(APIClientFormBlock)callback;
+ (APIClientDataBlock)callbackForNoDataRequest:(BaseServiceNoDataHandler)handler callback:(APIClientNoDataBlock)callback;
+ (APIClientDataBlock)callbackForArrayRequest:(BaseServiceArrayHandler)handler callback:(APIClientArrayBlock)callback;

@end