//
//  SettingsViewController.h
//  PocketTranslator
//
//  Created by Shana Golden on 4/29/11.
//  Copyright 2011 S. Golden. All rights reserved.
//

#import <UIKit/UIKit.h>

// View controller for settings
@interface SettingsViewController : UIViewController {
    UILabel *_setLangFrom_label;
    UILabel *_setLangTo_label;
    UIButton *_setLangFrom_btn;
    UIButton *_setLangTo_btn;
    NSString *_startLang_code;
    NSString *_endLang_code;
    int _selectedBtn;
    UILabel *_sectionTitle;
    UILabel *_aboutKeyboards;
    UILabel *_aboutSettings;
}

@property (nonatomic, retain) IBOutlet UILabel *setLangFrom_label;
@property (nonatomic, retain) IBOutlet UILabel *setLangTo_label;
@property (nonatomic, retain) IBOutlet UIButton *setLangFrom_btn;
@property (nonatomic, retain) IBOutlet UIButton *setLangTo_btn;
@property (nonatomic, assign) int selectedBtn;
@property (nonatomic, retain) NSString *startLang_code;
@property (nonatomic, retain) NSString *endLang_code;
@property (nonatomic, retain) IBOutlet UILabel *sectionTitle;
@property (nonatomic, retain) IBOutlet UILabel *aboutKeyboards;
@property (nonatomic, retain) IBOutlet UILabel *aboutSettings;

- (IBAction)displayAndSetLanguage:(id)sender;

@end
