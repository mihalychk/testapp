//
//  CRUDViewController.m
//  calories
//
//  Created by Michael on 09/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "CRUDViewController.h"
#import "Common.h"
#import "BaseModel.h"




@interface CRUDViewController () {

}

@end




@implementation CRUDViewController


#pragma mark - init & dealloc

- (nonnull instancetype)initWithItem:(nullable BaseModel *)item {
	if ((self = [super initWithNibName:nil bundle:nil]))
		self.item				= item;

	return self;
}


#pragma mark - Actions

- (void)onEditBarButtonItem:(nullable UIBarButtonItem *)sender {
	LOG(@"ON UPDATE: %@", self.item);
}


#pragma mark - UIViewController Stuff

- (void)viewDidLoad {
	[super viewDidLoad];

	if (self.item.canIUpdate)
		self.navigationItem.rightBarButtonItem	= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEditBarButtonItem:)];
}


@end