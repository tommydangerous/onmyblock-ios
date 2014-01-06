//
//  OMBHomebasePaymentCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/4/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseLandlordPaymentCell.h"

#import "OMBCenteredImageView.h"

@implementation OMBHomebaseLandlordPaymentCell

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  timeLabel.textColor = [UIColor grayMedium];

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) adjustFrames
{
  [super adjustFrames];
  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  CGFloat padding     = 20.0f;

  // Rent
  CGRect rentRect = rentLabel.frame;
  rentRect.origin.y = nameLabel.frame.origin.y + nameLabel.frame.size.height;
  rentLabel.frame = rentRect;

  // Type
  CGFloat typeWidth = screenWidth - (rentLabel.frame.origin.x + 
    rentLabel.frame.size.width + (padding * 0.5) + padding);
  CGRect typeRect = typeLabel.frame;
  typeRect.origin.x = rentLabel.frame.origin.x + rentLabel.frame.size.width +
    (padding * 0.5f);
  typeRect.size.width = typeWidth;
  typeLabel.frame = typeRect;

  // Address
  CGRect addressRect = addressLabel.frame;
  addressRect.origin.x = nameLabel.frame.origin.x;
  addressRect.origin.y = rentLabel.frame.origin.y + rentLabel.frame.size.height;
  addressRect.size.width = screenWidth - (nameLabel.frame.origin.x + padding);
  addressLabel.frame = addressRect;
}

- (void) loadPendingPaymentData
{
  // Image
  userImageView.image = [UIImage imageNamed: @"edward_d.jpg"];
  // Time = Date
  timeLabel.text = @"";
  // Name
  nameLabel.text = @"Edward Drake";
  // Type = paid / due date
  typeLabel.text = @"due 6/1/14";
  // Rent
  rentLabel.text = @"$2,100";
  // Address
  addressLabel.text = @"275 Sand Hill Rd";
  [self adjustFrames];
}

- (void) loadPreviousPaymentData
{
  // Image
  userImageView.image = [UIImage imageNamed: @"tommy_d.png"];
  // Time = Date
  timeLabel.text = @"4/12/14";
  // Name
  nameLabel.text = @"Tommy Dang";
  // Type = paid / due date
  typeLabel.text = @"paid";
  // Rent
  rentLabel.text = @"$2,750";
  // Address
  addressLabel.text = @"4654342 Costa Verde Way Blvddds";
  [self adjustFrames];

}

@end
