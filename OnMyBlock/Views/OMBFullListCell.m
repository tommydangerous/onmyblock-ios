//
//  OMBFullListCell.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFullListCell.h"

@implementation OMBFullListCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  if(!(self = [super initWithStyle:style
      reuseIdentifier:reuseIdentifier]))
    return nil;
  
  
  self.backgroundColor = UIColor.clearColor;
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.textLabel.textColor = UIColor.whiteColor;
  
  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (CGFloat)heightForCell
{
  return 45.f;
}

#pragma mark - Instance Methods

- (void)addBorder
{
  if(![self viewWithTag:55]){
    UIView *border = [UIView new];
    border.backgroundColor = [UIColor colorWithWhite:1.0f alpha:.7f];
    border.frame = CGRectMake(5.f, 45.f - 1.f,
      self.frame.size.width - 50.f, 1.f);
    border.tag = 55;
    [self addSubview:border];
  }
}

- (void)removeBorder
{
  if([self viewWithTag:55]){
    [[self viewWithTag:55] removeFromSuperview];
  }
}

@end
