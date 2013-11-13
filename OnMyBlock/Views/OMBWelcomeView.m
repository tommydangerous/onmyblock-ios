//
//  OMBWelcomeView.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 11/7/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBWelcomeView.h"

#import "UIColor+Extensions.h"

@implementation OMBWelcomeView

- (id) init
{
  if (!(self = [super init])) return nil;

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.frame = screen;

  // About 60 on 3.5 inch
  float marginTop = screen.size.height * 0.125;
  // About 10 on 3.5
  float paddingTop = screen.size.height * 0.02083;

  UILabel *welcomeLabel = [[UILabel alloc] init];
  welcomeLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 27];
  welcomeLabel.frame = CGRectMake(0, marginTop, screen.size.width, 36);
  welcomeLabel.text = @"Welcome to";
  welcomeLabel.textAlignment = NSTextAlignmentCenter;
  welcomeLabel.textColor = [UIColor grayDark];
  [self addSubview: welcomeLabel];

  UILabel *onmyblock = [[UILabel alloc] init];
  onmyblock.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 36];
  onmyblock.frame = CGRectMake(welcomeLabel.frame.origin.x, 
    (welcomeLabel.frame.origin.y + welcomeLabel.frame.size.height), 
      welcomeLabel.frame.size.width, 54);
  NSMutableAttributedString *onmyString = 
    [[NSMutableAttributedString alloc] initWithString: @"OnMy" attributes: @{
      NSForegroundColorAttributeName: [UIColor grayDark]
    }];
  NSAttributedString *blockString = [[NSAttributedString alloc] initWithString: 
    @"Block" attributes: @{
      NSForegroundColorAttributeName: [UIColor blue]
    }];
  [onmyString appendAttributedString: blockString];
  onmyblock.attributedText = onmyString;
  onmyblock.textAlignment = welcomeLabel.textAlignment;
  [self addSubview: onmyblock];

  float imageDimension = screen.size.height * 0.35;
  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.frame = CGRectMake(((screen.size.width - imageDimension) / 2.0),
    (onmyblock.frame.origin.y + onmyblock.frame.size.height + paddingTop), 
      imageDimension, imageDimension);
  imageView.image = [UIImage imageNamed: @"logo_shadow.png"];
  [self addSubview: imageView];

  UILabel *line1 = [[UILabel alloc] init];
  line1.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 23];
  line1.frame = CGRectMake(0, 
    (imageView.frame.origin.y + imageView.frame.size.height + paddingTop), 
      screen.size.width, 36);
  line1.text = @"Find, share, and review";
  line1.textAlignment = NSTextAlignmentCenter;
  line1.textColor = [UIColor grayDark];
  [self addSubview: line1];

  UILabel *line2 = [[UILabel alloc] init];
  line2.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 23];;
  line2.frame = CGRectMake(line1.frame.origin.x, 
    (line1.frame.origin.y + line1.frame.size.height ), 
      line1.frame.size.width, line1.frame.size.height);
  line2.text = @"the best college pads.";
  line2.textAlignment = line1.textAlignment;
  line2.textColor = line1.textColor;
  [self addSubview: line2];

  return self;
}

@end
