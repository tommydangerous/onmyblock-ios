//
//  OMBOfferInquiryResidenceCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOfferInquiryResidenceCell.h"

@implementation OMBOfferInquiryResidenceCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadResidenceData
{
  objectImageView.image = [UIImage imageNamed: @"residence_fake.jpg"];
  topLabel.text    = @"4312 Mordor Road";
  middleLabel.text = @"San Diego, CA";
  bottomLabel.text = @"2d 5h remaining";
}

@end
