//
//  OMBResidenceTitleView.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 6/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceTitleView.h"

#import "OMBResidence.h"
#import "UIColor+Extensions.h"

@implementation OMBResidenceTitleView

#pragma mark - Initializer

- (id)initWithResidence:(OMBResidence *)object{
  residence = object;
  
  if(!(self = [super init]))
    return nil;
  
  self.frame = CGRectMake( -20.f, 0,
    [[UIScreen mainScreen] bounds].size.width - (4 * 20.f), 36.f);
  
  UILabel *label =
  [[UILabel alloc] initWithFrame: CGRectMake( 0, 0,
    self.frame.size.width, 18.f)];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont fontWithName: @"HelveticaNeue"
    size: 14];
  label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
  label.shadowOffset    = CGSizeMake(0, 0);
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor textColor];
  label.text = residence.address;
  [self addSubview:label];
  
  UILabel *label2 =
  [[UILabel alloc] initWithFrame:CGRectMake( 0, label.frame.size.height,
    label.frame.size.width, 18.f)];
  label2.backgroundColor = label.backgroundColor;
  label2.font = [UIFont fontWithName: @"HelveticaNeue-Light"
    size: 13];
  label2.shadowColor = label.shadowColor;
  label2.shadowOffset    = label.shadowOffset;
  label2.textAlignment = label.textAlignment;
  label2.textColor = [UIColor grayMedium];
  label2.text = [NSString stringWithFormat:@"%@, %@",
    [residence.city capitalizedString],residence.stateFormattedString];
  [self addSubview:label2];
  
  return self;

}

@end
