//
//  OMBResidenceCoverPhotoDownloader.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBImageDownloader.h"

@class OMBResidence;

@interface OMBResidenceCoverPhotoDownloader : OMBImageDownloader

@property (nonatomic) int position;
@property (nonatomic, weak) OMBResidence *residence;

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
