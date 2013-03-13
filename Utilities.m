//
//  Essentials.m
//  Essentials
//
//  Created by Sævarður Einarsson on 7/2/12.
//  Copyright (c) 2012 Stokkur Mobile Software ehf. All rights reserved.
//

#import "Utilities.h"
#import "Reachability.h"
//#import "Constants.h"

#define TMP NSTemporaryDirectory()
#define kReachabilityUrl @"www.google.com"

#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

// json response log
//#define JSONLOG
#ifdef JSONLOG
#define JLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define JLog( s, ... )
#endif


@implementation Utilities

#pragma mark UDID

+ (NSString *)localUuid
{
    NSString *ident = [[NSUserDefaults standardUserDefaults] objectForKey:@"udid"];
    if (!ident) {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        ident = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
        CFRelease(uuidStringRef);
        [[NSUserDefaults standardUserDefaults] setObject:ident forKey:@"udid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return ident;
}


#pragma mark Reachability

+ (BOOL)isReachable
{
    Reachability *r = [Reachability reachabilityWithHostname:kReachabilityUrl];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}


#pragma mark IP Address

+ (NSString *)getIPAddress {
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL; struct ifaddrs *temp_addr = NULL;
	int success = 0; // retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0)  {
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL)  {
			if(temp_addr->ifa_addr->sa_family == AF_INET)  {
				// Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])  {
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
			temp_addr = temp_addr->ifa_next;
		}
	}
	// Free memory
	freeifaddrs(interfaces);
	return address;
}

#pragma mark Price Formatter

+ (NSString *)formatPriceDecimal:(int)totPrice
{
    NSNumber *total = [NSNumber numberWithInt:totPrice];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"is_IS"];
    [formatter setLocale:locale];
    //[formatter setLocale:[NSLocale currentLocale]];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [formatter stringFromNumber:total];
}

+ (NSString *)formatPriceDecimalDbl:(double)totPrice
{
    NSNumber *total = [NSNumber numberWithDouble:totPrice];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"is_IS"];
    [formatter setLocale:locale];
    //[formatter setLocale:[NSLocale currentLocale]];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [formatter stringFromNumber:total];
}

+ (NSString *)formatPriceCurrency:(int)totPrice
{
    NSNumber *total = [NSNumber numberWithInt:totPrice];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"is_IS"];
    [formatter setLocale:locale];
    //[formatter setLocale:[NSLocale currentLocale]];
    
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter internationalCurrencySymbol];
    
    return [formatter stringFromNumber:total];
}

+ (NSString *)formatPriceCurrencyDbl:(double)totPrice
{
    NSNumber *total = [NSNumber numberWithDouble:totPrice];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"is_IS"];
    [formatter setLocale:locale];
    //[formatter setLocale:[NSLocale currentLocale]];
    
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter internationalCurrencySymbol];
    
    return [formatter stringFromNumber:total];
}

#pragma mark Date Fromatter

+ (NSDate*)dateFromString:(NSString*)stringDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	//[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    return [dateFormatter dateFromString:stringDate];
}

+ (NSString*)stringFromDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	//[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    return [dateFormatter stringFromDate:date];
}


#pragma mark Image cache

+ (void)cacheImage:(NSString *)imageURLString imageName:(NSString *)imageName
{
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imageURLString, imageName]];
    
    NSString *uniquePath = [TMP stringByAppendingPathComponent:imageName];
    
    // Check for file existence
    if (![[NSFileManager defaultManager] fileExistsAtPath:uniquePath])
    {
        // The file doesn't exist, we should get a copy of it
        
        // Fetch image
        NSData *data = [[NSData alloc] initWithContentsOfURL:imageURL];
        
        /*
         if (data) // Did we sucessfully get data
         {
         */
        UIImage *image = [[UIImage alloc] initWithData:data];
        
        // Is it PNG or JPG/JPEG?
        // Running the image representation function writes the data from the image to a file
        if ([imageName rangeOfString:@".png" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [UIImagePNGRepresentation(image) writeToFile:uniquePath atomically:YES];
        }
        else if (
                 [imageName rangeOfString:@".jpg" options:NSCaseInsensitiveSearch].location != NSNotFound ||
                 [imageName rangeOfString:@".jpeg" options:NSCaseInsensitiveSearch].location != NSNotFound
                 )
        {
            [UIImageJPEGRepresentation(image, 100) writeToFile:uniquePath atomically:YES];
        }
        /*
         }
         */
    }
}

+ (UIImage *)getCachedImage:(NSString *)imageURLString imageName:(NSString *)imageName
{
    NSString *uniquePath = [TMP stringByAppendingPathComponent:imageName];
    
    UIImage *image;
    
    // Check for a cached version
    if ([[NSFileManager defaultManager] fileExistsAtPath:uniquePath])
    {
        DLog(@"Cached image %@",imageName);
        image = [UIImage imageWithContentsOfFile:uniquePath]; // this is the cached image
    }
    else
    {
        DLog(@"Image from web %@",imageName);
        // get a new one
        //NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", imageURLString, imageName]];
        [self cacheImage:imageURLString imageName:imageName];
        image = [UIImage imageWithContentsOfFile:uniquePath];
    }
    return image;
}

#pragma mark Screen resolution check

+ (BOOL)isLowScreen
{
    BOOL hasLowResScreen = YES;
    if ([UIScreen instancesRespondToSelector:@selector(scale)])
    {
        CGFloat scale = [[UIScreen mainScreen] scale];
        if (scale > 1.0)
        {
            hasLowResScreen = NO;
        }
    }
    return hasLowResScreen;
}

#pragma Alert quick method

+ (void)showAlert:(NSString *)title messageText:(NSString *)messageText buttonText:(NSString *)buttonText
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:messageText
                                                   delegate:nil
                                          cancelButtonTitle:buttonText
                                          otherButtonTitles:nil];
    alert.tag = 1990;
    [alert show];
}

+ (void)netAlert
{
    [self showAlert:@"Netvilla!" messageText:@"Næ ekki sambandi við vefþjónustur!" buttonText:@"OK"];
}

@end
