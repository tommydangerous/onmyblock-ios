//
//  OMBSwitch.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 4/16/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//  reference http://xcodenoobies.blogspot.com/2013_04_01_archive.html

#import "OMBSwitch.h"

#import "UIFont+OnMyBlock.h"

@implementation OMBSwitch

float knobSize = 0.9;

- (id) initWithFrame:(CGRect)frame withOnLabel:(NSString *)ontxt
         andOfflabel:(NSString *)offtxt withOnTintColor:(UIColor *)onColor
           andOffTintColor:(UIColor *)offColor;
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    //self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = frame.size.height/2.0;
    
    container = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.x, frame.size.width, frame.size.height)];
    container.layer.cornerRadius = frame.size.height/2.0;
    container.backgroundColor = offColor;
    
    gradient = [UIView new];
    gradient.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    gradient.backgroundColor = onColor;
    [container addSubview:gradient];
    gradient.clipsToBounds = YES;
    gradient.hidden = YES;
    _on = NO; // default is like UISwitch, ie off state
    
    // create and set Labels
    
    float labelWidth = frame.size.width * 0.55f;
    
    onLabel = [[UILabel alloc] initWithFrame:
      CGRectMake(0, 0, labelWidth, frame.size.height)];
    onLabel.backgroundColor = [UIColor clearColor];
    onLabel.textColor = [UIColor whiteColor];
    onLabel.font = [UIFont smallTextFontBold];
    onLabel.textAlignment = NSTextAlignmentCenter;
    onLabel.text = ontxt;
    onLabel.alpha = 0;
    
    offLabel = [[UILabel alloc] initWithFrame:
      CGRectMake(frame.size.width - labelWidth, 0, labelWidth, frame.size.height)];
    offLabel.backgroundColor = [UIColor clearColor];
    offLabel.textColor = [UIColor whiteColor];
    offLabel.font = [UIFont smallTextFontBold];
    offLabel.textAlignment = NSTextAlignmentCenter;
    offLabel.text = offtxt;
    
    [container addSubview:onLabel];
    [container addSubview:offLabel];
    
    switcher = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.height / 16.0,
      self.frame.size.height / 2 - self.frame.size.height * knobSize / 2,
        self.frame.size.width * 0.45f , self.frame.size.height * knobSize)];
    switcher.layer.cornerRadius = frame.size.height * knobSize / 2.0;
    switcher.layer.masksToBounds = NO;
    //switcher.layer.opaque = YES;
    switcher.clipsToBounds = YES;
    switcher.backgroundColor = [UIColor whiteColor];
    [container addSubview:switcher];
    
    [self addSubview:container];
    
  }
  return self;
}
/*
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  
  // toggles state and visuals
  
  [UIView beginAnimations: @"" context: nil];
  [UIView setAnimationDelegate: self];
  [UIView setAnimationDuration: 0.3];
  [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
  _on = !_on;
  
  if (_on) {
    switcher.frame =  CGRectMake(self.frame.size.width - switcher.frame.size.width -
      self.frame.size.height/16.0, self.frame.size.height/2 - self.frame.size.height * knobSize / 2,
        switcher.frame.size.width, self.frame.size.height*knobSize);
    onLabel.alpha = 1;
    offLabel.alpha = 0;
    gradient.hidden = NO;
  } else {
    switcher.frame =  CGRectMake(self.frame.size.height / 16.0,
      self.frame.size.height / 2 - self.frame.size.height * knobSize/2,
        switcher.frame.size.width,
          self.frame.size.height*knobSize);
    onLabel.alpha = 0;
    offLabel.alpha = 1;
    gradient.hidden = YES;
  }
  [UIView commitAnimations];
  
}
*/
-(void)setState:(BOOL)onOff withAnimation:(BOOL)animation{
  // setState
  _on = onOff;
  // set visuals
  if(animation){
    [UIView beginAnimations: @"" context: nil];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
  }
  
  if (!_on) {
    switcher.frame =  CGRectMake(self.frame.size.height / 16.0,
      self.frame.size.height / 2 - self.frame.size.height * knobSize / 2,
        switcher.frame.size.width,
          self.frame.size.height*knobSize);
    onLabel.alpha = 0;
    offLabel.alpha = 1;
    gradient.hidden = YES;
  } else {
    switcher.frame =  CGRectMake(self.frame.size.width - switcher.frame.size.width - self.frame.size.height / 16.0,
      self.frame.size.height / 2 - self.frame.size.height * knobSize / 2,
        switcher.frame.size.width,
          self.frame.size.height * knobSize);
    
    onLabel.alpha = 1;
    offLabel.alpha = 0;
    gradient.hidden = NO;
  }
  
  if(animation)
    [UIView commitAnimations];
  
}

- (void) setTintColor:(UIColor *)thumbColor
{
  _onTintColor = thumbColor;
  gradient.backgroundColor = _thumbTintColor;
}

- (void) setThumbColor:(UIColor *)thumbColor
{
  _thumbTintColor = thumbColor;
  switcher.backgroundColor = _thumbTintColor;
}

@end
