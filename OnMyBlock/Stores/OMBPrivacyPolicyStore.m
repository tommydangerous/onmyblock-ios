//
//  OMBPrivacyPolicyStore.m
//  OnMyBlock
//
//  Created by Tommy DANGerous on 12/26/13.
//  Copyright (c) 2013 OnMyBlock. All rights reserved.
//

#import "OMBPrivacyPolicyStore.h"

#import "NSString+Extensions.h"

@implementation OMBPrivacyPolicyStore

#pragma mark - Initializer

- (id) init
{
  if (!(self = [super init])) return nil;

  _sections = @[
    [self introductionDictionary],
    [self whatInformationDictionary],
    [self webTrackingDictionary],
    [self howUseDictionary],
    [self whatDiscloseDictionary],
    [self optDictionary],
    [self accessingDictionary],
    [self securityDictionary],
    [self linksDictionary],
    [self amendmentsDictionary],
    [self outsideDictionary],
    [self usersUnderDictionary],
    [self termsDictionary],
    [self effectiveDictionary]
  ];

  return self;
}

#pragma mark - Methods

#pragma mark - Class Methods

+ (OMBPrivacyPolicyStore *) sharedStore
{
  static OMBPrivacyPolicyStore *store = nil;
  if (!store)
    store = [[OMBPrivacyPolicyStore alloc] init];
  return store;
}

#pragma mark - Instance Methods

- (NSString *) accessingContent
{
  return @"You can access, review, update, correct and/or delete your Personal Information by using the profile editing tools on the Website or by contacting us at info@onmyblock.com. OnMyBlock reserves the right to verify your identity in order to provide such access.\n\nEven after you remove information from your profile or delete your account, copies of that information may remain viewable elsewhere to the extent it has been shared with others. However, your name will no longer be associated with that information on the Website. Additionally, we may retain certain information to prevent identity theft and other misconduct even if deletion has been requested. Removed and deleted information may persist in backup copies indefinitely, but will not be available to others.";
}

- (NSDictionary *) accessingDictionary
{
  return
  @{
    @"content": [self attributedStringWithContent: [self accessingContent]],
    @"size":    [self valueSizeForContent: [self accessingContent]],
    @"title":   @"Accessing, Updating or Deleting"
  }; 
}

- (NSString *) amendmentsContent
{
  return @"OnMyBlock may modify or amend this policy from time to time. If we make any material changes, as determined by OnMyBlock, to this Privacy Policy, including in the way in which Personal Information is collected, used or transferred, we will notify you by e-mail to the address specified in your OnMyBlock profile or by means of a notice on the Website prior to the change becoming effective.";
}

- (NSDictionary *) amendmentsDictionary
{
  return
  @{
    @"content": [self attributedStringWithContent: [self amendmentsContent]],
    @"size":    [self valueSizeForContent: [self amendmentsContent]],
    @"title":   @"Amendments"
  }; 
}

- (NSAttributedString *) attributedStringWithContent: (NSString *) string
{
  return [string attributedStringWithFont: 
    [UIFont fontWithName: @"HelveticaNeue-Light" size: 15] lineHeight: 22.0f];
}

- (NSString *) effectiveContent
{
  return @"September 12th, 2013";
}

- (NSDictionary *) effectiveDictionary
{
  return
  @{
    @"content": [self attributedStringWithContent: [self effectiveContent]],
    @"size":    [self valueSizeForContent: [self effectiveContent]],
    @"title":   @"Effective Date of this Policy"
  }; 
}

- (NSString *) howUseContent
{
  return @"Personal Information: We will use and store Personal Information for the purpose of delivering the Website and our services to you, and to analyze and enhance the operation of the Website. We may also use Personal Information for the internal operational and administrative purposes of the Website. We may enter Personal Information into our contact management database, and may use such database to send you marketing materials and to contact you regarding your interest in OnMyBlock products and services.\n\nAggregate Information: We will also create statistical, aggregated data relating to our users and the Website for analytical purposes. Aggregated data is derived from Personal Information and Web Tracking Information but in its aggregated form it does not relate to or identify any individual. This data is used to understand our customer base and to develop, improve and market our services.\n\nWeb Tracking Information: We use Web Tracking Information to administer the Website and to understand how well our Website is working, to store your user preferences, and to develop statistical information on usage of the Website. This allows us to determine which features visitors like best to help us improve the Website, to personalize your user experience, and to measure overall effectiveness.\n\nLegal Exception: Notwithstanding the above, OnMyBlock may use Personal Information to the extent required by law or legal process, or if in OnMyBlock’s reasonable discretion use is necessary to investigate fraud or any threat to the safety of any individual, to protect OnMyBlock’s legal rights or to protect the rights of third parties.";
}

