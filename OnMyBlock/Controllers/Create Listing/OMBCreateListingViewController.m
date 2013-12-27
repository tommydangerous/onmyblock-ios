//
//  OMBCreateListingViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBCreateListingViewController.h"

#import "OMBCreateListingPropertyTypeView.h"
#import "OMBExtendedHitAreaViewContainer.h"
#import "UIColor+Extensions.h"

@implementation OMBCreateListingViewController

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  self.screenName = @"Create Listing";
  self.title      = @"Type of Place";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Back"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(back)];
  cancelBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Cancel"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(cancel)];
  nextBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle: @"Next"
      style: UIBarButtonItemStylePlain target: self
        action: @selector(next)];
  self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
  self.navigationItem.rightBarButtonItem = nextBarButtonItem;

  CGRect screen       = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screen.size.width;

  UIView *headerView = [UIView new];
  [self.view addSubview: headerView];

  UIView *progressBarBackground = [UIView new];
  progressBarBackground.backgroundColor = [UIColor grayUltraLight];
  progressBarBackground.frame = CGRectMake(0.0f, 0.0f, screenWidth, 20.0f);
  [headerView addSubview: progressBarBackground];

  progressBar = [UIView new];
  progressBar.backgroundColor = [UIColor green];
  progressBar.frame = CGRectMake(0.0f, 0.0f, 0.0f, 
    progressBarBackground.frame.size.height);
  [progressBarBackground addSubview: progressBar];

  stepLabel = [UILabel new];
  stepLabel.frame = CGRectMake(0.0f, progressBarBackground.frame.origin.y + 
    progressBarBackground.frame.size.height, screenWidth, 54.0f);
  stepLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 36];
  stepLabel.text = @"Step 1";
  stepLabel.textAlignment = NSTextAlignmentCenter;
  stepLabel.textColor = [UIColor blueDark];
  [headerView addSubview: stepLabel];

  questionLabel = [UILabel new];
  questionLabel.frame = CGRectMake(0.0f, stepLabel.frame.origin.y +
    stepLabel.frame.size.height, screenWidth, 36.0f);
  questionLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18];
  questionLabel.text = @"Choose type of place and tap next";
  questionLabel.textAlignment = stepLabel.textAlignment;
  questionLabel.textColor = [UIColor textColor];
  [headerView addSubview: questionLabel];

  headerView.frame = CGRectMake(0.0f, 20.0f + 44.0f, screenWidth, 
    progressBarBackground.frame.size.height + stepLabel.frame.size.height +
      stepLabel.frame.size.height);

  CGFloat tableViewHeight = screen.size.height - 
    (headerView.frame.origin.y + headerView.frame.size.height);
  CGFloat propertyTypeScrollViewWidth = screenWidth * 0.5f;

  OMBExtendedHitAreaViewContainer *propertyTypeExtended = 
    [[OMBExtendedHitAreaViewContainer alloc] init];
  propertyTypeExtended.frame = CGRectMake(0.0f, 
    screen.size.height - tableViewHeight, screenWidth, tableViewHeight);
  [self.view addSubview: propertyTypeExtended];

  propertyTypeScrollView = [UIScrollView new];
  propertyTypeScrollView.bounces = YES;
  propertyTypeScrollView.clipsToBounds = NO;
  propertyTypeScrollView.contentSize = 
    CGSizeMake(propertyTypeScrollViewWidth * 3, tableViewHeight);
  propertyTypeScrollView.delegate = self;
  propertyTypeScrollView.frame = CGRectMake(
    (screenWidth - propertyTypeScrollViewWidth) * 0.5, 0.0f, 
      propertyTypeScrollViewWidth, tableViewHeight);
  propertyTypeScrollView.pagingEnabled = YES;
  propertyTypeScrollView.showsHorizontalScrollIndicator = NO;
  [propertyTypeExtended addSubview: propertyTypeScrollView];
  propertyTypeExtended.scrollView = propertyTypeScrollView;

  housePropertyTypeView = 
    [[OMBCreateListingPropertyTypeView alloc] initWithFrame: CGRectMake(
      propertyTypeScrollView.frame.size.width * 0, 0.0f,
        propertyTypeScrollView.frame.size.width, 
          propertyTypeScrollView.frame.size.height)
    ];
  housePropertyTypeView.imageView.image = 
    [UIImage imageNamed: @"house_icon.png"];
  housePropertyTypeView.label.text = @"House";
  [propertyTypeScrollView addSubview: housePropertyTypeView];
  subletPropertyTypeView = 
    [[OMBCreateListingPropertyTypeView alloc] initWithFrame: CGRectMake(
      propertyTypeScrollView.frame.size.width * 1, 0.0f,
        propertyTypeScrollView.frame.size.width, 
          propertyTypeScrollView.frame.size.height)
    ];
  subletPropertyTypeView.imageView.image = 
    [UIImage imageNamed: @"sublet_icon.png"];
  subletPropertyTypeView.label.text = @"Sublet";
  [propertyTypeScrollView addSubview: subletPropertyTypeView];
  apartmentPropertyTypeView = 
    [[OMBCreateListingPropertyTypeView alloc] initWithFrame: CGRectMake(
      propertyTypeScrollView.frame.size.width * 2, 0.0f,
        propertyTypeScrollView.frame.size.width, 
          propertyTypeScrollView.frame.size.height)
    ];
  apartmentPropertyTypeView.imageView.image = 
    [UIImage imageNamed: @"apartment_icon.png"];
  apartmentPropertyTypeView.label.text = @"Apartment";
  [propertyTypeScrollView addSubview: apartmentPropertyTypeView];

  propertyTypeViewArray = @[
    housePropertyTypeView, subletPropertyTypeView, apartmentPropertyTypeView
  ];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];

  CGRect screen = [[UIScreen mainScreen] bounds];

  CGRect progressBarRect = progressBar.frame;
  progressBarRect.size.width = screen.size.width / 3.0f;
  [UIView animateWithDuration: 0.25f animations: ^{
    progressBar.frame = progressBarRect;
  }];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  stepNumber = 1;

  // Scroll to sublet property view for step 1
  [propertyTypeScrollView setContentOffset: 
    CGPointMake(propertyTypeScrollView.frame.size.width * 1, 0.0f)
      animated: NO];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollView

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  if (scrollView == propertyTypeScrollView) {
    CGFloat width = scrollView.frame.size.width;
    CGFloat x     = scrollView.contentOffset.x;
    CGFloat page  = x / width;
    for (OMBCreateListingPropertyTypeView *pv in propertyTypeViewArray) {
      int index = [propertyTypeViewArray indexOfObject: pv];
      CGFloat percent = (x - (width * index)) / width;
      if (percent < 0)
        percent *= -1;
      CGFloat scalePercent = 1 - percent;
      if (scalePercent > 1)
        scalePercent = 1;
      else if (scalePercent < 0.5f)
        scalePercent = 0.5f;
      pv.alpha = scalePercent;
      pv.transform = CGAffineTransformMakeScale(scalePercent, scalePercent);
      if (index < page + 0.5 && index > page - 0.5) {
        pv.label.textColor = [UIColor blueDark];
      }
      else {
        pv.label.textColor = [UIColor grayMedium];
      }
    }
  }
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  // Subclasses implement this
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
    CellIdentifier];
  if (!cell)
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault 
      reuseIdentifier: CellIdentifier];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{  
  return 0.0f;
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) back
{
  if (stepNumber > 1) {
    stepNumber -= 1;
    if (stepNumber == 1) {
      [self.navigationItem setLeftBarButtonItem: cancelBarButtonItem
        animated: YES];
      [self.navigationItem setRightBarButtonItem: nextBarButtonItem
        animated: YES];
      CGRect screen = [[UIScreen mainScreen] bounds];
      CGRect progressBarRect = progressBar.frame;
      progressBarRect.size.width = screen.size.width * (stepNumber / 3.0f);
      [UIView animateWithDuration: 0.25f animations: ^{
        progressBar.frame = progressBarRect;
      }];
    }
    NSLog(@"BACK");
  }
}

- (void) cancel
{
  [self.navigationController dismissViewControllerAnimated: YES
    completion: nil];
}

- (void) next
{
  if (stepNumber < 3) {
    stepNumber += 1;
    if (stepNumber > 1) {
      [self.navigationItem setLeftBarButtonItem: backBarButtonItem
        animated: YES];
      [self.navigationItem setRightBarButtonItem: nextBarButtonItem
        animated: YES];

      CGRect screen = [[UIScreen mainScreen] bounds];
      CGRect progressBarRect = progressBar.frame;
      progressBarRect.size.width = screen.size.width * (stepNumber / 3.0f);
      [UIView animateWithDuration: 0.25f animations: ^{
        progressBar.frame = progressBarRect;
      }];
    }
    NSLog(@"NEXT");
  }
}

@end
