//
//  AppDelegate.m
//  GCDDemo
//
//  Created by 景晓峰 on 2017/4/25.
//  Copyright © 2017年 景晓峰. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (nonatomic,assign) UIBackgroundTaskIdentifier backgroundTask;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.backgroundTask = [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:_backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    
    
    NSLog(@"开始延时");
    double delayInSecond = 10;
    dispatch_time_t delty = dispatch_time(DISPATCH_TIME_NOW, delayInSecond *NSEC_PER_SEC);
    dispatch_after(delty, dispatch_get_main_queue(), ^{
        for (int i = 0; i<10; i++)
        {
            NSLog(@"%d",i);
        }
    });
    
    [[UIApplication sharedApplication]endBackgroundTask:self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
    
   
    
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
