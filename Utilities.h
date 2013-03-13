//
//  Essentials.h
//  Essentials
//
//  Created by Sævarður Einarsson on 7/2/12.
//  Copyright (c) 2012 Stokkur Mobile Software ehf. All rights reserved.
//

// Requires ARC and iOS 5

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject

+ (NSString *)localUuid;

+ (BOOL)isReachable;

+ (NSString *)getIPAddress;

+ (NSString *)formatPriceDecimal:(int)totPrice;
+ (NSString *)formatPriceDecimalDbl:(double)totPrice;
+ (NSString *)formatPriceCurrency:(int)totPrice;
+ (NSString *)formatPriceCurrencyDbl:(double)totPrice;

+ (NSDate*)dateFromString:(NSString*)stringDate;
+ (NSString*)stringFromDate:(NSDate*)date;

+ (void) cacheImage: (NSString *) imageURLString imageName:(NSString*)imageName;
+ (UIImage *) getCachedImage: (NSString *) imageURLString imageName:(NSString*)imageName;

+ (BOOL) isLowScreen;

+ (void) showAlert:(NSString *) title messageText:(NSString *)messageText buttonText:(NSString *)buttonText;

+ (void) netAlert;

@end
