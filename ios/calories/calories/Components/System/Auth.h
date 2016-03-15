//
//  Auth.h
//  calories
//
//  Created by Home on 04/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseService.h"




@interface Auth : BaseService

+ (void)loginWithEmail:(nullable NSString *)email password:(nullable NSString *)password callback:(APIClientFormBlock)callback;
+ (void)registerWithEmail:(nullable NSString *)email name:(nullable NSString *)name password:(nullable NSString *)password callback:(APIClientFormBlock)callback;
+ (void)session:(APIClientModelBlock)callback;
+ (void)logout:(APIClientNoDataBlock)callback;

@end