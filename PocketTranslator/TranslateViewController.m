//
//  TranslateViewController.m
//  PocketTranslator
//
//  Created by Shana Golden on 4/30/11.
//  Copyright 2011 S. Golden. All rights reserved.
//

#import "Constants.h"
#import "JSON.h"
#import "TranslateViewController.h"
#import "LanguageTableViewController.h"
#import <QuartzCore/QuartzCore.h>

// The View controller that handles the translation from one language to another. When the view is first loaded, defaults that may have been set in the settings are retrieved. This controller also provides a button to save a translation. Selecting the start/endLanguage_btn will push a tableview controller that displays all the language choices from a plist.
@implementation TranslateViewController

@synthesize startLanguage_btn = _startLanguage_btn;
@synthesize endLanguage_btn = _endLanguage_btn;
@synthesize startTranslate_field = _startTranslate_field;
@synthesize endTranslate_field = _endTranslate_field;
@synthesize selectedBtn = _selectedBtn;
@synthesize responseData= _responseData;
@synthesize startLanguage_code = _startLanguage_code;
@synthesize endLanguage_code = _endLanguage_code;
@synthesize userMsg = _userMsg;
@synthesize saveTranslation_btn = _saveTranslation_btn;

// Stores the tag of the button that was pressed, and then tells the navigation controller to push the languageTableViewController onto the stack
- (IBAction)displayAndSetLanguage:(id)sender
{

    UIButton *button = (UIButton*)sender;
    self.selectedBtn = button.tag;
    
    LanguageTableViewController *tableViewController = 
    [[LanguageTableViewController alloc] initWithNibName:@"LanguageTableView" bundle:nil];
    [self.navigationController pushViewController:tableViewController animated:YES];
    //originally tried this
    //[[self navigationController] presentModalViewController:tableViewController animated:YES];
    [tableViewController release];
}

// Saves the current translation in the user defaults
- (IBAction)saveTranslation
{
    //Get the defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (([self.startTranslate_field.text length] != 0) && ([self.endTranslate_field.text length] != 0)) 
    {
        //get dictionary for key
        NSMutableDictionary *translationDict = [[NSMutableDictionary alloc] initWithDictionary:[defaults dictionaryForKey:TranslationsKey]];
        
        //add saved item
        NSString *translationKey = [NSString stringWithFormat:@"%@ (%@ - %@)", self.startTranslate_field.text, self.startLanguage_btn.titleLabel.text, self.endLanguage_btn.titleLabel.text];
        [translationDict setObject:self.endTranslate_field.text forKey:translationKey];
        [defaults setObject:translationDict forKey:TranslationsKey];
        [translationDict release];
        
        self.userMsg.text = @"Saved translation!";
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// Called when editing begins in the startTranslate_field - clears the messages and text
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    self.userMsg.text = @"";
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];

        //if string is not empty, then make the API call
        if ([textView.text length] > 0) {
            [self load:textView.text];
        }
        return NO;
    }
    return YES;
}

// Uses the Google Translate API to translate a string into the given language.
- (void)load:(NSString *)query {

    NSString *urlString = [NSString stringWithFormat:@"https://www.googleapis.com/language/translate/v2?key=%@&source=%@&target=%@&q=%@", GoogleAPIKey, self.startLanguage_code, self.endLanguage_code, query];
    
    NSURL *myURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL
                                          cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                          timeoutInterval:60];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.responseData release];
    [connection release];
    // Show error message
    NSLog(@"Error: %@", [error localizedDescription]);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //handleResponse
    [self handleResponse];
    
    [self.responseData release];
    [connection release];
}

