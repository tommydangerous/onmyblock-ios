//
//  OMBResidenceCoverPhotoURLConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/21/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBResidence;
@class OMBResidenceCoverPhotoDownloader;
@class OMBResidenceGoogleStaticImageDownloader;

@interface OMBResidenceCoverPhotoURLConnection : OMBConnection
{
  OMBResidenceCoverPhotoDownloader *coverPhotoDownloader;
  OMBResidenceGoogleStaticImageDownloader *googleStaticImageDownloader;
  OMBResidence *residence;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object;

@end