- (NSDictionary *) howUseDictionary
{
  return
  @{
    @"content": [self attributedStringWithContent: [self howUseContent]],
    @"size":    [self valueSizeForContent: [self howUseContent]],
    @"title":   @"How Do We Use that Information"
  }; 
}

- (NSString *) introductionContent
{
  return @"Welcome to OnMyBlock. This privacy policy is designed to inform users of the OnMyBlock, LLC website (the \"Website\") about how OnMyBlock, LLC. (\"OnMyBlock\", \"we\" or \"us\") gathers and uses personal information submitted to OnMyBlock through the Website. OnMyBlock will take reasonable steps to protect user privacy consistent with the guidelines set forth in this policy and with applicable U.S. laws. In this policy, \"use\" or \"you\" means any person viewing the Website or submitting any personal information to OnMyBlock in connection with using the Website. By using the Website, you are indicating your consent to this Privacy Policy. IF YOU DO NOT AGREE WITH THIS PRIVACY POLICY, YOU SHOULD NOT USE THE WEBSITE.";
}

- (NSDictionary *) introductionDictionary
{
  return
  @{
    @"content": [self attributedStringWithContent: [self introductionContent]],
    @"size":    [self valueSizeForContent: [self introductionContent]],
    @"title":   @"Introduction"
  }; 
}

- (NSString *) linksContent
{
  return @"The Website may contain links to other websites. OnMyBlock is not responsible for the privacy practices or the content of those websites. Users should be aware of this when they leave our site and review the privacy statements of each Web site they visit that collects information. This Privacy Policy applies solely to personal information collected by OnMyBlock.";
}

- (NSDictionary *) linksDictionary
{
  return
  @{
    @"content": [self attributedStringWithContent: [self linksContent]],
    @"size":    [self valueSizeForContent: [self linksContent]],
    @"title":   @"Links"
  }; 
}

- (NSString *) optContent
{
  return @"If you would like your Personal Information removed from our mailing list or database, please contact us at info@onmyblock.com. In the event of any such removal, OnMyBlock may retain copies of information for its archives.";
}

- (NSDictionary *) optDictionary
{
  return
  @{
    @"content": [self attributedStringWithContent: [self optContent]],
    @"size":    [self valueSizeForContent: [self optContent]],
    @"title":   @"How Can You Opt Out?"
  }; 
}

- (NSString *) outsideContent
{
  return @"OnMyBlock and its servers are located in the United States and are subject to the applicable state and federal laws of the United States. If you choose to access the Website, you consent to the use and disclosure of information in accordance with this privacy policy and subject to such laws.";
}

- (NSDictionary *) outsideDictionary
{
  return
  @{
    @"content": [self attributedStringWithContent: [self outsideContent]],
    @"size":    [self valueSizeForContent: [self outsideContent]],
    @"title":   @"Outside the United States"
  }; 
}

- (NSString *) securityContent
{
  return @"We use reasonable security precautions to protect the security and integrity of your Personal Information, both during transmission and once we receive it, in accordance with this policy and applicable law. We encrypt transmissions of Personal Information through the Website using secure socket layer technology (SSL). However, no method of electronic storage or Internet transmission is completely secure, and we cannot guarantee that security breaches will not occur. Without limitation of the foregoing, we are not responsible for the actions of hackers and other unauthorized third parties that breach our reasonable security procedures.";
}

- (NSDictionary *) securityDictionary
{
  return
  @{
    @"content": [self attributedStringWithContent: [self securityContent]],
    @"size":    [self valueSizeForContent: [self securityContent]],
    @"title":   @"Security"
  }; 
}

- (CGSize) sizeForContent: (NSAttributedString *) aString
{
  CGRect screen   = [[UIScreen mainScreen] bounds];
  CGFloat padding = 20.0f;
  CGSize maxSize  = CGSizeMake(screen.size.width - (padding * 2), FLT_MAX);
  return [aString boundingRectWithSize: maxSize 
    options: NSStringDrawingUsesLineFragmentOrigin context: nil].size;
}

- (NSString *) termsContent
{
  return @"This policy forms part of, and is subject to, the provisions of OnMyBlock’s Terms of Use.";
}

- (NSDictionary *) termsDictionary
{
  return
  @{
    @"content": [self attributedStringWithContent: [self termsContent]],
    @"size":    [self valueSizeForContent: [self termsContent]],
    @"title":   @"Terms of Use"
  }; 
}

- (NSString *) usersUnderContent
{
  return @"The Website does not knowingly collect personal information from users under the age of 13. If you are under the age of 13, you are not permitted to use the Website.";
}

- (NSDictionary *) usersUnderDictionary
{
  return
  @{
    @"content": [self attributedStringWithContent: [self usersUnderContent]],
    @"size":    [self valueSizeForContent: [self usersUnderContent]],
    @"title":   @"Users Under 13 Years of Age"
  }; 
}

