//
//  ValidationError.h
//  calories
//
//  Created by Michael on 07/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "Model.h"




@interface ValidationError : Model

@property (nonatomic, nullable , copy) NSString * field;
@property (nonatomic, nullable , copy) NSString * message;

+ (nullable NSArray<ValidationError *> *)errorsFromData:(nullable id)data;	// NSdictionary or NSArray

@end