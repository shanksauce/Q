//
//  AppDelegate.m
//  Q
//
//  Created by Ben Shank on 4/3/12.
//  Copyright (c) 2012 Aol. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  For the full copyright and license information, please view the 
//  LICENSE file that was distributed with this source code.
//


#import "AppDelegate.h"
#import "MerchantViewController.h"
#import "QueueViewController.h"
#import "Q.h"

@implementation AppDelegate
@synthesize window = _window;

-(void)dealloc {
    [_window release];
    [_navController release];
    [super dealloc];
}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:@"aol", @"username",nil]];
    
    Q *amqp = [Q alloc];
    MerchantViewController *viewController = [[[MerchantViewController alloc] initMerchantViewController:amqp] autorelease];
    
    _navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self.window addSubview:_navController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)applicationWillResignActive:(UIApplication *)application { }
-(void)applicationDidEnterBackground:(UIApplication *)application { }
-(void)applicationWillEnterForeground:(UIApplication *)application { }
-(void)applicationDidBecomeActive:(UIApplication *)application { }
-(void)applicationWillTerminate:(UIApplication *)application { }

@end
