//
//  OMBResidenceLegalDetailsViewController.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 3/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceLegalDetailsViewController.h"

#import "OMBResidence.h"
#import "OMBViewControllerContainer.h"

@interface OMBResidenceLegalDetailsViewController ()
{
  OMBResidence *residence;
  UISegmentedControl *segmentedControl;
  NSMutableArray *webViewArray;
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

  CGRect screen = [self screen];

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
    if (i > 0) {
      webView.frame = CGRectMake(0.0f, OMBPadding + OMBStandardHeight,
        screen.size.width, 
          screen.size.height - (OMBPadding + OMBStandardHeight));
    }
    webView.hidden = YES;
    webView.scalesPageToFit = YES;
    [self.view addSubview: webView];
    [webViewArray addObject: webView];
  }
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  
  [self segmentedControlChanged: segmentedControl];
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

@end
