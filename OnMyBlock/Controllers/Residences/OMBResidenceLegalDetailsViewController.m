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
#import "UIColor+Extensions.h"
#import <QuartzCore/QuartzCore.h>

#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.5

@implementation OMBResidenceLegalDetailsViewController
@synthesize originalFrame;
@synthesize screenWidth;
@synthesize screenHeight;
@synthesize deltaY;

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;
  return self;
}

#pragma mark - Override

#pragma mark - Override UIViewController

- (void) loadView
{
  [self appDelegate].container.slideEnabled=NO;
  
  [super loadView];
  self.title=@"Legal Details";
  
  //Add pinchToZoom
  UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
  [pinchGesture setDelegate:self];
  [self.table addGestureRecognizer:pinchGesture];
  
  UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scaleTapPiece:)];
  
  [tapGesture setDelegate:self];
  tapGesture.numberOfTapsRequired=2;
  [self.table addGestureRecognizer:tapGesture];
  
  [tapGesture requireGestureRecognizerToFail:pinchGesture];
  
  //Variables for GestureRecognizers
  CGRect wh =  [[UIScreen mainScreen]bounds];
	screenWidth = wh.size.width;
	screenHeight = wh.size.height;
  deltaY = 5;
  
  CGRect screen      = [[UIScreen mainScreen] bounds];
  segmentedControl = [[UISegmentedControl alloc] initWithItems:
                      @[@"Lease", @"Co-Signer" ,@"Memo"]];
  segmentedControl.selectedSegmentIndex = 1;
  segmentedControl.backgroundColor=[UIColor whiteColor];
  segmentedControl.tintColor=[UIColor blue];
  
  segmentedControl.frame = CGRectMake(32.0, 75.0, screen.size.width * 0.8, screen.size.width /10.0);
  [segmentedControl addTarget: self action: @selector(switchViews:)
             forControlEvents: UIControlEventValueChanged];
  
  [self.view addSubview:segmentedControl];
  
  originalFrame = CGRectMake(screen.size.width*0.05, 20.0 + screen.size.width /10.0, screen.size.width*0.9 , screen.size.height*0.9);
  self.table.frame=originalFrame;
  self.table.backgroundColor = [UIColor clearColor];
  self.view.clipsToBounds = YES;
  
  UIBarButtonItem *shareBarButtonItem =
  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
   UIBarButtonSystemItemAction target:self action: @selector(shareButtonSelected)];
  [tapGesture requireGestureRecognizerToFail:pinchGesture];
  
  self.navigationItem.rightBarButtonItem = shareBarButtonItem;
  [self switchViews:segmentedControl];
  
  
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
  [self resetTable];
  
  
  UIFont *font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 7.0];
  CGFloat lineHeight = 1.0f;
  switch (control.selectedSegmentIndex) {
      
    case 0: {
      
      
      NSString *string1 =
      @"If your offer is accepted, we will email to you (and your roommates if applicable) the lease to"
      @"electronically sign, and you will have 1 week to secure the place by signing the lease and paying the"
      @"first month’s rent and deposit through OnMyBlock.";
      text1 = [string1 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string2 =
      @"RESIDENTIAL LEASE AGREEMENT";
      text2 = [string2 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string3 =
      @"Address:__________________________________________ Unit:________________________";
      text3 = [string3 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string4 =
      @"UNIT DESCRIPTION\n"
      @"_______ Bedrooms\n"
      @"_______ Baths\n"
      @"Parking:_______________\n"
      @"Storage:_______________\n"
      @"Other:________________\n";
      text4 = [string4 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string5 =
      @"RENT DETAILS\n"
      @"Monthly Rent:_________________________\n"
      @"Security Deposit:_____________________\n"
      @"Payment Terms:________________________\n"
      @"Late Fee:_____________________________\n"
      @"Made Payable To:______________________\n"
      @"Payment Method:_______________________\n";
      text5 = [string5 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string6 =
      @"TERM DETAILS\n"
      @"Move-In Date:___________________\n"
      @"Move-Out Date:__________________\n"
      @"HOUSE RULES\n"
      @"No sublet (except with landlord permission, see section 3)\n"
      @"Dogs Allowed:____________  Cats Allowed:____________"
      @"Tenant responsible for payment of all utilities (except utilities listed in section 1)"
      @"House guests allowed less than 30 days";
      text6 = [string6 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string7 =
      @"TENANT\n"
      @"Dated:_______________ __________________________________\n"
      @"Dated:_______________ __________________________________\n"
      @"Dated:_______________ __________________________________\n"
      @"Dated:_______________ __________________________________\n"
      @"Each person who signs this Lease shall be jointly and severally responsible for the full performance of"
      @"each and every obligation in this Lease (including Additional “Key Terms” and “Additional Obligations"
      @"& Notices” below), even if they no longer live in the Premises.";
      text7 = [string7 attributedStringWithFont: font lineHeight: lineHeight];
      
      
      NSString *string8 =
      @"OWNER\n"
      @"By: __________________________________\n"
      @"Name: ________________________________\n"
      @"Its: _________________________________\n"
      @"Date: ________________________________\n";
      text8 = [string8 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string9 =
      @"KEY TERMS";
      text9 = [string9 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string10 =
      @"1. UTILITIES. Tenant shall be responsible for the payment of all utilities and services, except for"
      @"the utilities listed below (if any). Tenant must have all of these utilities placed in Tenant’ name."
      @"Owner shall be responsible for arranging for the following utilities:"
      @"______________________________________________________________________"
      @"______________________________________________________________________";
      text10= [string10 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string11 =
      @"2. SECURITY DEPOSIT. Tenant has delivered to Owner a deposit in the amount of _______ to be held as security for the performance of Tenant’s obligations under this Lease. Owner may, but shall not be obligated to, apply all portions of the security deposit to Tenant's obligations, including, without limitation, cleaning the Premises and repairing any damage to the Premises. Any balance remaining shall be returned to Tenant, together with an accounting of any disbursements, within twenty-one (21) days after Tenant has vacated the Premises, or earlier if required by law, pursuant to Civil Code Section 1950.5. Tenant shall not have the right to apply the security deposit in payment of the last month's rent.";
      text11= [string11 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string12 =
      @"3. ASSIGNMENT AND SUBLETTING; ROOMMATES. Tenant shall not assign this Lease or sublet any portion of the Premises without prior written consent of the Owner, which consent may be withheld in Owner’s reasonable discretion. Guests are permitted so long as the guest stays no longer than thirty (30) days in any calendar year, and Tenant does not charge rent or any fees to the guests. The only roommates permitted are those listed below. Roommates may be replaced with Landlord’s prior written approval, not to be unreasonably withheld. Tenant has no right to assign this Lease or sublease all or any portion of the Premises. Doing so shall result in an automatic default.";
      text12= [string12 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string13 =
      @"4. USE. The Premises shall be used exclusively as a residence for only those persons listed in this Lease as “Tenant”. Guests are permitted, provided that guests staying more than a total of thirty (30) days in a calendar year without written consent of Owner shall constitute a breach of this Lease without any notice and cure rights, except if otherwise required by applicable laws. Tenant shall not cause damage to the Premises or the Property, or commit any nuisance or act, which may disturb the quiet enjoyment of any neighbors.";
      text13= [string13 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string14 =
      @"5. RULES AND REGULATIONS. Tenant agrees to abide by all applicable rules, including, but not limited to, the Covenants, Conditions & Restriction’s (“CC&R’s”) for the Property, whether adopted before or after the date of this Lease, including rules with respect to noise, odors, disposal of refuse, animals, parking, and use of common areas. Tenant shall pay any penalties, including attorneys’ fees, imposed by the homeowners’ association (if any) for violations by Tenant or Tenant’s guests. The rules for the Property are in section 13.";
      text14= [string14 attributedStringWithFont: font lineHeight: lineHeight];
      
      
      break;
    }
    case 1: {
      
      NSString *string1 =
      @"If the landlord requires co-signers, we will email to you (and your roommates if applicable) the"
      @"Co-signer Agreement for electronic signature within 1 week of placing your offer.";
      text1 = [string1 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string2 =
      @"COSIGNER AGREEMENT";
      text2 = [string2 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string3 =
      @"This agreement is attached to and forms a part of the California Residential Lease Agreement dated"
      @"________________ between _________________ (landlord) and"
      @"_____________________________________, (Tenant(s)) for the property located at:"
      @"_____________________________________.";
      text3 = [string3 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string4 =
      @"Lease Details\n"
      @"Address : ______________________________\n"
      @"Rent Amount : __________________________\n"
      @"Move-In : __________________________\n"
      @"Move-Out : __________________________\n";
      text4 = [string4 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string5 =
      @"I, __________________________(Cosigner, Please Print), _____________(Relation) of"
      @"_________________ (Tenant) have no intention of occupying the dwelling referred to"
      @"in the Rental Agreement mentioned above.";
      text5 = [string5 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string6 =
      @"I have read the Lease Agreement, and I promise to guarantee the above listed Tenant’s compliance with"
      @"the financial obligations of this agreement.";
      text6 = [string6 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string7 =
      @"I understand that I may be required to pay for rent, cleaning charges, or damage assessments in such"
      @"amounts as are incurred by the Tenant(s) under the terms of this Agreement if and only if the Tenant(s)"
      @"themselves fail to pay."
      @"I also understand that this Cosigner Agreement will remain in force throughout the entire term of the"
      @"tenancy, even if the tenancy is extended, renewed or changed in its terms.";
      text7 = [string7 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string8 =
      @"Co-signer Agreement to Conduct a Credit Check"
      @"I also understand that this agreement is contingent upon a satisfactory credit check. I hereby give my"
      @"permission to the landlord to verify my credit history.";
      text8 = [string8 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string9 =
      @"Co-signer Information:";
      text9 = [string9 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string10 =
      @"Email: ______________________________________ Phone: ________________________________\n"
      @"SSN: _______________________________________ Driver’s License #: ______________________\n"
      @"DOB________________________________________ Address: ______________________________\n"
      @"Sign: _______________________________________ Date: _________________________________\n";
      text10 = [string10 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string11 =
      @"";
      text11 = [string11 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string12 =
      @"";
      text12 = [string12 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string13 =
      @"";
      text13 = [string13 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string14 =
      @"";
      text14 = [string14 attributedStringWithFont: font lineHeight: lineHeight];
      
      break;
    }
    case 2: {
      
      NSString *string1 =
      @"As detailed in the lease, the landlord is required to disclose to tenants any pertinent information about\n" @"the property through a Memo of Disclosure.";
      text1 = [string1 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string2 =
      @"CALIFORNIA";
      text2 = [string2 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string3 =
      @"Lessors of real property in California are statutorily required to disclose the following information to\n" @"prospective lessees prior to the lessee signing the rental agreement.";
      text3 = [string3 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string4 =
      @"a. Material Facts Affecting Value or Desirability of Premises – Civ. Code § 2079\n"
      @"Lessors owe a duty to disclose to prospective lessees any characteristics or conditions of the rental" @"premises that are known or accessible only to the landlord which materially affect the value or" @"desirabil- ity of the premises in light of the lessee’s intended and disclosed use. Lessees who suffer" @"damage by a breach of this duty may have a damages cause of action against their lessor for fraud.";
      text4 = [string4 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string5 =
      @"b. Megan’s Law Notice\n"
      @"Landlords must include the following language, in at least 8-point type, in rental agreements:"
      @"Notice: Pursuant to Section 290.46 of the California Penal Code, information about specified registered sex" @"offenders is made available to the public via an Internet Web site maintained by the Department of Justice at"
      @"www.meganslaw.ca.gov. Depending on an offender’s criminal history, this information will include either the"
      @"address at which the offender resides or the community of residence and ZIP Code in which he or she resides.";
      text5 = [string5 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string6 =
      @"c. Hazardous Substances\n"
      @"i. Lead Warning Statement and Disclosure – 24 CFR § 35.92(b)"
      @"Each contract to lease target housing (residential properties constructed before 1978) shall include, as an attachment or within the contract, the following elements, in the language of the contract (e.g., English, Spanish):";
      text6 = [string6 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string7 =
      @"• A Lead Warning Statement with the following language: Housing built before 1978 may contain lead-based paint. Lead from paint, paint chips, and dust can pose health hazards if not managed properly. Lead exposure is especially harmful to young children and preg- nant women. Before renting pre-1978 housing, lessors must disclose the presence of lead-based paint and/or lead-based paint hazards in the dwelling. Lessees must also receive a federally approved pamphlet on lead poisoning prevention.";
      text7 = [string7 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string8 =
      @"• A statement by the lessor disclosing the presence of known lead-based paint and/or lead-based paint hazards in the target housing being leased or indicating no knowledge of the presence of lead-based paint and/or lead-based paint hazards. The lessor shall also disclose any additional information available concerning the known lead-based paint and/or lead-based paint hazards, such as the basis for the determination that lead-based paint and/or lead-based paint hazards exist in the housing, the location of the lead-based paint and/or lead-based paint hazards, and the condition of the painted surfaces.";
      text8 = [string8 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string9 =
      @"• A list of any records or reports available to the lessor pertaining to lead-based paint and/or lead-based paint hazards in the housing that have been provided to the lessee. If no such records or reports are available, the lessor shall so indicate.";
      text9 = [string9 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string10 =
      @"• A statement by the lessee affirming receipt of the information set out in paragraphs (b)(2) and (b)(3) of this section and the lead hazard information pamphlet required under 15 U.S.C. 2696.";
      text10 = [string10 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string11 =
      @"";
      text11 = [string11 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string12 =
      @"";
      text12 = [string12 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string13 =
      @"";
      text13 = [string13 attributedStringWithFont: font lineHeight: lineHeight];
      
      NSString *string14 =
      @"";
      text14 = [string14 attributedStringWithFont: font lineHeight: lineHeight];
      
      
      break;
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
  else if (indexPath.row == 9) {
    text = text10;
  }
  else if (indexPath.row == 10) {
    text = text11;
  }
  else if (indexPath.row == 11) {
    text = text12;
  }
  else if (indexPath.row == 12) {
    text = text13;
  }
  else if (indexPath.row == 13) {
    text = text14;
  }
  
  cell.textLabel.attributedText = text;
  
  cell.textLabel.font=[UIFont fontWithSize:5.2 bold:YES];
  
  //if(indexPath.row==1)
  
  [cell.textLabel sizeToFit];
  cell.backgroundColor=[UIColor clearColor];
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
  return 14;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  if (indexPath.row==1)
    return 6.0;
  return 35.0;
}

#pragma mark - UIGestureRecognizer Delegates And Methods


- (void)resetTable {
  
	[UIView beginAnimations:nil context:nil];
	[self.table setTransform:CGAffineTransformIdentity];
	self.table.frame = originalFrame;
	[UIView commitAnimations];
  
}
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
  if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    UIView *piece = gestureRecognizer.view;
    CGPoint locationInView = [gestureRecognizer locationInView:self.table];
    CGPoint locationInSuperview = [gestureRecognizer locationInView:self.table.superview];
    
    piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width,( locationInView.y +10.0) / piece.bounds.size.height);
    piece.center = locationInSuperview;
  }
  else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    
		UIPanGestureRecognizer *pan= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    
    [self.table addGestureRecognizer:pan];
    
	}
  
  
}

- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
  if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
    // Reset the last scale, necessary if there are multiple objects with different scales
    lastScale = [gestureRecognizer scale];
  }
  
  if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
      [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
    
    CGFloat currentScale = [[[gestureRecognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
    
    // Constants to adjust the max/min values of zoom
    const CGFloat kMaxScale = 2.0;
    const CGFloat kMinScale = 1.0;
    
    CGFloat newScale = 1 -  (lastScale - [gestureRecognizer scale]);
    newScale = MIN(newScale, kMaxScale / currentScale);
    newScale = MAX(newScale, kMinScale / currentScale);
    CGAffineTransform transform = CGAffineTransformScale([[gestureRecognizer view] transform], newScale, newScale);
    [gestureRecognizer view].transform = transform;
    
    lastScale = [gestureRecognizer scale];  // Store the previous scale factor for the next pinch gesture call
  }
  else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    
		UIPanGestureRecognizer *pan= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    
    [self.table addGestureRecognizer:pan];
    
	}
}
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
  
  CGRect zoomRect;
  
  zoomRect.size.height = [self.table frame].size.height / scale;
  zoomRect.size.width  = [self.table  frame].size.width  / scale;
  
  center = [self.table  convertPoint:center fromView:self.table ];
  
  zoomRect.origin.x    = center.x - ((zoomRect.size.width / 2.0));
  zoomRect.origin.y    = center.y - ((zoomRect.size.height / 2.0));
  
  return zoomRect;
}

- (void)scaleTapPiece:(UIGestureRecognizer *)gestureRecognizer
{
  float newScale = [self.table zoomScale] * ZOOM_STEP;
  CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
  [self.table  zoomToRect:zoomRect animated:YES];
  
}

- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
  CGPoint translation = [gestureRecognizer translationInView:self.view];
  gestureRecognizer.view.center = CGPointMake(gestureRecognizer.view.center.x + translation.x,
                                              gestureRecognizer.view.center.y + translation.y);
  [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return YES;
}


@end

