//
//  BatStatAppDelegate.m
//  BatStat
//
//  Created by Dan Grigsby on 7/23/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "BatStatAppDelegate.h"
#import "BatStatViewController.h"

@implementation BatStatAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
