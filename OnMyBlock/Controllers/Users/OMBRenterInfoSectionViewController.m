//
//  OMBRenterInfoSectionViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/10/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBRenterInfoSectionViewController.h"

#import "AMBlurView.h"
#import "NSString+Extensions.h"
#import "OMBNavigationController.h"
#import "OMBRenterInfoAddViewController.h"
#import "OMBUser.h"
#import "UIColor+Extensions.h"
#import "UIImage+Color.h"

@interface OMBRenterInfoSectionViewController ()
{
  OMBUser *user;
}

@end

@implementation OMBRenterInfoSectionViewController

#pragma mark - Initializer

- (id) initWithUser: (OMBUser *) object
{
  if (!(self = [super init])) return nil;

  user = object;

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.navigationItem.rightBarButtonItem = doneBarButtonItem;

  CGRect screen        = [self screen];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;

  // Bottom blur view
  bottomBlurView = [[AMBlurView alloc] init];
  bottomBlurView.blurTintColor = [UIColor blue];
  bottomBlurView.frame = CGRectMake(0.0f, 
    screenHeight - OMBStandardButtonHeight, 
      screenWidth, OMBStandardButtonHeight);
  [self.view addSubview: bottomBlurView];
  // Add button
  addButton = [UIButton new];
  addButton.frame = bottomBlurView.bounds;
  addButton.titleLabel.font = [UIFont mediumTextFontBold];
  [addButton addTarget: self action: @selector(addButtonSelected)
    forControlEvents: UIControlEventTouchUpInside];
  [addButton setBackgroundImage: 
    [UIImage imageWithColor: [UIColor blueHighlighted]] 
      forState: UIControlStateHighlighted];
  [addButton setTitle: @"Add" forState: UIControlStateNormal];
  [addButton setTitleColor: [UIColor whiteColor] 
    forState: UIControlStateNormal];
  [bottomBlurView addSubview: addButton];

  // Empty label
  emptyLabel = [UILabel new];
  emptyLabel.font = [UIFont mediumTextFont];
  emptyLabel.numberOfLines = 0;
  emptyLabel.textColor = [UIColor grayMedium];
  [self.view addSubview: emptyLabel];
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) addButtonSelected
{
  if (addViewController)
    [self presentViewController: 
      [[OMBNavigationController alloc] initWithRootViewController: 
        addViewController] animated: YES completion: nil];
}

- (void) done
{
  [self.navigationController popViewControllerAnimated: YES];
}

- (void) setEmptyLabelText: (NSString *) string
{
  CGRect screen        = [self screen];
  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;

  emptyLabel.attributedText = [string attributedStringWithFont: 
    emptyLabel.font lineHeight: 27.0f];
  CGRect rect = [emptyLabel.attributedText boundingRectWithSize: 
    CGSizeMake(screenWidth - (OMBPadding * 2), 9999.0f)
      options: NSStringDrawingUsesLineFragmentOrigin context: nil];
  emptyLabel.frame = CGRectMake(OMBPadding, 
    (screenHeight - rect.size.height) * 0.5f, 
      screenWidth - (OMBPadding * 2), rect.size.height);
  emptyLabel.textAlignment = NSTextAlignmentCenter;
}

@end
