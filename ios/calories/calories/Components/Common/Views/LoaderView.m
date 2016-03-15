//
//  LoaderView.m
//  calories
//
//  Created by Home on 06/03/16.
//  Copyright © 2016 Mikhail Kalinin. All rights reserved.
//




#import "LoaderView.h"




@interface LoaderView ()

@property (weak) IBOutlet UIActivityIndicatorView * activityView;

@end




@implementation LoaderView


#pragma mark - init & dealloc

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder]))
		[self subInit];
	
	return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame]))
		[self subInit];
	
	return self;
}


- (void)subInit {
	self.backgroundColor		= [[UIColor whiteColor] colorWithAlphaComponent:0.95f];
}


#pragma mark - UIView

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];

	[self.activityView startAnimating];
}


- (void)removeFromSuperview {
	[self.activityView stopAnimating];

	[super removeFromSuperview];
}


@end