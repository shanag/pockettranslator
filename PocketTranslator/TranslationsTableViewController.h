//
//  TranslationsTableViewController.h
//  PocketTranslator
//
//  Created by Shana Golden on 5/1/11.
//  Copyright 2011 S. Golden. All rights reserved.
//

#import <UIKit/UIKit.h>

// Table View Controller for the saved translations table
@interface TranslationsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView *_translationsTableView;
    NSDictionary *_translationDict;
}

@property (nonatomic, retain) IBOutlet UITableView *translationsTableView;
@property (nonatomic, retain) NSDictionary *translationDict;

@end
