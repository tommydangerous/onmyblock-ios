//
//  OMBMessage.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMessage.h"

#import "NSString+Extensions.h"
#import "OMBMessageCollectionViewCell.h"

@implementation OMBMessage

#pragma mark - Methods

- (void) calculateSizeForMessageCell
{
  NSAttributedString *aString = [self.content attributedStringWithFont:
    [OMBMessageCollectionViewCell messageContentLabelFont]
      lineHeight: [OMBMessageCollectionViewCell messageContentLabelLineHeight]];
  CGRect rect = [aString boundingRectWithSize:
    CGSizeMake([OMBMessageCollectionViewCell maxWidthForMessageContentLabel], 
      9999) options: NSStringDrawingUsesLineFragmentOrigin context: nil];
  self.sizeForMessageCell = rect.size;
}

@end
