//
//  OMBRoommateCell.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 3/17/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBTableViewCell.h"

@class OMBCenteredImageView;
@class OMBInvitation;
@class OMBRoommate;
@class OMBUser;

@interface OMBRoommateCell : OMBTableViewCell

@property (nonatomic, strong) OMBRoommate *roommate;

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void) loadData: (OMBRoommate *) object user: (OMBUser *) userObject;
- (void) loadDataFromInvitation:(OMBInvitation *)invitation;
- (void) loadDataFromUser: (OMBUser *) object;

@end
