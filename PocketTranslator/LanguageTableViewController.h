//
//  LanguageTableViewController.h
//  PocketTranslator
//
//  Created by Shana Golden on 4/30/11.
//  Copyright 2011 S. Golden. All rights reserved.
//

#import <UIKit/UIKit.h>

// Displays the list of languages that can be translated
@interface LanguageTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_langTableView;
    NSString *_selectedLanguage;
    NSDictionary *_languageList;
    NSArray *_languages;
}

@property (nonatomic, retain) IBOutlet UITableView *langTableView;
@property (nonatomic, retain) NSArray *languages;
@property (nonatomic, retain) NSDictionary *languageList;
@property (nonatomic, retain) NSString *selectedLanguage;


@end
