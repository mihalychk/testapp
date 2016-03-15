//
//  Model.h
//  calories
//
//  Created by Michael on 07/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import <Foundation/Foundation.h>




@interface Model : NSObject

- (nonnull instancetype)initWithDictionary:(nullable NSDictionary *)dictionary;
- (void)updateWithDictionary:(nullable NSDictionary *)dictionary;

+ (nonnull NSString *)fieldName;
+ (nonnull NSString *)modelName;

@end