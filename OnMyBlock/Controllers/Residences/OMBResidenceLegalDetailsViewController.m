//
//  OMBResidenceLegalDetailsViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceLegalDetailsViewController.h"

#import "OMBViewController.h"
#import "OMBResidence.h"
#import "OMBViewControllerContainer.h"
#import "UIColor+Extensions.h"
#import "UIFont+OnMyBlock.h"

@interface OMBResidenceLegalDetailsViewController ()
{
  UILabel *detailLabel;
  NSMutableArray *detailStrings;
  OMBResidence *residence;
  UISegmentedControl *segmentedControl;
  NSMutableArray *webViewArray;
  BOOL isShowingDetail;
}

@end

@implementation OMBResidenceLegalDetailsViewController

#pragma mark - Initializer

- (id) initWithResidence: (OMBResidence *) object
{
  if (!(self = [super init])) return nil;

  residence = object;
  // self.title = @"Legal Details";

  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];

  self.navigationItem.rightBarButtonItem = shareBarButtonItem;
  self.view.backgroundColor = UIColor.whiteColor;
  
  CGRect screen = [self screen];
  CGFloat padding = OMBPadding;
  
  detailLabel = [UILabel new];
  detailLabel.font = [UIFont normalTextFont];
  detailLabel.frame = CGRectMake(padding, padding + OMBStandardHeight,
    screen.size.width - padding * 2, OMBStandardHeight);
  detailLabel.numberOfLines = 0;
  detailLabel.textColor = [UIColor textColor];
  [self.view addSubview: detailLabel];
  
  detailStrings = [NSMutableArray array];
  [detailStrings addObject:
    @"If your offer is accepted, we will email to you "
    @"(and your roommates if applicable) the lease to electronically sign, "
    @"and you will have 1 week to secure the place by signing the lease and "
    @"paying the first month’s rent and deposit through OnMyBlock."];
  [detailStrings addObject:
    @"As detailed in the lease, the landlord is required "
    @"to disclose to tenants any pertinent information about "
    @"the property througha Memo of Disclosure."];
  [detailStrings addObject:
    @"If the landlord requires co-signers, we will email "
    @"to you (and your roommates if applicable) the Co-signer Agreement for "
    @"electronic signature within 1 week of placing your offer."];
  
  segmentedControl = [[UISegmentedControl alloc] initWithItems:
    @[@"Lease", @"Memo", @"Cosigner"]];
  segmentedControl.apportionsSegmentWidthsByContent = YES;
  // CGRect segmentedFrame = segmentedControl.frame;
  // segmentedFrame.size.width = screen.size.width * 0.4;
  // segmentedControl.frame = segmentedFrame;
  segmentedControl.selectedSegmentIndex = 
    OMBResidenceLegalDetailsDocumentTypeLeaseAgreement;
  [segmentedControl addTarget: self action: @selector(segmentedControlChanged:)
    forControlEvents: UIControlEventValueChanged];
  self.navigationItem.titleView = segmentedControl;

  webViewArray = [NSMutableArray array];
  for (int i = 0; i < 3; i++) {
    UIWebView *webView = [[UIWebView alloc] initWithFrame: screen];
    //if (i > 0) {
      webView.frame = CGRectMake(0.0f, padding + OMBStandardHeight,
        screen.size.width, 
          screen.size.height - (padding + OMBStandardHeight));
    //}
    webView.hidden = YES;
    webView.scalesPageToFit = YES;
    webView.scrollView.delegate = self;
    [self.view addSubview: webView];
    [webViewArray addObject: webView];
  }
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  
  isShowingDetail = YES;
  [self segmentedControlChanged: segmentedControl];
  [self showDetailLabel];
}

#pragma mark - Protocol

#pragma mark - Protocol UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  CGFloat y = scrollView.contentOffset.y;
  if(y <= 0.0f){
    if(!isShowingDetail)
      [self showDetailLabel];
  }
  else if(y >= 100.0f){
    if(isShowingDetail)
      [self hideDetailLabel];
  }
  
}

#pragma mark - Methods

#pragma mark - Instance Methods

- (void) segmentedControlChanged: (UISegmentedControl *) control
{
  NSString *pathString;
  UIWebView *webView = [webViewArray objectAtIndex: 
    control.selectedSegmentIndex];
  if (!webView.request) {
    if (control.selectedSegmentIndex == 
      OMBResidenceLegalDetailsDocumentTypeLeaseAgreement) {
      pathString = @"lease_agreement";
    }
    else if (control.selectedSegmentIndex == 
      OMBResidenceLegalDetailsDocumentTypeMemoOfDisclosure) {
      pathString = @"memo_of_disclosure";
    }
    else if (control.selectedSegmentIndex == 
      OMBResidenceLegalDetailsDocumentTypeCosignerAgreement) {
      pathString = @"cosigner_agreement";
    }
    NSString *path = [[NSBundle mainBundle] pathForResource: pathString 
      ofType: @"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath: path];
    NSURLRequest *request = [NSURLRequest requestWithURL: targetURL];
    [webView loadRequest: request];
  }
  for (UIView *v in webViewArray) {
    v.hidden = YES;
  }
  
  detailLabel.text = [detailStrings
    objectAtIndex: control.selectedSegmentIndex];
  CGRect rect = [detailLabel.text boundingRectWithSize:
    CGSizeMake(detailLabel.frame.size.width, 666)
      options: NSStringDrawingUsesLineFragmentOrigin
        attributes: @{ NSFontAttributeName: detailLabel.font }
          context: nil];
  
  detailLabel.frame =
    CGRectMake(detailLabel.frame.origin.x,
      detailLabel.frame.origin.y,
        detailLabel.frame.size.width,
          OMBPadding + rect.size.height);
  
  if(webView.scrollView.contentOffset.y <= 0.0f){
    [self showDetailLabel];
  }
  else if(webView.scrollView.contentOffset.y > 95.0f){
      [self hideDetailLabel];
  }
  
  webView.hidden = NO;
}

- (void) shareButtonSelected
{
  NSArray *dataToShare = @[[residence legalDetailsShareString]];
  UIActivityViewController *activityViewController = 
    [[UIActivityViewController alloc] initWithActivityItems: dataToShare
      applicationActivities: nil];
  [activityViewController setValue: @"Legal details"
     forKey: @"subject"];
  [[self appDelegate].container.currentDetailViewController 
    presentViewController: activityViewController 
      animated: YES completion: nil];
}

-(void) showDetailLabel
{
  isShowingDetail = YES;
  CGRect screen = [self screen];
  UIWebView *web = (UIWebView *)
    [webViewArray objectAtIndex:
      segmentedControl.selectedSegmentIndex];
  
  CGRect previousRect = web.frame;
  
  CGFloat heightY = detailLabel.frame.size.height;
  previousRect.origin.y = OMBPadding + OMBStandardHeight + heightY;
  previousRect.size.height = screen.size.height -
    (OMBPadding + OMBStandardHeight + heightY);
  
  [UIView animateWithDuration: OMBStandardDuration animations:^{
    web.frame = previousRect;
  }];
}

-(void) hideDetailLabel
{
  isShowingDetail = NO;
  CGRect screen = [self screen];
  UIWebView *web = (UIWebView *)
    [webViewArray objectAtIndex:
      segmentedControl.selectedSegmentIndex];
  
  CGRect previousRect = web.frame;
  
  previousRect.origin.y = OMBPadding + OMBStandardHeight;
  previousRect.size.height = screen.size.height -
    (OMBPadding + OMBStandardHeight);
  
  [UIView animateWithDuration: OMBStandardDuration animations:^{
    web.frame = previousRect;
  }];
}

@end
