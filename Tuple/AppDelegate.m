//
//  AppDelegate.m
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "Tuple-Swift.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "NSDataConvert.h"
#import "DeleteParseObject.h"
#import "Branch.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    Branch *branch = [Branch getInstance];
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        // params are the deep linked params associated with the link that the user clicked before showing up.
        NSLog(@"deep link data: %@", [params description]);
    }];
    
    [self setupParse:application withLaunchOptions:launchOptions];
    
    _sendData =  [[SendData alloc] init];


    IntroViewController *introVC = [[IntroViewController alloc] initWithNibName:@"IntroViewController" bundle:nil];
    self.window.rootViewController = introVC;
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[Branch getInstance] handleDeepLink:url]) {
        return YES;
    }
    return NO;
}

#pragma mark - Register Push Notifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
   
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    
    NSLog(@"Device token: %@", deviceToken);
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceTokenTypeData"];
    NSString *hexadecimalString = [deviceToken hexadecimalString];
    [[NSUserDefaults standardUserDefaults] setObject:hexadecimalString forKey:@"deviceToken"];

    PFUser *currentUser = [PFUser currentUser];
    if (currentUser)
    {
        currentUser[@"deviceToken"] = hexadecimalString;
        [currentUser saveInBackground];
    }
    
    
//    if ([PFUser currentUser].username)
//    {
//        [self activiateLayer];
//        NSError *error;
//        BOOL success = [self.layerClient updateRemoteNotificationDeviceToken:deviceToken error:&error];
//        if (success) {
//            NSLog(@"Application did register for remote notifications");
//        } else {
//            NSLog(@"Error updating Layer device token for push:%@", error);
//        }
//    }
//    else
//    {
//        
//    }
    
    
   
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register remote Notifcations: FATAL ERROR: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UIApplicationState state = [application applicationState];
    if ([[userInfo valueForKeyPath:@"aps.alert"] isEqualToString:@""])
    {
        return;
    }
    if (state == UIApplicationStateActive)
    {
        NSLog(@"User Info: %@", userInfo);
        
//        [PFPush handlePush:userInfo];
    }
    else
    {
   
    }
    
}

#pragma mark - Parse Methods

-(void)setupParse:(UIApplication *)application withLaunchOptions:(NSDictionary *)lauchOptions
{
    //PARSE
    [Parse enableLocalDatastore];
    // Initialize Parse.
    [Parse setApplicationId:@"A5W56JpbUSdejJfl15K72x6OfAbUPpPZ2JHXq19c"
                  clientKey:@"GkQAi4Me5aZOYgHiLTxHlt0aRwkvxcTo8sidbGVt"];
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:lauchOptions];
    
    //PUSH NOTIFICATIONS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        // Register device for iOS8
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
        
    } else {
        // Register device for iOS7
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    }
    //***************
}

#pragma mark - Layer methods

-(NSString *)generateUserIDString
{
    NSLog(@"Generating Unique ID, %@", [PFUser currentUser].username);
    return [PFUser currentUser].username;
}



@end
