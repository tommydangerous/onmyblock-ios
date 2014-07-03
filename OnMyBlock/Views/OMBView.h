//
//  OMBView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/28/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <Mixpanel/Mixpanel.h>
#import <UIKit/UIKit.h>

@interface OMBView : UIView

#pragma mark - Methods

#pragma mark - Instance Methods

#pragma mark - Public

- (void) mixpanelTrack: (NSString *) eventName 
properties: (NSDictionary *) dictionary;

@end
