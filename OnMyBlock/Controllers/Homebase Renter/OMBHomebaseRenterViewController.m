//
//  OMBHomebaseBuyerViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 1/6/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBHomebaseRenterViewController.h"

#import "AMBlurView.h"
#import "DRNRealTimeBlurView.h"
#import "OMBCenteredImageView.h"
#import "OMBExtendedHitAreaViewContainer.h"
#import "OMBHomebaseRenterRoommateImageView.h"
#import "UIColor+Extensions.h"

@implementation OMBHomebaseRenterViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = @"Homebase Renter";
  self.title      = @"Tommy's Homebase";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  [self setMenuBarButtonItem];

  selectedSegmentIndex = 0;

  CGRect screen = [[UIScreen mainScreen] bounds];
  self.view     = [[UIView alloc] initWithFrame: screen];
  self.view.backgroundColor = [UIColor grayUltraLight];

  CGFloat screenHeight = screen.size.height;
  CGFloat screenWidth  = screen.size.width;
  CGFloat padding      = 20.0f;
  CGFloat standardHeight = 44.0f;

  backViewOffsetY = padding + standardHeight;
  // The image in the back
  backView = [UIView new];
  backView.frame = CGRectMake(0.0f, 0.0f, 
    screenWidth, (screenHeight * 0.4f));
  [self.view addSubview: backView];
  // Image of residence
  OMBCenteredImageView *residenceImageView = 
    [[OMBCenteredImageView alloc] init];
  residenceImageView.frame = backView.frame;  
  residenceImageView.image = [UIImage imageNamed: 
    @"intro_still_image_slide_3_background.jpg"];
  [backView addSubview: residenceImageView];
  // Black tint
  UIView *colorView = [[UIView alloc] init];
  colorView.backgroundColor = [UIColor colorWithWhite: 1.0f alpha: 0.5f];
  colorView.frame = residenceImageView.frame;
  [backView addSubview: colorView];
  // Blur
  DRNRealTimeBlurView *blurView = [[DRNRealTimeBlurView alloc] init];
  blurView.blurRadius = 0.3f;
  blurView.frame = residenceImageView.frame;  
  blurView.renderStatic = YES;
  [backView addSubview: blurView];

  CGFloat imageSize = backView.frame.size.width / 3.0f;
  // Images scroll
  imagesScrollView = [UIScrollView new];
  imagesScrollView.clipsToBounds = NO;
  imagesScrollView.delegate = self;
  imagesScrollView.frame = CGRectMake(
    (backView.frame.size.width - imageSize) * 0.5f, 0.0f, 
      imageSize, backView.frame.size.height);
  imagesScrollView.contentSize = CGSizeMake(screenWidth * 10, 
    imagesScrollView.frame.size.height);
  imagesScrollView.pagingEnabled = YES;
  imagesScrollView.showsHorizontalScrollIndicator = NO;
  [backView addSubview: imagesScrollView];

  // Extended hit area for images scroll
  OMBExtendedHitAreaViewContainer *extendedHitArea = 
    [[OMBExtendedHitAreaViewContainer alloc] init];
  extendedHitArea.frame = backView.frame;
  extendedHitArea.scrollView = imagesScrollView;
  [backView addSubview: extendedHitArea];

  // Need to do this or else blur is off
  backView.frame = CGRectMake(0.0f, backViewOffsetY,
    backView.frame.size.width, backView.frame.size.height);

  imageViewArray = [NSMutableArray array];

  for (int i = 0; i < 10; i++) {
    CGRect rect = CGRectMake(imageSize * i, 0.0f, 
      imageSize, backView.frame.size.height);
    OMBHomebaseRenterRoommateImageView *imageView = 
      [[OMBHomebaseRenterRoommateImageView alloc] initWithFrame: rect];
    if (i % 2) {
      imageView.imageView.image = [UIImage imageNamed: @"tommy_d.png"];
      imageView.nameLabel.text = @"Tommy";
    }
    else {
      imageView.imageView.image = [UIImage imageNamed: @"edward_d.jpg"];
      imageView.nameLabel.text = @"Edward";
    }
    [imageViewArray addObject: imageView];
    [imagesScrollView addSubview: imageView];
  }
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  [imagesScrollView setContentOffset: 
    CGPointMake(imagesScrollView.frame.size.width, 0.0f) animated: NO];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;
  
  CGFloat percent = 0.0f;
  if (scrollView == imagesScrollView) {
    CGFloat width = scrollView.frame.size.width;
    CGFloat x     = scrollView.contentOffset.x;
    CGFloat page  = x / width;
    // Scale the slide views
    for (UIView *iView in imageViewArray) {
      percent = (x - (width * [imageViewArray indexOfObject: iView])) / width;
      if (percent < 0)
        percent *= -1;
      CGFloat scalePercent = 1 - percent;
      if (scalePercent > 1)
        scalePercent = 1;
      else if (scalePercent < 0.5f)
        scalePercent = 0.5f;
      iView.transform = CGAffineTransformMakeScale(scalePercent, scalePercent);
    }
  }
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return 0;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: CellIdentifier];
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return 0;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView 
heightForHeaderInSection: (NSInteger) section
{
  return 0.0f;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 0.0f;
}

- (UIView *) tableView: (UITableView *) tableView 
viewForHeaderInSection: (NSInteger) section
{
  CGFloat padding = 20.0f;
  AMBlurView *blurView = [[AMBlurView alloc] init];
  blurView.blurTintColor = [UIColor blueLight];
  blurView.frame = CGRectMake(0.0f, 0.0f, 
    tableView.frame.size.width, 13.0f * 2);
  UILabel *label = [UILabel new];
  label.font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: 13];
  label.frame = CGRectMake(padding, 0.0f, 
    blurView.frame.size.width - (padding * 2), blurView.frame.size.height);
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor blueDark];
  [blurView addSubview: label];
  NSString *titleString = @"";
  label.text = titleString;
  return blurView;
}

@end
