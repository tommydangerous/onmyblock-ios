//
//  OMBMixpanelTracker.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 7/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Mixpanel/Mixpanel.h>

#import "OMBObject.h"

@class OMBResidence;
@class OMBUser;

@interface OMBMixpanelTracker : OMBObject

void OMBMixpanelTrackerTrack (NSString *eventName, NSDictionary *properties);
void OMBMixpanelTrackerTrackSubmission (NSString *eventName, 
  OMBResidence *residence, OMBUser *user);

@end
