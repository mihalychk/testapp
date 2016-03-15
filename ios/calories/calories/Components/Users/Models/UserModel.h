//
//  UserModel.h
//  calories
//
//  Created by Home on 04/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseModel.h"
#import "PermissionModel.h"




@class GroupModel;




@interface UserModel : BaseModel

@property (nonatomic, nullable, copy)   NSString   * email;
@property (nonatomic, nullable, copy)   NSString   * password;
@property (nonatomic, nullable, copy)   NSString   * name;
@property (nonatomic, nullable, copy)   NSNumber   * caloriesPerDay;
@property (nonatomic, nullable, strong) GroupModel * group;

- (PermissionModelPermission)accessLevelForModel:(nullable NSString *)model byAction:(nullable NSString *)action;
- (PermissionModelPermission)createAccessLevelForModel:(nullable NSString *)model;
- (PermissionModelPermission)readAccessLevelForModel:(nullable NSString *)model;
- (PermissionModelPermission)updateAccessLevelForModel:(nullable NSString *)model;
- (PermissionModelPermission)deleteAccessLevelForModel:(nullable NSString *)model;

@end