//
//  OMBResidenceSimilarConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/29/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBResidenceSimilarConnection.h"

#import "OMBResidence.h"
#import "OMBResidenceDetailViewController.h"
#import "OMBResidenceStore.h"

@implementation OMBResidenceSimilarConnection

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) residence
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/places/%i/show_similar/", OnMyBlockAPIURL, residence.uid];
  [self setRequestFromString: string];

  return self;
}

#pragma mark - Protocol

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  for (NSDictionary *dictionary in json) {
    NSString *address = [dictionary objectForKey: @"address"];
    float latitude    = [[dictionary objectForKey: @"latitude"] floatValue];
    float longitude   = [[dictionary objectForKey: @"longitude"] floatValue];
    NSString *key     = [NSString stringWithFormat: @"%f,%f-%@", latitude,
      longitude, address];
    OMBResidence *residence = 
      [[OMBResidenceStore sharedStore].residences objectForKey: key];
    if (!residence) {
      residence = [[OMBResidence alloc] init];
      [residence readFromResidenceDictionary: dictionary];
      [[OMBResidenceStore sharedStore] addResidence: residence];
    }
    [(OMBResidenceDetailViewController *) self.delegate addSimilarResidence:
      residence];
  }
  [super connectionDidFinishLoading: connection];
}

@end
