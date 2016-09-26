//
//  AppDelegate.m
//  BlogDemo
//
//  Created by HanBin on 16/3/9.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import "BHMainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BHNavigationController *controller = [[BHNavigationController alloc] initWithRootViewController:[[BHMainViewController alloc] init]];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    [[UIButton appearance] setExclusiveTouch:YES];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:23/255.0 green:180/255.0 blue:237/255.0 alpha:1]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    return YES;
}


/**
 *  点击CSSearchableItem后回调
 *
 *  @param application
 *  @param userActivity
 *  @param restorationHandler
 *
 *  @return
 */
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    if ([[userActivity activityType] isEqualToString:CSSearchableItemActionType])
    {
        NSString *uniqueIdentifier = [userActivity.userInfo objectForKey:CSSearchableItemActivityIdentifier];
        // 接受事先定义好的数值,如果是多个参数可以使用把json转成string传递过来,接受后把string在转换为json
        // 通过解析json后判断接下来的业务逻辑, 如页面跳转，提示框等。。。
        NSLog(@"传递过来的值%@", uniqueIdentifier);
    }
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

@end
