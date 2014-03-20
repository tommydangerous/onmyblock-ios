//
//  OMBResidenceLegalDetailsViewController.m
//  OnMyBlock
//
//  Created by Tecla Labs - Mac Mini 4 on 14/03/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

#import "OMBResidenceLegalDetailsViewController.h"
#import "NSString+Extensions.h"
#import "OMBViewControllerContainer.h"
#import <QuartzCore/QuartzCore.h>


@implementation OMBResidenceLegalDetailsViewController
@synthesize originalFrame;
@synthesize screenWidth;
@synthesize screenHeight;
@synthesize deltaY;

#pragma mark - Initializer

- (id) init
{
    if (!(self = [super init])) return nil;
    
    //self.screenName = self.title = @"Lease Agreement";
    
    UIFont *font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
    CGFloat lineHeight = 20.0f;
    
    NSString *string1 =
    @"As detailed in the lease, the landlord is required to disclose to tenants any pertinent information about "
    @"the property through a Memo of Disclosure.";

    text1 = [string1 attributedStringWithFont: font lineHeight: lineHeight];
    
    NSString *string2 =
    @"California";
    text2 = [string2 attributedStringWithFont: font lineHeight: lineHeight];
    
    NSString *string3 =
    @"Lessors of real property in California are statutorily required to disclose the following information to prospective lessees prior to the lessee signing the rental agreement.";
    text3 = [string3 attributedStringWithFont: font lineHeight: lineHeight];
    
    NSString *string4 =
    @"a. Material Facts Affecting Value or Desirability of Premises – Civ. Code § 2079";
    text4 = [string4 attributedStringWithFont: font lineHeight: lineHeight];
    
    NSString *string5 =
    @"Lessors owe a duty to disclose to prospective lessees any characteristics or conditions of the rental"
    @"premises that are known or accessible only to the landlord which materially affect the value or desirabil- ity of the premises in light of the lessee’s intended and disclosed use. Lessees who suffer damage by a breach of this duty may have a damages cause of action against their lessor for fraud.";
    text5 = [string5 attributedStringWithFont: font lineHeight: lineHeight];
    
    NSString *string6 =
    @"b. Megan’s Law Notice";
    text6 = [string6 attributedStringWithFont: font lineHeight: lineHeight];
    
    NSString *string7 =
    @"Landlords must include the following language, in at least 8-point type, in rental agreements: "
    @"Notice: Pursuant to Section 290.46 of the California Penal Code, information about specified registered sex offenders is made available to the public via an Internet Web site maintained by the Department of Justice at www.meganslaw.ca.gov. Depending on an offender’s criminal history, this information will include either the address at which the offender resides or the community of residence and ZIP Code in which he or she resides.";
    text7 = [string7 attributedStringWithFont: font lineHeight: lineHeight];
    
    NSString *string8 =
    @"c. Hazardous Substances";
    text8 = [string8 attributedStringWithFont: font lineHeight: lineHeight];
    
    NSString *string9 =
    @"i. Lead Warning Statement and Disclosure – 24 CFR § 35.92(b)"
    @"Each contract to lease target housing (residential properties constructed before 1978) shall include, as an attachment or within the contract, the following elements, in the language of the contract (e.g., English, Spanish):";
    text9 = [string9 attributedStringWithFont: font lineHeight: lineHeight];
    return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
    [self appDelegate].container.slideEnabled=NO;
    
    [super loadView];
    
    self.view.clipsToBounds = YES;
    
    //Add pinchToZoom
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
    [self.table addGestureRecognizer:pinchGesture];
    CGRect wh =  [[UIScreen mainScreen]bounds];
	screenWidth = wh.size.width;
	screenHeight = wh.size.height;
	
    deltaY = 5;

    self.table.backgroundColor = [UIColor whiteColor];

    // Title view
    CGRect screen      = [[UIScreen mainScreen] bounds];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:
                        @[@"Lease", @"Co-Signer" ,@"Memo"]];
    segmentedControl.selectedSegmentIndex = 1;
    CGRect segmentedFrame = segmentedControl.frame;
    segmentedFrame.size.width = screen.size.width * 0.4;
    segmentedControl.frame = segmentedFrame;
    [segmentedControl addTarget: self action: @selector(switchViews:)
               forControlEvents: UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    
    UIBarButtonItem *shareBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
     UIBarButtonSystemItemAction target: self
                                                  action: @selector(shareButtonSelected)];
    // UIBarButtonItem *shareBarButtonItem =
    //   [[UIBarButtonItem alloc] initWithTitle: @"Share"
    //     style: UIBarButtonItemStylePlain target: self
    //       action: @selector(shareButtonSelected)];
    self.navigationItem.rightBarButtonItem = shareBarButtonItem;


}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self appDelegate].container.slideEnabled=NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self appDelegate].container.slideEnabled=YES;
}

#pragma mark - Selectors

