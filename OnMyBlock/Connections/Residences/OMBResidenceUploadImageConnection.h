//
//  OMBResidenceUploadImageConnection.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/8/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBConnection.h"

@class OMBResidence;
@class OMBResidenceImage;

@interface OMBResidenceUploadImageConnection : OMBConnection
{
  OMBResidence *residence;
  OMBResidenceImage *residenceImage;
}

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object 
residenceImage: (OMBResidenceImage *) image;

@end
