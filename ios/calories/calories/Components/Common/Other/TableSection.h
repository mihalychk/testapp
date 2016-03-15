//
//  TableSection.h
//  calories
//
//  Created by Michael on 10/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import <Foundation/Foundation.h>




@class BaseModel;




@interface TableSection : NSObject

@property (nonatomic, nonnull, copy) NSString * title;
@property (nonatomic, nullable, strong) NSMutableArray<BaseModel *> * items;

+ (nonnull instancetype)tableSectionWithTitle:(nonnull NSString *)title andItems:(nullable NSMutableArray<BaseModel *> *)items;

@end