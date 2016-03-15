//
//  FormViewController.m
//  calories
//
//  Created by Michael on 11/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "FormViewController.h"
#import "Common.h"
#import "BaseModel.h"




@interface FormViewController ()

@end




@implementation FormViewController


#pragma mark - init & dealloc

- (nonnull instancetype)initWithItem:(nullable BaseModel *)item andDelegate:(nullable id<FormViewControllerDelegate>)delegate {
	if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil])) {
		self.delegate			= delegate;
		self.item				= item;
	}
	
	return self;
}


#pragma mark - Getters & Setters

- (BOOL)isEditMode {
	return VALID_UINT_1(self.itemForSave.identifier);
}



@end