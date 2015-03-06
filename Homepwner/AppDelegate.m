//
//  AppDelegate.m
//  Homepwner
//
//  Created by Zenjougahara on 12/9/14.
//  Copyright (c) 2014 Zenjougahara. All rights reserved.
//

#import "AppDelegate.h"
//#import "INWTableViewController.h"
#import "StartViewController.h"
#import "INWItemStore.h"
#import "ImageStore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window =  [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [self.window makeKeyAndVisible];
    //INWTableViewController* inwTable = [[INWTableViewController alloc]init];
    
    StartViewController* startVC = [[StartViewController alloc]init];
  

    UINavigationController* navController = [[UINavigationController alloc]initWithRootViewController:startVC];
    self.window.rootViewController =  navController;
    self.window.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
      BOOL saved =  [[INWItemStore sharedStore] savingStore];
    if(saved){
        NSLog(@"Save complete ! ");
    }
    else{
        NSLog(@"Save Failed ");

    }
    BOOL savedimg = [[ImageStore singletonImageStore]saveStore];
    
    if(savedimg){
        NSLog(@"Save img complete ! ");
    }
    else{
        NSLog(@"Save img Failed ");
        
    }
    
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
