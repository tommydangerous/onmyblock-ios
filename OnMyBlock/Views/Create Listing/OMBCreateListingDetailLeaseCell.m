//
//  OMBCreateListingDetailLeaseCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 1/23/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBCreateListingDetailLeaseCell.h"

@implementation OMBCreateListingDetailLeaseCell

- (id) initWithStyle: (UITableViewCellStyle) style
     reuseIdentifier: (NSString *)reuseIdentifier
{
	if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]))
		return nil;
	
	self.backgroundColor = [UIColor whiteColor];//!
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	CGRect screen = [[UIScreen mainScreen] bounds];
	CGFloat padding = 20.0f;
	
  _detailNameLabel = [UILabel new];
  _detailNameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light"
                                          size: 15];
  _detailNameLabel.textAlignment = NSTextAlignmentCenter;
  _detailNameLabel.textColor = [UIColor grayMedium];
  _detailNameLabel.frame = CGRectMake(0.0f, 0.0f, screen.size.width, 30.0f);
  [self.contentView addSubview: _detailNameLabel];
  
	_lenghtLease = [[TextFieldPadding alloc] init];
	_lenghtLease.backgroundColor = [UIColor whiteColor];
	_lenghtLease.clipsToBounds = YES;
	_lenghtLease.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 18];
	_lenghtLease.frame = CGRectMake(padding, _detailNameLabel.frame.origin.y + _detailNameLabel.frame.size.height + padding/2, screen.size.width - (padding * 2), 58.0f);
	_lenghtLease.keyboardType = UIKeyboardTypeDecimalPad;
	_lenghtLease.layer.borderColor = [UIColor grayLight].CGColor;
	_lenghtLease.layer.borderWidth = 1.0f;
	_lenghtLease.paddingX = padding;
	_lenghtLease.placeholderColor = [UIColor grayLight];
	_lenghtLease.placeholder = @"0";
	_lenghtLease.returnKeyType = UIReturnKeyDone;
	_lenghtLease.textAlignment = NSTextAlignmentCenter;
	_lenghtLease.textColor = [UIColor blueDark];
	_lenghtLease.userInteractionEnabled = NO;
	
	[self.contentView addSubview: _lenghtLease];
	return self;
}

@end
