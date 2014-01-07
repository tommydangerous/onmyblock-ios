//
//  OMBPreviousRentalCreateConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/9/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPreviousRentalCreateConnection.h"

#import "OMBPreviousRental.h"

@implementation OMBPreviousRentalCreateConnection

#pragma mark - Initializer

- (id) initWithPreviousRental: (OMBPreviousRental *) object
{
  if (!(self = [super init])) return nil;

  previousRental = object;

  NSString *string = [NSString stringWithFormat: @"%@/previous_rentals",
    OnMyBlockAPIURL];
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
  NSDictionary *objectParams = @{
    @"address":        previousRental.address,
    @"city":           previousRental.city,
    @"landlord_email": previousRental.landlordEmail,
    @"landlord_name":  previousRental.landlordName,
    @"landlord_phone": previousRental.landlordPhone,
    @"lease_months":   [NSNumber numberWithInt: previousRental.leaseMonths],
    @"rent":           [NSNumber numberWithFloat: previousRental.rent],
    @"state":          previousRental.state,
    @"zip":            previousRental.zip
  };
  NSDictionary *params = @{
    @"access_token":    [OMBUser currentUser].accessToken,
    @"previous_rental": objectParams
  };
  NSData *json = [NSJSONSerialization dataWithJSONObject: params
    options: 0 error: nil];
  [req addValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
  [req setHTTPBody: json];
  [req setHTTPMethod: @"POST"];
  self.request = req;

  return self; 
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  if ([[json objectForKey: @"success"] intValue] == 1) {
    NSDictionary *dict = [json objectForKey: @"object"];
    previousRental.uid = [[dict objectForKey: @"id"] intValue];
  }
  [super connectionDidFinishLoading: connection];
}

@end
