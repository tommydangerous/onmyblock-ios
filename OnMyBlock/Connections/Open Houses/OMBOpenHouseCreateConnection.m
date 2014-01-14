//
//  OMBOpenHouseCreateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/13/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBOpenHouseCreateConnection.h"

#import "OMBOpenHouse.h"
#import "OMBResidence.h"
#import "OMBTemporaryResidence.h"

@implementation OMBOpenHouseCreateConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) residence 
openHouse: (OMBOpenHouse *) object
{
  if (!(self = [super init])) return nil;

  openHouse = object;

  NSString *resource = @"places";
  if ([residence isKindOfClass: [OMBTemporaryResidence class]])
    resource = @"temporary_residences";

  NSString *string = [NSString stringWithFormat: @"%@/%@/%i/create_open_house",
    OnMyBlockAPIURL, resource, residence.uid];

  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat       = @"yyyy-MM-dd HH:mm:ss ZZZ";

  NSDictionary *params = @{
    @"access_token": [OMBUser currentUser].accessToken,
    @"open_house": @{
      @"duration":   [NSNumber numberWithInt: openHouse.duration],
      @"start_date": [dateFormatter stringFromDate: 
        [NSDate dateWithTimeIntervalSince1970: openHouse.startDate]]
    }
  };

  [self setRequestWithString: string method: @"POST" parameters: params];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];

  NSLog(@"OMBOpenHouseCreateConnection\n%@", json);

  if ([[json objectForKey: @"success"] intValue] == 1) {
    openHouse.uid = 
      [[[json objectForKey: @"object"] objectForKey: @"id"] intValue];
  }

  [super connectionDidFinishLoading: connection];
}

@end
