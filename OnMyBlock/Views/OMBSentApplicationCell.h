//
//  OMBSentApplicationCell.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 5/21/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBCenteredImageView;
@class OMBSentApplication;
@class OMBResidence;

@interface OMBSentApplicationCell : OMBTableViewCell
{
  UILabel *addressLabel;
  UILabel *bedbadlabel;
  UILabel *rentLabel;
  OMBResidence *residence;
  OMBCenteredImageView *userImageView;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell;

#pragma mark - Instance Methods

- (void) adjustFrames;
- (void) adjustFramesWithoutImage;
- (void) loadInfo:(OMBSentApplication *)sentapp;

@end