- (void) switchViews: (UISegmentedControl *) control
{
   // [self resetTable];
    self.view.clipsToBounds = YES;
    CGRect wh =  [[UIScreen mainScreen]bounds];
	screenWidth = wh.size.width;
	screenHeight = wh.size.height;
    deltaY = 5;
    
    

    UIFont *font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 15];
    CGFloat lineHeight = 20.0f;
    switch (control.selectedSegmentIndex) {
            
        case 0: {
            
           
            NSString *string1 =
            @"If your offer is accepted, we will email to you (and your roommates if applicable) the lease to"
            @"electronically sign, and you will have 1 week to secure the place by signing the lease and paying the"
            @"first month’s rent and deposit through OnMyBlock."
            @"RESIDENTIAL LEASE AGREEMENT";
            text1 = [string1 attributedStringWithFont: font lineHeight: lineHeight];
            
            NSString *string2 =
            @"If the guest cancels less than 5 days in advance, the first night "
            @"is non-refundable but the remaining nights will be 50% refunded";
            text2 = [string2 attributedStringWithFont: font lineHeight: lineHeight];
            
            NSString *string3 =
            @"If the guest arrives and decides to leave early, the nights not spent "
            @"24 hours after the cancellation occurs are 50% refunded.";
            text3 = [string3 attributedStringWithFont: font lineHeight: lineHeight];
            
            NSString *string4 =
            @"Cleaning fees are always refunded if the guest did not check in. "
            @"The OnMyBlock service fee is non-refundable.";
            text4 = [string4 attributedStringWithFont: font lineHeight: lineHeight];
            break;
                }
        case 1: {
          
            NSString *string1 =
            @"As detailed in the lease, the landlord is required to disclose to tenants any pertinent information about "
            @"the property through a Memo of Disclosure.";
            
            text1 = [string1 attributedStringWithFont: font lineHeight: lineHeight];
            
            NSString *string2 =
            @"California";
            text2 = [string2 attributedStringWithFont: font lineHeight: lineHeight];
            
            NSString *string3 =
            @"Lessors of real property in California are statutorily required to disclose the following information to prospective lessees prior to the lessee signing the rental agreement.";
            text3 = [string3 attributedStringWithFont: font lineHeight: lineHeight];
            
            NSString *string4 =
            @"a. Material Facts Affecting Value or Desirability of Premises – Civ. Code § 2079";
            text4 = [string4 attributedStringWithFont: font lineHeight: lineHeight];
            
            NSString *string5 =
            @"Lessors owe a duty to disclose to prospective lessees any characteristics or conditions of the rental"
            @"premises that are known or accessible only to the landlord which materially affect the value or desirabil- ity of the premises in light of the lessee’s intended and disclosed use. Lessees who suffer damage by a breach of this duty may have a damages cause of action against their lessor for fraud.";
            text5 = [string5 attributedStringWithFont: font lineHeight: lineHeight];
            
            NSString *string6 =
            @"b. Megan’s Law Notice";
            text6 = [string6 attributedStringWithFont: font lineHeight: lineHeight];
            
            NSString *string7 =
            @"Landlords must include the following language, in at least 8-point type, in rental agreements: "
            @"Notice: Pursuant to Section 290.46 of the California Penal Code, information about specified registered sex offenders is made available to the public via an Internet Web site maintained by the Department of Justice at www.meganslaw.ca.gov. Depending on an offender’s criminal history, this information will include either the address at which the offender resides or the community of residence and ZIP Code in which he or she resides.";
            text7 = [string7 attributedStringWithFont: font lineHeight: lineHeight];
            
            NSString *string8 =
            @"c. Hazardous Substances";
            text8 = [string8 attributedStringWithFont: font lineHeight: lineHeight];
            
            NSString *string9 =
            @"i. Lead Warning Statement and Disclosure – 24 CFR § 35.92(b)"
            @"Each contract to lease target housing (residential properties constructed before 1978) shall include, as an attachment or within the contract, the following elements, in the language of the contract (e.g., English, Spanish):";
            text9 = [string9 attributedStringWithFont: font lineHeight: lineHeight];
            break;
        }
        case 2: {
           
            NSString *string1 =
            @"BRUNO For a full refund, cancellation must be made five full days prior to "
            @"listing's local check in time (or 3:00 PM if not specified) on the day "
            @"of check in. For example, if check-in is on Friday, cancel by the "
            @"previous Sunday before check in time.";
            text1 = [string1 attributedStringWithFont: font lineHeight: lineHeight];
            
            NSString *string2 =
            @"If the guest cancels less than 5 days in advance, the first night "
            @"is non-refundable but the remaining nights will be 50% refunded";
            text2 = [string2 attributedStringWithFont: font lineHeight: lineHeight];
            
            NSString *string3 =
            @"If the guest arrives and decides to leave early, the nights not spent "
            @"24 hours after the cancellation occurs are 50% refunded.";
            text3 = [string3 attributedStringWithFont: font lineHeight: lineHeight];
            
            NSString *string4 =
            @"Cleaning fees are always refunded if the guest did not check in. "
            @"The OnMyBlock service fee is non-refundable.";
            text4 = [string4 attributedStringWithFont: font lineHeight: lineHeight];
            break;
        }
        default:
            break;
    }
    
    [self.table reloadData];
  
}

