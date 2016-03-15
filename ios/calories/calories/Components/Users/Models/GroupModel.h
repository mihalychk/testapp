//
//  GroupModel.h
//  calories
//
//  Created by Home on 05/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseModel.h"




@class PermissionModel;




@interface GroupModel : BaseModel

@property (nonatomic, nullable, copy) NSString * name;
@property (nonatomic, nullable, copy) NSArray<PermissionModel *> * permissions;

@end