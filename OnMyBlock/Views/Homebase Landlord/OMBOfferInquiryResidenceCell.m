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
  if ([object coverPhoto]) {
    objectImageView.image = [object coverPhotoForSize: 
      objectImageView.frame.size];
  }
  else {
    [object downloadCoverPhotoWithCompletion: ^(NSError *error) {
      objectImageView.image = [object coverPhoto];
      [object.coverPhotoSizeDictionary setObject: objectImageView.image
        forKey: [NSString stringWithFormat: @"%f,%f", 
          objectImageView.frame.size.width, objectImageView.frame.size.height]];
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