- (void) shareButtonSelected
{
    /*NSArray *dataToShare = @[[residence shareString]];
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems: dataToShare
                                      applicationActivities: nil];
    [activityViewController setValue: @"Check out this listing on OnMyBlock!"
                              forKey: @"subject"];
    [[self appDelegate].container.currentDetailViewController
     presentViewController: activityViewController
     animated: YES completion: nil];*/
}


#pragma mark - Protocol

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return 1;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
          cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CellIdentifier];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;
    NSAttributedString *text = [NSAttributedString new];
    if (indexPath.row == 0) {
        text = text1;
    }
    else if (indexPath.row == 1) {
        text = text2;
    }
    else if (indexPath.row == 2) {
        text = text3;
    }
    else if (indexPath.row == 3) {
        text = text4;
    }
    else if (indexPath.row == 4) {
        text = text5;
    }
    else if (indexPath.row == 5) {
        text = text6;
    }
    else if (indexPath.row == 6) {
        text = text7;
    }
    else if (indexPath.row == 7) {
        text = text8;
    }
    else if (indexPath.row == 8) {
        text = text9;
    }
    
    
    cell.textLabel.attributedText = text;
    return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return 9;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    CGFloat padding = 20.0f;
    CGFloat maxWidth = tableView.frame.size.width -
    (tableView.separatorInset.left * 2);
    NSAttributedString *text = [NSAttributedString new];
    if (indexPath.row == 0) {
        text = text1;
    }
    else if (indexPath.row == 1) {
        text = text2;
    }
    else if (indexPath.row == 2) {
        text = text3;
    }
    else if (indexPath.row == 3) {
        text = text4;
    }
    return padding + [text boundingRectWithSize: 
                      CGSizeMake(maxWidth, 9999) options: NSStringDrawingUsesLineFragmentOrigin 
                                        context: nil].size.height + padding;
}

#pragma mark - UIGestureRecognizer Delegates And Methods

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    
 
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
		UIView *piece = gestureRecognizer.view;
		originalFrame.size.height = self.view.frame.size.height;
		self.originalFrame = self.view.frame;
        
        CGPoint locationInView = [gestureRecognizer locationInView:nil];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
		
		UIInterfaceOrientation orientaion = [[UIDevice currentDevice]orientation];
        
		/*some times Device gives unknown orientaion
         If Device orientaion is unkown check orientaion of status bar
         */
		if( orientaion != UIInterfaceOrientationPortrait  && orientaion != UIInterfaceOrientationPortraitUpsideDown &&orientaion != UIInterfaceOrientationLandscapeLeft && orientaion != UIInterfaceOrientationLandscapeRight) {
			
			orientaion = [[UIApplication sharedApplication] statusBarOrientation];
		}
		
		if( orientaion == UIInterfaceOrientationPortrait ) {
			
		}
		
		else if ( orientaion == UIInterfaceOrientationPortraitUpsideDown ) {
			
			locationInView.x = screenWidth - locationInView.x;
			locationInView.y = (screenHeight -20) - locationInView.y;
		}
		
		else if ( orientaion == UIInterfaceOrientationLandscapeLeft ) {
			
			float x =  screenHeight - locationInView.y;
			float y = locationInView.x;
			
			locationInView.x = x;
			locationInView.y = y;
			
		}
		else if ( orientaion == UIInterfaceOrientationLandscapeRight ) {
			
			float y =  locationInView.y;
			float x = screenWidth - locationInView.x;
			
			locationInView.x = y;
			locationInView.y = x;
		}
        
		piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, (locationInView.y -deltaY) / piece.bounds.size.height);
        
        piece.center = locationInSuperview;
		
        if (locationInView.x <screenWidth)
            [self resetTable];
    }
	
	else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.originalFrame = self.view.frame;
        if ( self.table.frame.origin.x > self.originalFrame.origin.x)
		   [self resetTable];

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
        [panGesture setDelegate:self];
        [self.table addGestureRecognizer:panGesture];

	}
	
}

- (void)resetTable {
	
	[UIView beginAnimations:nil context:nil];
	[self.table setTransform:CGAffineTransformIdentity];
	self.table.frame = originalFrame;
	[UIView commitAnimations];
}

- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer {
    
	
	[self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
		[gestureRecognizer setScale:1];
    }
}



- (void)panPiece:(UIPanGestureRecognizer *)recognizer {
	
  //[self.navigationController.view.superview.superview.superview setFrame:CGRectMake(0,0,1150,1800)];

    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    

    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        [self.table removeGestureRecognizer:recognizer];
    }
}


@end

