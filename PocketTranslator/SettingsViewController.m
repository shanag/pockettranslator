//
//  SettingsViewController.m
//  PocketTranslator
//
//  Created by Shana Golden on 4/29/11.
//  Copyright 2011 S. Golden. All rights reserved.
//

#import "SettingsViewController.h"
#import "LanguageTableViewController.h"

// View controller for settings. Displays a view that contains buttons for language settings, as well as some labels with additional information. Selecting the language buttons causes the navigation controller to push the LanguageTableViewController onto the stack so that a language can be selected. Settings are saved in the NSUserDefaults.
@implementation SettingsViewController

@synthesize setLangTo_label = _setLangTo_label;
@synthesize setLangTo_btn = _setLangTo_btn;
@synthesize setLangFrom_label = _setLangFrom_label;
@synthesize setLangFrom_btn = _setLangFrom_btn;
@synthesize selectedBtn = _selectedBtn;
@synthesize startLang_code = _startLang_code;
@synthesize endLang_code = _endLang_code;
@synthesize sectionTitle = _sectionTitle;
@synthesize aboutSettings = _aboutSettings;
@synthesize aboutKeyboards = _aboutKeyboards;


- (IBAction)displayAndSetLanguage:(id)sender;
{
    UIButton *button = (UIButton*)sender;
    self.selectedBtn = button.tag;
    
    LanguageTableViewController *tableViewController = 
    [[LanguageTableViewController alloc] initWithNibName:@"LanguageTableView" bundle:nil];
    [self.navigationController pushViewController:tableViewController animated:YES];
    //[[self navigationController] presentModalViewController:tableViewController animated:YES];
    [tableViewController release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.setLangFrom_btn.tag = 1;
    self.setLangTo_btn.tag = 2;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"defaultStartLanguage"] != nil)
    {
        [self.setLangFrom_btn setTitle:[defaults objectForKey:@"defaultStartLanguage"] forState:UIControlStateNormal];
    } else {
        //otherwise default start lang is English
        [self.setLangFrom_btn setTitle:@"English" forState:UIControlStateNormal];
    }
    
    if ([defaults objectForKey:@"defaultEndLanguage"] != nil)
    {
        [self.setLangTo_btn setTitle:[defaults objectForKey:@"defaultEndLanguage"] forState:UIControlStateNormal];
    } else {
        //Default end lang is Spanish
        [self.setLangTo_btn setTitle:@"Spanish" forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (([defaults objectForKey:@"selectedDefaultLanguage"] != nil) && self.selectedBtn > 0)
    {
        UIButton *lastPressedBtn = (UIButton*)[self.view viewWithTag:self.selectedBtn];
        [lastPressedBtn setTitle:[defaults objectForKey:@"selectedDefaultLanguage"] forState:UIControlStateNormal];
        
        if (self.selectedBtn == 1) { 
            //set default for start lang
            [defaults setObject:[defaults objectForKey:@"selectedDefaultLanguageCode"] forKey:@"defaultStartLanguageCode"];
            [defaults setObject:[defaults objectForKey:@"selectedDefaultLanguage"] forKey:@"defaultStartLanguage"];
        } else if (self.selectedBtn == 2) {
            //set default for end lang
            [defaults setObject:[defaults objectForKey:@"selectedDefaultLanguageCode"] forKey:@"defaultEndLanguageCode"];
            [defaults setObject:[defaults objectForKey:@"selectedDefaultLanguage"] forKey:@"defaultEndLanguage"];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    self.setLangTo_label = nil;
    self.setLangTo_btn = nil;
    self.setLangFrom_label = nil;
    self.setLangFrom_btn = nil;
    self.startLang_code= nil;
    self.endLang_code = nil;
    self.sectionTitle = nil;
    self.aboutKeyboards = nil;
    self.aboutSettings = nil;
    [super dealloc];
}

@end
