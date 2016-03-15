//
//  Records.m
//  calories
//
//  Created by Michael on 11/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "Records.h"
#import "Common.h"
#import "Utils.h"
#import "Settings.h"
#import "RecordModel.h"




@implementation Records


+ (void)index:(Class)baseClass callback:(APIClientArrayBlock)callback {
	if (!SETTINGS.currentUser || ![baseClass canIList]) {
		IN_MAINTHREAD(^{
			if (callback)
				callback(nil, APIClient.forbidden);
		});
		
		return;
	}

	NSMutableDictionary * params		= [NSMutableDictionary dictionary];
	
	if (VALID_DATE(SETTINGS.timeFrom))
		params[@"time_from"]				= [Utils stringFromGMTDate:SETTINGS.timeFrom withFormat:APIClient.shortTimeFormat];
	
	if (VALID_DATE(SETTINGS.timeTo))
		params[@"time_to"]					= [Utils stringFromGMTDate:SETTINGS.timeTo withFormat:APIClient.shortTimeFormat];
	
	if (VALID_DATE(SETTINGS.dateFrom))
		params[@"date_from"]				= [Utils stringFromISO8601Date:SETTINGS.dateFrom];
	
	if (VALID_DATE(SETTINGS.dateTo))
		params[@"date_to"]					= [Utils stringFromISO8601Date:SETTINGS.dateTo];
	
	[API get:FORMAT(@"/%@", [baseClass modelName]) withParams:params callback:[self callbackForArrayRequest:^NSArray<BaseModel *> * _Nullable(NSArray * _Nullable result) {
		NSMutableArray * array				= [NSMutableArray array];
		
		for (NSDictionary * item in result) {
			__strong typeof(baseClass) model	= [[baseClass alloc] initWithDictionary:item];
			
			if (model)
				[array addObject:model];
		}
		
		return array;
	} callback:callback]];
}


@end