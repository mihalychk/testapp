//
//  RecordModel.h
//  calories
//
//  Created by Michael on 07/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseModel.h"




@class UserModel;




@interface RecordModel : BaseModel

@property (nonatomic, copy)   NSNumber  * userId;
@property (nonatomic, copy)   NSString  * text;
@property (nonatomic, copy)   NSNumber  * calories;
@property (nonatomic, copy)   NSDate    * datetime;
@property (nonatomic, strong) UserModel * user;

@end