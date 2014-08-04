//
//  OMBMixpanelTracker.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 7/3/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMixpanelTracker.h"

// Models
#import "OMBRenterApplication.h"
#import "OMBResidence.h"
#import "OMBRoommate.h"
#import "OMBUser.h"

@implementation OMBMixpanelTracker

void OMBMixpanelTrackerTrack (NSString *eventName, NSDictionary *properties)
{
  if (__ENVIRONMENT__ == 3) {
    [[Mixpanel sharedInstance] track: eventName properties: properties];
  }
  else {
    NSLog(@"OMBMixpanelTracker - %@: %@", eventName, properties);
  }
}

void OMBMixpanelTrackerTrackSubmission (NSString *eventName, 
  OMBResidence *residence, OMBUser *user) {

  void (^trackCompletion) (NSInteger coapplicantsCount) =
    ^(NSInteger coapplicantsCount) {
      NSMutableDictionary *properties =
        [NSMutableDictionary dictionaryWithDictionary: @{
          @"bathrooms":          @(residence.bathrooms),
          @"bedrooms":           @(residence.bedrooms),
          @"coapplicants_count": @(coapplicantsCount),
          @"rent":               @(residence.minRent),
          @"residence_id":       @(residence.uid),
          @"user_id":            @(user.uid)
        }];
      if (residence.user && residence.user.uid) {
        [properties setObject: @(residence.user.uid) 
          forKey: @"landlord_user_id"];
      }
      if (residence.moveInDate) {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"M/d/yyyy";
        if (residence.moveInDate) {
          [properties setObject: [dateFormatter stringFromDate:
            [NSDate dateWithTimeIntervalSince1970: 
              residence.moveInDate]] forKey: @"move_in_date"];
        }
        NSDate *moveOutDate;
        if (residence.moveOutDate) {
          moveOutDate = [NSDate dateWithTimeIntervalSince1970:
            residence.moveOutDate];
        }
        else {
          moveOutDate = [residence moveOutDateDate];
        }
        [properties setObject: [dateFormatter stringFromDate: moveOutDate]
          forKey: @"move_out_date"];
      }
      OMBMixpanelTrackerTrack(eventName, properties);
    };

  // If there are roommates
  if ([[user.renterApplication roommates] count]) {
    trackCompletion([[user.renterApplication roommates] count]);
  }
  // Fetch roommates
  else {
    [user.renterApplication fetchListForResourceName: 
      [OMBRoommate resourceName] userUID: user.uid delegate: nil 
        completion: ^(NSError *error) {
          trackCompletion([[user.renterApplication roommates] count]);
        }];
  }
}

@end