- (NSValue *) valueSizeForContent: (NSString *) string
{
  return [NSValue valueWithCGSize: 
    [self sizeForContent: [self attributedStringWithContent: string]]];
}

- (NSString *) webTrackingContent
{
  return @"We, and third party service providers that we engage to provide services to us (\"Contractors\"), may use web tracking technologies such as cookies, web beacons, pixel tags and clear GIFs in order to operate the Website efficiently and to collect data related to usage of the Website. Such collected data (\"Web Tracking Information\") may include the address of the websites you visited before and after you visited the Website, the type of browser you are using, your Internet Protocol (IP) address, what pages in the Website you visit and what links you clicked on, and whether you opened email communications we send to you. In order to collect Web Tracking Information and to make your use of the Website more efficient, we may store cookies on your computer. We may also use web tracking technologies that are placed in web pages on the Website or in email communications to collect information about actions that users take when they interact with the Website or such email communications, and our Contractors may also do so. We do not correlate Web Tracking Information to individual user Personal Information. Some Web Tracking Information may include data, such as IP address data, that is unique to you. You may be able to modify your browser settings to alter which web tracking technologies are permitted when you use the Website, but this may affect the performance of the Website.";
}

- (NSDictionary *) webTrackingDictionary
{
  return
  @{
    @"content": [self attributedStringWithContent: [self webTrackingContent]],
    @"size":    [self valueSizeForContent: [self webTrackingContent]],
    @"title":   @"Web Tracking Information"
  }; 
}

- (NSString *) whatDiscloseContent
{
  return @"OnMyBlock’s Disclosure of Personal Information: We will use the Personal Information you give us to fulfill the services you request from us. This may include sharing such Personal Information with any of our Contractors, or with any landlord, landlord representative, broker, property manager or sub-lessor who is bound by obligations of confidentiality and with whom you may wish to enter into a rental contract. Except as set forth in the previous sentence, as described under \"Permitted Disclosures\" below, and as otherwise authorized by you, OnmyBlock will not disclose Personal Information to any third party. OnMyBlock shall in no event be liable to you for any use or misuse of Personal Information by any third party with whom your Personal Information has been shared in accordance with the terms of this paragraph.\n\nWeb Tracking Information: We may disclose Web Tracking Information to Contractors in order to analyze the performance of the Website and the behavior of users, and to operate and improve the Website. Certain Web Tracking information, such as the popularity ranking of certain pages of the Website, may be published on the Website and so disclosed to all users of the Website.\n\nAggregate Information: We may disclose aggregated data that does not contain Personal Information to any third parties, such as potential customers, business partners, advertisers, and funding sources, in order to describe our business and operations.\n\nPermitted Disclosures: Notwithstanding the foregoing, OnMyBlock reserves the right to disclose any information we collect in connection with the Website, without further notice to you to any successor to OnMyBlock’s business as a result of any merger, acquisition or similar transaction; and to any law enforcement or regulatory authority to the extent required by law or if, in OnMyBlock’s reasonable discretion, disclosure is necessary to investigate fraud or any threat to the safety of any individual, to protect OnMyBlock’s legal rights or to protect the rights of third parties.";
}

- (NSDictionary *) whatDiscloseDictionary
{
  return
  @{
    @"content": [self attributedStringWithContent: [self whatDiscloseContent]],
    @"size":    [self valueSizeForContent: [self whatDiscloseContent]],
    @"title":   @"What Information Do We Disclose?"
  }; 
}

- (NSString *) whatInformationContent
{
  return @"Renters: If you sign up to use services offered through the Website, OnMyBlock will collect certain personal information, including your name, email address, home address, employment information, phone number, educational background, credit score, financial information and income and tenancy history (collectively, the \"Personal Information\"). The collection of such Personal Information is consistent with our provision of services to you, including the facilitation of preliminary determinations by landlords, landlord representatives, brokers, property managers and sub-lessors of your suitability as a potential tenant. In addition, if you contact OnMyBlock and disclose additional personal information, we may store that Personal Information.\n\nLandlords and Brokers: When landlords, landlord representatives, brokers, property managers and sub-lessors list properties for rent on the Website, we collect the name, telephone number and email address of a contact person for such landlord, landlord representative, broker property manager or sub-lessor. We also collect bank account information from landlords, landlord representatives, brokers, property managers and sub-lessors so we are able to process payments in connection with the successful rental of listed properties.";
}

- (NSDictionary *) whatInformationDictionary
{
  return
  @{
    @"content": [self attributedStringWithContent: 
      [self whatInformationContent]],
    @"size":    [self valueSizeForContent: [self whatInformationContent]],
    @"title":   @"What Information Do We Collect?"
  }; 
}

@end
