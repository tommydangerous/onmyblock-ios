//
//  OMBFullListView.m
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBFullListView.h"

#import "OMBBlurView.h"
#import "OMBCloseButtonView.h"
#import "UIFont+OnMyBlock.h"

@implementation OMBFullListView

- (id)init
{
  if(!(self = [super init]))
    return nil;

  float padding = 20.f;
  
  CGRect screen = [UIScreen mainScreen].bounds;
  self.frame = screen;
  
  // Objects
  arrayObjects = [NSArray array];
  
  // Blue effect
  backgroundBlurView = [[OMBBlurView alloc] initWithFrame: self.frame];
  backgroundBlurView.blurRadius = 10.0f;
  backgroundBlurView.tintColor  = [UIColor colorWithWhite: 0.0f alpha: 0.6f];
  [self addSubview: backgroundBlurView];
  
  // Title
  titleLabel = [UILabel new];
  titleLabel.font = [UIFont mediumTextFontBold];
  titleLabel.frame = CGRectMake(padding, (padding * 2),
    screen.size.width - (2 * padding), 27.f);
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.textColor = UIColor.whiteColor;
//  [self addSubview:titleLabel];
  
  UILabel *line = [UILabel new];
  line.backgroundColor = UIColor.whiteColor;
  line.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y +
    titleLabel.frame.size.height + (padding * 0.5), screen.size.width - 2 * padding, 1.5f);
  [self addSubview:line];
  
  // Close view
  float widthClose = 30.f;
  CGRect frameClose = CGRectMake((screen.size.width - widthClose) * .5f,
    screen.size.height - padding - widthClose, widthClose, widthClose);
  // Close button
  OMBCloseButtonView *closeView = [[OMBCloseButtonView alloc]
    initWithFrame:frameClose color:UIColor.whiteColor];
  [closeView.closeButton addTarget:self action:@selector(closeView)
    forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:closeView];
  
  // List
  float originTable = line.frame.origin.y + line.frame.size.height;
  float heightTable = screen.size.height - originTable -
    (screen.size.height - frameClose.origin.y) - padding * .5f;
  _table = [UITableView new];
  _table.backgroundColor = UIColor.clearColor;
  _table.contentInset = UIEdgeInsetsMake(0.0f, padding, 0.0f, -padding);
  _table.frame = CGRectMake(0.0f, originTable,
    screen.size.width, heightTable);
  _table.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self addSubview:_table];
  
  return self;
}

#pragma mark - Methods

- (void)closeView
{
  [UIView animateWithDuration:.2f animations:^{
    self.alpha = 0.0f;
  } completion:^(BOOL finished) {
    [self removeFromSuperview];
  }];
}

- (void)setupWithTitle:(NSString *)title inView:(UIView *)view;
{
  [backgroundBlurView refreshWithView:view];
  
//  titleLabel.text = title;
  
  [_table reloadData];
}

- (void)showView
{
  // show in front of all the views, controllers, whatever exists...
  self.alpha = 0.0f;
  [[UIApplication sharedApplication].keyWindow addSubview:self];
  
  [UIView animateWithDuration:0.2f animations:^{
    self.alpha = 1.0;
  }];
}

@end