// Handles the JSON response - parses the response and shows it in the endTranslate_field
- (void)handleResponse {
    // Create string from responseData
    NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    
    // Create SBJsonParser object to parse JSON
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    // Parse the JSON string into an object
    NSDictionary *responseObject = [parser objectWithString:responseString error:nil];
    
    // Check for errors (first key will be error, second key will be message)
    if ([responseObject objectForKey:@"error"] != nil) {
        //handle error
        NSString *googleErrorMsg = [[responseObject objectForKey:@"error"] objectForKey:@"message"];
        self.userMsg.text = googleErrorMsg;
        self.endTranslate_field.text = @"";
    } else {    
        NSArray *translations = [[responseObject objectForKey:@"data"] objectForKey:@"translations"];
        for (NSDictionary *translation in translations)
        {
            // Get the translated text
            NSString *translatedText = [NSString stringWithUTF8String:[[translation objectForKey:@"translatedText"] cStringUsingEncoding:NSUTF8StringEncoding]];
        
            // Show the translated text
            self.endTranslate_field.text = translatedText;
        }
    }
    
    [responseString release];
    [parser release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.startLanguage_btn.tag = 1;
    self.endLanguage_btn.tag = 2;
    self.endTranslate_field.userInteractionEnabled = NO;
    
    //Restore settings, if any
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"defaultStartLanguageCode"] != nil)
    {
        self.startLanguage_code = [defaults objectForKey:@"defaultStartLanguageCode"];
    } else {
        //otherwise default start lang is English
        self.startLanguage_code = @"en";
    }
    
    if ([defaults objectForKey:@"defaultEndLanguageCode"] != nil)
    {
        self.endLanguage_code = [defaults objectForKey:@"defaultEndLanguageCode"];
    } else {
        //Default end lang is Spanish
        self.endLanguage_code = @"es";
    }
    
    if ([defaults objectForKey:@"defaultStartLanguage"] != nil)
    {
        [self.startLanguage_btn setTitle:[defaults objectForKey:@"defaultStartLanguage"] forState:UIControlStateNormal];
    }
    
    if ([defaults objectForKey:@"defaultEndLanguage"] != nil)
    {
        [self.endLanguage_btn setTitle:[defaults objectForKey:@"defaultEndLanguage"] forState:UIControlStateNormal];
    }
    //UI improvements
    [self modifyUI];
}

// Modify the UI to make it look a little better
- (void)modifyUI
{
    UIColor *backgroundGradient = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"gradient.png"]];    
    self.view.backgroundColor = backgroundGradient;
    [backgroundGradient release];
    
    self.startTranslate_field.layer.borderWidth = 1;
    self.startTranslate_field.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.endTranslate_field.layer.borderWidth = 1;
    self.endTranslate_field.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.startLanguage_btn.layer.borderWidth = 1;
    self.startLanguage_btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.startLanguage_btn.layer setCornerRadius:10.0];
    
    self.endLanguage_btn.layer.borderWidth = 1;
    self.endLanguage_btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.endLanguage_btn.layer setCornerRadius:10.0];
    
    self.saveTranslation_btn.layer.borderWidth = 1;
    self.saveTranslation_btn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.saveTranslation_btn.layer setCornerRadius:10.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// Every time the translate view appears, check the defaults to find out if there is a new selected language and language code
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (([defaults objectForKey:@"selectedLanguage"] != nil) && self.selectedBtn > 0)
    {
        UIButton *lastPressedBtn = (UIButton*)[self.view viewWithTag:self.selectedBtn];
        [lastPressedBtn setTitle:[defaults objectForKey:@"selectedLanguage"] forState:UIControlStateNormal];
        
        if (self.selectedBtn == 1) { 
            self.startLanguage_code = [defaults objectForKey:@"selectedLanguageCode"];
        } else if (self.selectedBtn == 2) {
            self.endLanguage_code = [defaults objectForKey:@"selectedLanguageCode"];
        }
    } 
    
    //If switching back from settings or other view, translate anything in the start field
    if ([self.startTranslate_field.text length] > 0) {
        [self load:self.startTranslate_field.text];
    }
    
    //And get rid of the old error messages
    self.userMsg.text = @"";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    self.startLanguage_btn = nil;
    self.endLanguage_btn= nil;
    self.startTranslate_field= nil;
    self.endTranslate_field = nil;
    self.responseData = nil;
    self.startLanguage_code = nil;
    self.endLanguage_code = nil;
    self.userMsg = nil;
    self.saveTranslation_btn = nil;
    [super dealloc];
}

@end
