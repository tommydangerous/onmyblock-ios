//
//  OMBOfferInquiryResidenceCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/5/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOfferInquiryResidenceCell.h"

#import "OMBResidence.h"

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

- (void) loadResidence: (OMBResidence *) object
{
  // Image
  NSString *sizeKey = [NSString stringWithFormat: @"%f,%f",
    objectImageView.bounds.size.width, objectImageView.bounds.size.height];
  UIImage *image = [object coverPhotoForSizeKey: sizeKey];
  if (image) {
    objectImageView.image = image;
  }
  else {
    [object downloadCoverPhotoWithCompletion: ^(NSError *error) {
      if ([object coverPhoto]) {
        objectImageView.image = [object coverPhoto];
        [object.coverPhotoSizeDictionary setObject: 
          objectImageView.image forKey: sizeKey];
      }
    }];
  }
  // Address
  topLabel.text = [object.address capitalizedString];
  // City, state
  middleLabel.text = [NSString stringWithFormat: @"%@, %@", 
    [object.city capitalizedString], object.state];

  // This is for how much time is remaining in the auction
  // bottomLabel.text = @"2d 5h remaining";
}

@end
