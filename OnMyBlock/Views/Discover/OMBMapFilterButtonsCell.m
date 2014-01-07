//
//  OMBMapFilterButtonsCell.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/2/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBMapFilterButtonsCell.h"

@implementation OMBMapFilterButtonsCell

#pragma mark - Initialize

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *)reuseIdentifier
{ 
  if (!(self = [super initWithStyle: style reuseIdentifier: reuseIdentifier])) 
    return nil;

  _buttons = [NSMutableArray array];
  _selectedButtons = [NSMutableDictionary dictionary];

  self.backgroundColor = [UIColor grayUltraLight];
  self.selectionStyle = UITableViewCellSelectionStyleNone;

  return self;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) buttonSelected: (UIButton *) button
{
  NSNumber *key = [NSNumber numberWithInt: button.tag];
  NSNumber *number = [_selectedButtons objectForKey: key];
  BOOL selected = ![number boolValue];
  [_selectedButtons setObject: [NSNumber numberWithBool: selected] forKey: key];
  UIButton *b = [_buttons objectAtIndex: button.tag];
  if (selected) {
    b.backgroundColor = [UIColor blue];
    [b setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
  }
  else {
    b.backgroundColor = [UIColor clearColor];
    [b setTitleColor: [UIColor blue] forState: UIControlStateNormal];
  }
}

- (void) resetButtons
{
  for (int i = 0; i < _maxButtons; i++) {
    [_selectedButtons setObject: [NSNumber numberWithBool: NO] forKey: 
      [NSNumber numberWithInt: i]];

    UIButton *button = [_buttons objectAtIndex: i];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor: [UIColor blue] forState: UIControlStateNormal];
  }
}

- (void) setupButtons
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;

  UIView *buttonsView = [UIView new];
  buttonsView.backgroundColor = [UIColor whiteColor];
  buttonsView.clipsToBounds = YES;
  buttonsView.frame = CGRectMake(padding, 0.0f, 
    screen.size.width - (padding * 2), 44.0f);
  buttonsView.layer.borderColor = [UIColor blue].CGColor;
  buttonsView.layer.borderWidth = 1.0f;
  buttonsView.layer.cornerRadius = 5.0f;
  [self.contentView addSubview: buttonsView];

  CGFloat buttonWidth = buttonsView.frame.size.width / _maxButtons;

  for (int i = 0; i < _maxButtons; i++) {
    UIButton *button = [UIButton new];
    button.titleLabel.font = [UIFont fontWithName: @"HelveticaNeue-Medium"
      size: 15];
    button.frame = CGRectMake(buttonWidth * i, 0.0f,
      buttonWidth, buttonsView.frame.size.height);
    button.tag = i;
    // Left border
    if (i != 0) {
      CALayer *leftBorder = [CALayer layer];
      leftBorder.backgroundColor = buttonsView.layer.borderColor;
      leftBorder.frame = CGRectMake(0.0f, 0.0f, buttonsView.layer.borderWidth,
        buttonsView.frame.size.height);
      [button.layer addSublayer: leftBorder];
    }
    [button addTarget: self action: @selector(buttonSelected:)
      forControlEvents: UIControlEventTouchUpInside];
    [button setTitleColor: [UIColor blue] forState: UIControlStateNormal];
    [_buttons addObject: button];
    [buttonsView addSubview: button];

    [_selectedButtons setObject: [NSNumber numberWithBool: NO] forKey:
      [NSNumber numberWithInt: i]];
  }
}

- (void) setupButtonTitles
{
  // Subclasses implement this
}

@end
