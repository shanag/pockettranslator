//
//  PocketTranslatorAppDelegate.h
//  PocketTranslator
//
//  Created by Shana Golden on 4/29/11.
//  Copyright 2011 Vermonster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PocketTranslatorAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
