//
//  OMBFullListView.h
//  OnMyBlock
//
//  Created by Paul Aguilar on 8/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

@class OMBBlurView;

@interface OMBFullListView : UIView
{
  NSArray *arrayObjects;
  OMBBlurView *backgroundBlurView;
  UILabel *titleLabel;
}

@property (nonatomic, strong) UITableView *table;

#pragma mark -  Methods

- (void)closeView;
- (void)setupWithTitle:(NSString *)title inView:(UIView *)view;
- (void)showView;

@end
