//
//  OMBSwitch.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 4/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface OMBSwitch : UIControl{
  UIView *container;
  UIView *gradient;
  UILabel *onLabel, *offLabel;
  UIView *switcher;
}

@property (nonatomic, getter = isOn) BOOL on;
@property(nonatomic, setter = setThumbColor:) UIColor *thumbTintColor;
@property(nonatomic, setter = setTintColor:) UIColor *onTintColor;

#pragma mark - Initializer

- (id) initWithFrame:(CGRect)frame withOnLabel:(NSString *)ontxt
         andOfflabel:(NSString *)offtxt withOnTintColor:(UIColor *)onColor
           andOffTintColor:(UIColor *)offColor;

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) setState:(BOOL)onOff;

@end

