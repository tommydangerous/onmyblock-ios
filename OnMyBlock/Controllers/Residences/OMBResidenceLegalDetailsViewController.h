//
//  OMBResidenceLegalDetailsViewController.h
//  OnMyBlock
//
//  Created by Tecla Labs - Mac Mini 4 on 14/03/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMBTableViewController.h"


@interface OMBResidenceLegalDetailsViewController : OMBTableViewController<UIGestureRecognizerDelegate>
{
  NSAttributedString *text1;
  NSAttributedString *text2;
  NSAttributedString *text3;
  NSAttributedString *text4;
  NSAttributedString *text5;
  NSAttributedString *text6;
  NSAttributedString *text7;
  NSAttributedString *text8;
  NSAttributedString *text9;
  NSAttributedString *text10;
  NSAttributedString *text11;
  NSAttributedString *text12;
  NSAttributedString *text13;
  NSAttributedString *text14;
  NSAttributedString *text15;
  UIScrollView *scrollView;
  UISegmentedControl *segmentedControl;
  CGFloat lastScale;
}

@property (nonatomic, readwrite) CGRect originalFrame;
@property (nonatomic, readwrite) CGFloat screenWidth;
@property (nonatomic, readwrite) CGFloat screenHeight;
@property (nonatomic, readwrite) CGFloat deltaY;
- (void) resetTable;


@end
