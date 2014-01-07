//
//  OMBUserImageDownloader.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBImageDownloader.h"

@class OMBUser;

@interface OMBUserImageDownloader : OMBImageDownloader

@property (nonatomic, weak) OMBUser *user;

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object;

@end
