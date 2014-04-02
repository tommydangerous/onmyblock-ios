//
//  OMBRoommateCell.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/17/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBCenteredImageView;
@class OMBRoommate;
@class OMBUser;

@interface OMBRoommateCell : OMBTableViewCell
{
  UILabel *emailLabel;
  UILabel *nameLabel;
  OMBCenteredImageView *userImageView;
}

@property (nonatomic, strong) OMBRoommate *roommate;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) loadData: (OMBRoommate *) object;
- (void) loadDataFromUser: (OMBUser *) object;

@end
