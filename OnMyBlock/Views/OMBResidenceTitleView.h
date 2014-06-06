//
//  OMBResidenceTitleView.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

@class OMBResidence;

@interface OMBResidenceTitleView : UIView
{
  OMBResidence *residence;
}

#pragma mark - Initializer

- (id)initWithResidence:(OMBResidence *)object;

@end
