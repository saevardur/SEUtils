//
//  AppDelegate.m
//  AppTemplate
//
//  Created by Sævarður Einarsson on 2/15/13.
//  Copyright (c) 2013 Stokkur Software. All rights reserved.
//

#import "AppDelegate.h"

static NSString *const kGANTrackingId = @"UA-6594455-15";
static NSString *const kCrittercismId = @"51000e9481952071d7000011";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    _tracker = [[GAI sharedInstance] trackerWithTrackingId:kGANTrackingId];
    // Set sessoin timeout to 2 mins, a new session is created if the app is in the background for longer than that
    [_tracker setSessionTimeout:120];
    
    [_tracker setCustom:1 dimension:[Utilities localUuid]];  // Set the dimension value for index 1.
    
    [Crittercism enableWithAppID:kCrittercismId];
    [Crittercism setUsername:[Utilities localUuid]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // if we want to customize for iphone 5
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        // code for 4-inch screen
        
        
    } else {
        // code for 3.5-inch screen
        
        
    }
    
    [self customizeAppearance];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    // If app was started from push notification
    if (launchOptions != nil)
	{
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
			[self handlePushNotification:dictionary];
		}
	}
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Customize Apperance

- (void)customizeAppearance
{
    /*
    //[[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:253.0/255.0 green:153.0/255.0 blue:79.0/255.0 alpha:1.0]];
    
    // Create resizable images
    //UIImage *gradientImage44 = [[UIImage imageNamed:@"navbar_grad44"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    // Set the background image for *all* UINavigationBars
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    
    // Set the background image for *all* UISearchBars
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar"]];
    
    
    //[[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
    
    // Customize the title text for *all* UINavigationBars
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"HelveticaNeueLTStd-BdCn" size:kLblSizeHeading], UITextAttributeFont,
      nil]];
    
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:66.0/255.0 green:104.0/255.0 blue:171.0/255.0 alpha:1.0]];
    
     // Customize the bar button item
     //[[UIBarButtonItem appearance] setBackgroundImage:[UIImage imageNamed:@"btn_menu"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
     //[[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:66.0/255.0 green:104.0/255.0 blue:171.0/255.0 alpha:1.0]];
     //[[UIBarButtonItem appearance] setTintColor:[UIColor clearColor]];
     
     
     [[UIBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], UITextAttributeTextColor,
     [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8], UITextAttributeTextShadowColor,
     [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
     [UIFont fontWithName:@"NeoSansStd-Bold" size:14.0], UITextAttributeFont,
     nil] forState:UIControlStateNormal];
     
     // Set back button for navbar
     //UIImage *backButton = [[UIImage imageNamed:@"blueButton"]  resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
     //[[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
     
     // Customize the labels
     //[[UILabel appearance] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0]];
     
     //[[UILabel appearanceWhenContainedIn:[DetailViewController class], nil] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0]];
     //[[UILabel appearanceWhenContainedIn:[ManualViewController class], nil] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
     //[[UILabel appearanceWhenContainedIn:[LoginViewController class], nil] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
     
     //[[UILabel appearanceWhenContainedIn:[UITableViewCell class], nil] setColor:[UIColor whiteColor]];
     
     // set backgroundcolor to gray
     //[[UIViewController appearance] setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
     //[[UIView appearanceWhenContainedIn:[FrontTemplateViewController class], nil] setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
     //[[UIView appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundColor:[UIColor clearColor]];
     */
    
    /*
     // Customize the buttons
     UIImage *buttonImage = [[UIImage imageNamed:@"blueButton"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 0, 16)];
     //[[UIButton appearance] setBackgroundImage:buttonImage forState:UIControlStateNormal];
     [[UIButton appearanceWhenContainedIn:[LoginViewController class], nil] setBackgroundImage:buttonImage forState:UIControlStateNormal];
     [[UIButton appearanceWhenContainedIn:[ManualViewController class], nil] setBackgroundImage:buttonImage forState:UIControlStateNormal];
     [[UIButton appearanceWhenContainedIn:[DetailViewController class], nil] setBackgroundImage:buttonImage forState:UIControlStateNormal];
     
     [[UIButton appearance] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     */
}


#pragma mark - Push Methods

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"My token is: %@", newToken);
    
    
    // here we should register the push token with the app backend
    NSString *urlMethod = [NSString stringWithFormat:kPushRegisterUrl, [Utilities localUuid], newToken];
    NSString *urlAsString = [NSString stringWithFormat:@"%@%@", kBaseUrl, urlMethod];
    DLog(@"%@", urlAsString);
    NSURL *connectinUrl = [NSURL URLWithString:urlAsString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:connectinUrl];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil)
         {
             NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             
             DLog(@"push registered: %@", jsonData);
         }
         else if ([data length] == 0 && error == nil)
         {
             DLog(@"Nothing was downloaded.");
         }
         else if (error != nil)
         {
             DLog(@"Error = %@", error);
         }
     }];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
	NSLog(@"Received notification: %@", userInfo);
    
    // we could handle push differently if the app was already open
    if ( application.applicationState == UIApplicationStateActive ) {
        // app was already in the foreground
        [self handlePushNotification:userInfo];
    } else {
        // app was just brought from background to foreground
        [self handlePushNotification:userInfo];
    }
}

- (void)handlePushNotification:(NSDictionary *)userInfo
{
    
    // here we should handle the push notification
}

@end
