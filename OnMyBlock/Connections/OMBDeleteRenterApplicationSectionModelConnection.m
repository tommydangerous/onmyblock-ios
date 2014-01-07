//
//  OMBDeleteRenterApplicationSectionModelConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/9/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBDeleteRenterApplicationSectionModelConnection.h"

#import "OMBCosigner.h"
#import "OMBEmployment.h"
#import "OMBPreviousRental.h"

@implementation OMBDeleteRenterApplicationSectionModelConnection

#pragma mark - Initializer

- (id) initWithObject: (id) object
{
  if (!(self = [super init])) return nil;

  NSString *modelString = @"";
  int modelId = 0;
  if ([object isKindOfClass: [OMBCosigner class]]) {
    OMBCosigner *model = (OMBCosigner *) object;
    modelId     = model.uid;
    modelString = @"cosigners";
  }
  else if ([object isKindOfClass: [OMBEmployment class]]) {
    OMBEmployment *model = (OMBEmployment *) object;
    modelId     = model.uid;
    modelString = @"employments";
  }
  else if ([object isKindOfClass: [OMBPreviousRental class]]) {
    OMBPreviousRental *model = (OMBPreviousRental *) object;
    modelId     = model.uid;
    modelString = @"previous_rentals";
  }

  NSString *string = [NSString stringWithFormat: 
    @"%@/%@/%i?access_token=%@", 
      OnMyBlockAPIURL, modelString, modelId, 
        [OMBUser currentUser].accessToken];
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
  [req setHTTPMethod: @"DELETE"];
  self.request = req;

  return self;
}

@end
