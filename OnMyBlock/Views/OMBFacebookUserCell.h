//
//  OMBFacebookUserCell.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 4/23/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBCenteredImageView;

@interface OMBFacebookUserCell : OMBTableViewCell
{
    UILabel *nameLabel;
    OMBCenteredImageView *userImageView;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat) heightForCell;

#pragma mark - Instance Methods

- (void) loadFacebooUserData: (NSDictionary *) object;

@end
