//
//  PermissionModel.h
//  calories
//
//  Created by Michael on 07/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseModel.h"




typedef NS_ENUM(NSUInteger, PermissionModelPermission) {
	PermissionModelPermissionNoAccess		= 0,
	PermissionModelPermissionMyOwnRecords,
	PermissionModelPermissionAllRecords,

	PermissionModelPermissionCount
};




@interface PermissionModel : BaseModel

@property (nonatomic, nullable, copy) NSString * model;
@property (nonatomic, assign) PermissionModelPermission create;
@property (nonatomic, assign) PermissionModelPermission read;
@property (nonatomic, assign) PermissionModelPermission update;
@property (nonatomic, assign) PermissionModelPermission delete;

+ (nullable NSArray<PermissionModel *> *)permissionsFromData:(nullable id)data;	// NSdictionary or NSArray

@end