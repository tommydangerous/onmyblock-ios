//
//  OMBCosignerDeleteConnection.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/5/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCosignerDeleteConnection.h"

#import "OMBCosigner.h"

@implementation OMBCosignerDeleteConnection

#pragma mark - Initializer

- (id) initWithCosigner: (OMBCosigner *) cosigner
{
  if (!(self = [super init])) return nil;

  NSString *string = [NSString stringWithFormat: 
    @"%@/cosigners/%i?access_token=%@", 
      OnMyBlockAPIURL, cosigner.uid, [OMBUser currentUser].accessToken];
  NSURL *url = [NSURL URLWithString: string];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
  [req setHTTPMethod: @"DELETE"];
  self.request = req;

  return self;
}

@end
