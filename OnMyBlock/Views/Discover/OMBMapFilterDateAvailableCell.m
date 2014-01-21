//
//  OMBMapFilterDateAvailableCell.m
//  OnMyBlock
//
//  Created by Peter Meyers on 1/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMapFilterDateAvailableCell.h"

@implementation OMBMapFilterDateAvailableCell

- (id) initWithStyle: (UITableViewCellStyle) style
	 reuseIdentifier: (NSString *)reuseIdentifier
{
	if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]))
		return nil;
	
	self.backgroundColor = [UIColor grayUltraLight];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	CGRect screen = [[UIScreen mainScreen] bounds];
	CGFloat padding = 20.0f;
	
	_dateAvailable = [[TextFieldPadding alloc] init];
	_dateAvailable.backgroundColor = [UIColor whiteColor];
	_dateAvailable.clipsToBounds = YES;
	_dateAvailable.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15];
	_dateAvailable.frame = CGRectMake(padding, 0.0f, screen.size.width - (padding * 2), 44.0f);
	_dateAvailable.keyboardType = UIKeyboardTypeDecimalPad;
	_dateAvailable.layer.borderColor = [UIColor blue].CGColor;
	_dateAvailable.layer.borderWidth = 1.0f;
	_dateAvailable.layer.cornerRadius = 5.0f;
	_dateAvailable.paddingX = padding;
	_dateAvailable.placeholderColor = [UIColor grayLight];
	_dateAvailable.placeholder = @"Select date available";
	_dateAvailable.returnKeyType = UIReturnKeyDone;
	_dateAvailable.textAlignment = NSTextAlignmentCenter;
	_dateAvailable.textColor = [UIColor blue];
	_dateAvailable.userInteractionEnabled = NO;
	
	[self.contentView addSubview: _dateAvailable];
	return self;
}


@end
