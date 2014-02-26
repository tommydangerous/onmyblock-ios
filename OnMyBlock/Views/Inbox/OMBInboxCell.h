//
//  OMBInboxCell.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/24/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBCenteredImageView;
@class OMBConversation;

@interface OMBInboxCell : OMBTableViewCell

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadConversationData: (OMBConversation *) object;

@end
