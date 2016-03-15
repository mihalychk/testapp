//
//  BaseFormViewController.m
//  calories
//
//  Created by Michael on 08/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "BaseFormViewController.h"
#import "Common.h"




@interface BaseFormViewController ()

@end




@implementation BaseFormViewController


#pragma mark - Actions

- (void)onScreenTap:(UITapGestureRecognizer *)sender {
	[self.firstResponder resignFirstResponder];
}


#pragma mark - UIViewController Stuff

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.scrollView addSubview:self.contentView];
	[self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onScreenTap:)]];
	
	self.moveScreenOnEdit			= YES;
	self.mainScrollView				= self.scrollView;
}


- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	CGSize size						= self.scrollView.frame.size;
	self.contentView.frame			= CGRectMake(0.0f, 0.0f, size.width, size.height);
	self.scrollView.contentSize		= self.contentView.frame.size;
}


@end