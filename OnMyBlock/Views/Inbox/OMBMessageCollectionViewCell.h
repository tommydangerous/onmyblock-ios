//
//  OMBMessageCollectionViewCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/25/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OMBCenteredImageView;
@class OMBMessage;

@interface OMBMessageCollectionViewCell : UICollectionViewCell
{
  OMBMessage *message;
  UIView *messageArrow;
  UILabel *messageContentLabel;
  UIView *messageContentView;
  OMBCenteredImageView *otherUserImageView;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) maxWidthForMessageContentLabel;
+ (CGFloat) maxWidthForMessageContentView;
+ (UIFont *) messageContentLabelFont;
+ (CGFloat) messageContentLabelLineHeight;
+ (CGFloat) paddingForCell;

#pragma mark - Instance Methods

- (void) loadMessageData: (OMBMessage *) object;
- (void) setupForLastMessageFromSameUser;

@end
