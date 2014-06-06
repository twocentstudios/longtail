//
//  TCSAppDelegate.m
//  LeagueHop
//
//  Created by Chris Trott on 5/10/14.
//  Copyright (c) 2014 TwoCentStudios. All rights reserved.
//

#import "TCSAppDelegate.h"

#import "TCSPostsViewController.h"
#import "TCSPostsViewModel.h"
#import "TCSPostController.h"

#import "TCSSettingsViewController.h"

#import <FacebookSDK/Facebook.h>

#import <TestFlightSDK/TestFlight.h>
#import "TCSSecret.h"

#ifdef DEBUG
#import <PonyDebugger/PonyDebugger.h>
#endif

@implementation TCSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

#ifdef DEBUG
    PDDebugger *debugger = [PDDebugger defaultInstance];
    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    [debugger enableViewHierarchyDebugging];
#endif

    if ([TCSTestFlightKey length] > 0) { // Defined in TCSSecret.h
        [TestFlight takeOff:TCSTestFlightKey];
    }

    TCSPostController *postController = [[TCSPostController alloc] init];
    TCSPostsViewModel *postsViewModel = [[TCSPostsViewModel alloc] initWithController:postController];
    TCSPostsViewController *postsViewController = [[TCSPostsViewController alloc] initWithViewModel:postsViewModel];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:postsViewController];
    navigationController.navigationBar.translucent = NO;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.tintColor = APP_TINT;
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: FONT_DEMIBOLD(18), NSForegroundColorAttributeName: GRAY_DARK}];

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
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[FBSession activeSession] close];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

@end
