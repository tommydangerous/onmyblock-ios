//
//  OMBResidenceCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/23/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceCell.h"

#import "OMBResidencePartialView.h"

@implementation OMBResidenceCell

@synthesize imageView = _imageView;
@synthesize residence = _residence;

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style  
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier]))
    return nil;

  residencePartialView = [[OMBResidencePartialView alloc] init];
  _imageView = residencePartialView.imageView;

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.contentView.frame = CGRectMake(residencePartialView.frame.origin.x,
    screen.size.height, residencePartialView.frame.size.width,
      residencePartialView.frame.size.height);
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  [self.contentView addSubview: residencePartialView];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadResidenceData: (OMBResidence *) object
{
  _residence = object;
  [residencePartialView loadResidenceData: _residence];
}

@end
