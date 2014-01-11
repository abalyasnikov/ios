//
//  EXAppDelegate.m
//  NewsCatalog
//
//  Created by Alex Aleshkov on 3/15/13.
//  Copyright (c) 2013 RogaAndKopita. All rights reserved.
//


#import "EXAppDelegate.h"
#import "EXViewController.h"
#import "EXConsts.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "EXClient.h"
#import "AddThis.h"
#import "FBSession.h"


@implementation EXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AddThisSDK setAddThisPubId:@"ra-51e3b419100d5272"];
    
    [AddThisSDK setFacebookAuthenticationMode:ATFacebookAuthenticationTypeFBConnect];
    [AddThisSDK setFacebookAPIKey:@"504858119590644"];
    
    [AddThisSDK setTwitterAuthenticationMode:ATTwitterAuthenticationTypeOAuth];
    [AddThisSDK setTwitterConsumerKey:@"TkRzNdM83rjlyt6GlWe1YA"];
    [AddThisSDK setTwitterConsumerSecret:@"a4ub5jO7PsDJsSjTAGe6T8Zm9LvoaRDjFwNiLk37VI"];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    EXFontName *fontName = [EXFontNames() objectAtIndex:4];
    NSNumber *fontSize = [EXFontSizes() objectAtIndex:7];
    NSMutableDictionary *registerDefaults = [NSMutableDictionary dictionary];
    [registerDefaults setObject:fontName.fontName forKey:EXSettingFontName];
    [registerDefaults setObject:fontSize forKey:EXSettingFontSize];
    [userDefaults registerDefaults:registerDefaults];
    [userDefaults synchronize];
    
    
    BOOL hasCache = [[EXClient sharedInstance] hasCachedRssFeed];
    if (hasCache) {
        UIViewController *rootViewController = self.window.rootViewController;
        UIStoryboard *storyboard = rootViewController.storyboard;
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"InitialController"];
        self.window.rootViewController = navigationController;
    } else {
        [[EXClient sharedInstance] fetchRssFeedCachedBlock:nil successBlock:^(NSArray *result) {
            UIViewController *rootViewController = self.window.rootViewController;
            UIStoryboard *storyboard = rootViewController.storyboard;
            UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"InitialController"];
            self.window.rootViewController = navigationController;
        } failureBlock:^(NSError *error) {
            NSLog(@"%@", error);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
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

@end
