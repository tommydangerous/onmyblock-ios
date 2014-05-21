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

@interface OMBSentApplicationCell : OMBTableViewCell
{
  UILabel *addressLabel;
  UILabel *nameLabel;
  UILabel *notesLabel;
  UILabel *rentLabel;
  UILabel *typeLabel;
  OMBCenteredImageView *userImageView;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCellWithNotes;

#pragma mark - Instance Methods

- (void) adjustFrames;
- (void) adjustFramesWithoutImage;
- (void) loadInfo:(OMBSentApplication *)sentapp;
- (void) loadFakeInfo;

@end
