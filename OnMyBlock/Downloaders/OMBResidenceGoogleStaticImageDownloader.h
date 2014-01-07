//
//  OMBResidenceGoogleStaticImageDownloader.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/13/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBImageDownloader.h"

@class OMBResidence;

@interface OMBResidenceGoogleStaticImageDownloader : OMBImageDownloader
{
  OMBResidence *residence;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object url: (NSURL *) url;

@end
