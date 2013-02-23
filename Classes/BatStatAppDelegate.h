//
//  BatStatAppDelegate.h
//  BatStat
//
//  Created by Dan Grigsby on 7/23/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BatStatViewController;

@interface BatStatAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BatStatViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BatStatViewController *viewController;

@end

