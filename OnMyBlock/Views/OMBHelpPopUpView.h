//
//  OMBHelpPopUpView.h
//  OnMyBlock
//
//  Created by Tommy DANGerous on 2/12/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBView.h"

@class OMBCloseButtonView;

@interface OMBHelpPopUpView : OMBView
{
  UIColor *backgroundColor;
  OMBCloseButtonView *closeButtonView;
  NSArray *rectsArray;
}

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *pointerImageView;

- (id) initWithFrame: (CGRect) frame
backgroundColor: (UIColor*) color andTransparentRects: (NSArray*) rects;

- (void) setLabelText: (NSString *) string;

@end
