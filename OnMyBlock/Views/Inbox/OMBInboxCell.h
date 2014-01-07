//
//  OMBInboxCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBCenteredImageView;
@class OMBMessage;

@interface OMBInboxCell : OMBTableViewCell
{
  UILabel *dateTimeLabel;
  OMBMessage *message;
  UILabel *messageContentLabel;
  OMBCenteredImageView *userImageView;
  UILabel *userNameLabel;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadMessageData: (OMBMessage *) object;

@end
