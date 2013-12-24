//
//  OMBMapFilterBedroomsCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/20/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBMapFilterBedroomsCell.h"

#import "UIImage+Color.h"
#import "UIColor+Extensions.h"

@implementation OMBMapFilterBedroomsCell

#pragma mark - Initialize

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;

  _buttons = [NSMutableArray array];

  int number = 4;
  CGFloat width = 58.0f;
  CGFloat spacing = (screen.size.width - (width * number)) / (number + 1);
  for (int i = 0; i < number; i++) {
    UIButton *button = [[UIButton alloc] init];
    button.clipsToBounds = YES;
    button.frame = CGRectMake(spacing + ((width + spacing) * i),
      padding * 0.25, width, width);
    button.layer.borderColor = [UIColor blueLight].CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = width * 0.5;
    button.tag = 0;
    button.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
      size: 15];
    NSString *string = [NSString stringWithFormat: @"%i", i];
    if (i == number - 1)
      string = [string stringByAppendingString: @"+"];
    [button addTarget: self action: @selector(buttonSelected:)
      forControlEvents: UIControlEventTouchUpInside];
    [button setTitle: string forState: UIControlStateNormal];
    [button setTitleColor: [UIColor blueLight] 
      forState: UIControlStateNormal];
    [_buttons addObject: button];
    [self.contentView addSubview: button];
  }

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) buttonSelected: (UIButton *) button
{
  if (button.tag) {
    [self deselectButton: button];
  }
  else {
    [self selectButton: button];
  }
}

- (void) deselectAllButtons
{
  for (UIButton *button in _buttons) {
    [self deselectButton: button];
  }
}

- (void) deselectButton: (UIButton *) button
{
  button.backgroundColor   = [UIColor clearColor];
  button.layer.borderColor = [UIColor blueLight].CGColor;
  button.tag = 0;
  [button setTitleColor: [UIColor blueLight] forState: UIControlStateNormal];
}

- (void) selectButton: (UIButton *) button
{
  button.backgroundColor   = [UIColor blueLight];
  button.layer.borderColor = [UIColor blueLight].CGColor;
  button.tag = 1;
  [button setTitleColor: [UIColor blueDark] forState: UIControlStateNormal];
}

@end
