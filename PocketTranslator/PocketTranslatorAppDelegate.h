//
//  PocketTranslatorAppDelegate.h
//  PocketTranslator
//
//  Created by Shana Golden on 4/29/11.
//  Copyright 2011 S. Golden. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TranslateNavController;

@interface PocketTranslatorAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    TranslateNavController *_translateNavController;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet TranslateNavController *translateNavController;

@end
