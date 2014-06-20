//
//  OMBHomebaseRenterViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 6/20/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterViewController.h"

// Categories
#import "NSString+Extensions.h"
// Fonts
#import "UIFont+OnMyBlock.h"
// Protocols
#import "OMBConnectionProtocol.h"
// Views
#import "OMBActivityViewFullScreen.h"
#import "OMBBlurView.h"
#import "UIColor+Extensions.h"

static CGFloat const HomebaseRenterImagePercentage = 0.15f;

@interface OMBHomebaseRenterViewController ()
<
  OMBConnectionProtocol,
  UIScrollViewDelegate,
  UITableViewDataSource,
  UITableViewDelegate
>
{
  UITableView *activityTableView;
  OMBActivityViewFullScreen *activityViewFullScreen;
  OMBBlurView *backView;
  CGFloat backViewOffsetY;
  UIRefreshControl *refreshControl;
}

@end

@implementation OMBHomebaseRenterViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.title = @"Homebase";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setMenuBarButtonItem];

  // Dimensions
  CGRect screen = [self screen];
  self.view     = [[UIView alloc] initWithFrame: screen];
  self.view.backgroundColor = [UIColor grayUltraLight];
  CGFloat padding        = OMBPadding;
  CGFloat screenHeight   = CGRectGetHeight(screen);
  CGFloat screenWidth    = CGRectGetWidth(screen);
  CGFloat standardHeight = OMBPadding;
  backViewOffsetY        = padding + standardHeight;

  // The image in the back
  CGRect backViewRect = CGRectMake(0.0f, 0.0f,
    screenWidth, (screenHeight * HomebaseRenterImagePercentage) +
    (padding + standardHeight + padding));
  backView = [[OMBBlurView alloc] initWithFrame: backViewRect];
  backView.blurRadius = 5.0f;
  backView.tintColor = [UIColor colorWithWhite: 0.0f alpha: 0.3f];
  [self.view addSubview: backView];

  // Main table view (activity)
  CGFloat tableViewOriginY = padding + standardHeight;
  CGRect tableViewFrame = CGRectMake(0.0f, tableViewOriginY,
    screenWidth, screenHeight - tableViewOriginY);
  // Activity table view
  activityTableView = [[UITableView alloc] initWithFrame: tableViewFrame
    style: UITableViewStylePlain];
  activityTableView.alwaysBounceVertical = YES;
  activityTableView.backgroundColor      = [UIColor clearColor];
  activityTableView.dataSource           = self;
  activityTableView.delegate             = self;
  activityTableView.separatorColor       = [UIColor grayLight];
  activityTableView.separatorInset = UIEdgeInsetsMake(0.0f, padding,
    0.0f, 0.0f);
  [self.view addSubview: activityTableView];

  UIView *activityTableViewHeader = [[UIView alloc] initWithFrame:
    CGRectMake(0.0f, 0.0f, activityTableView.frame.size.width,
      ((backView.frame.origin.y + backView.frame.size.height) -
      tableViewOriginY))];
  activityTableView.tableHeaderView = activityTableViewHeader;
  activityTableView.tableFooterView = [[UIView alloc] initWithFrame:
    CGRectZero];

  refreshControl = [UIRefreshControl new];
  [refreshControl addTarget: self action: @selector(refresh) 
    forControlEvents: UIControlEventValueChanged];
  refreshControl.tintColor = [UIColor lightTextColor];
  [activityTableView addSubview: refreshControl];

  // Welcome
  CGFloat totalLabelHeights = 27.0f + (22.0f * 2);
  UILabel *welcomeLabel = [UILabel new];
  welcomeLabel.font = [UIFont mediumTextFont];
  welcomeLabel.frame = CGRectMake(0.0f,
    (activityTableViewHeader.frame.size.height - totalLabelHeights) * 0.5f,
      activityTableViewHeader.frame.size.width, 27.0f);
  welcomeLabel.text = @"Welcome to your Homebase.";
  welcomeLabel.textAlignment = NSTextAlignmentCenter;
  welcomeLabel.textColor = [UIColor whiteColor];
  [activityTableViewHeader addSubview: welcomeLabel];
  // Description
  UILabel *descriptionLabel = [UILabel new];
  NSString *descriptionString = @"Review all your applications \n"
    @"and bookings here.";
  descriptionLabel.attributedText = 
    [descriptionString attributedStringWithFont:
      [UIFont normalTextFont] lineHeight: 22.0f];
  descriptionLabel.frame = CGRectMake(0.0f,
    welcomeLabel.frame.origin.y + welcomeLabel.frame.size.height,
      activityTableViewHeader.frame.size.width, 22.0f * 2);
  descriptionLabel.numberOfLines = 2;
  descriptionLabel.textColor = welcomeLabel.textColor;
  descriptionLabel.textAlignment = welcomeLabel.textAlignment;
  [activityTableViewHeader addSubview: descriptionLabel];

  activityViewFullScreen = [[OMBActivityViewFullScreen alloc] init];
  [self.view addSubview: activityViewFullScreen];
}

@end
