//
//  BaseModel.h
//  calories
//
//  Created by Home on 04/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "Model.h"




@interface BaseModel : Model

@property (nonatomic, nullable, copy) NSNumber * identifier;

- (nullable instancetype)copyWithZone:(nullable NSZone *)zone;
- (void)updateWithModel:(nullable BaseModel *)model;
- (nullable NSDictionary *)toOutput;

+ (BOOL)canICreate;
+ (BOOL)canIList;
+ (BOOL)canIDo:(nullable NSString *)action item:(nullable BaseModel *)item;

- (BOOL)canIRead;
- (BOOL)canIUpdate;
- (BOOL)canIDelete;

@end