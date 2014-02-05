//
//  OMBHomebaseLandlordOfferCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/4/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBCenteredImageView;
@class OMBOffer;

@interface OMBHomebaseLandlordOfferCell : OMBTableViewCell
{
  UILabel *addressLabel;
  NSTimer *countdownTimer;
  UILabel *nameLabel;
  UILabel *notesLabel;
  UILabel *rentLabel;
  UILabel *timeLabel;
  UILabel *typeLabel;
  OMBCenteredImageView *userImageView;
}

@property (nonatomic, strong) OMBOffer *offer;

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCellWithNotes;

#pragma mark - Instance Methods

- (void) adjustFrames;
- (void) loadConfirmedTenant: (OMBOffer *) object;
- (void) loadOfferForLandlord: (OMBOffer *) object;
- (void) loadOfferForRenter: (OMBOffer *) object;

@end
