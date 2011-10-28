//
//  LanguageTableViewController.m
//  PocketTranslator
//
//  Created by Shana Golden on 4/30/11.
//  Copyright 2011 S. Golden. All rights reserved.
//

#import "TranslateNavController.h"
#import "SettingsNavController.h"
#import "LanguageTableViewController.h"

// Displays the list of languages that can be translated. Languages are stored in a plist. When a language is selected, it is set in the defaults so it's value can be read by the translateViewController.
@implementation LanguageTableViewController

@synthesize langTableView = _langTableView;
@synthesize languageList = _languageList;
@synthesize languages = _languages;
@synthesize selectedLanguage = _selectedLanguage;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tableView.scrollEnabled = YES;        
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Languages", @"Languages that are supported by Google Translate");
    
    // read languages from plist
    NSDictionary *list = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"languages" ofType:@"plist"]];
    
    self.languageList = list;    
    NSArray *languageVals = [[NSArray alloc] initWithArray:[list allValues]];
    
    self.languages = [languageVals sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [list release];
    [languageVals release];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //if there was a previous selection, clear it
    if ([defaults objectForKey:@"selectedLanguage"] != nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedLanguage"];
    };
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.languageList allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.languages objectAtIndex:row];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // set language and code for translate view
    if ([self.navigationController isMemberOfClass:[TranslateNavController class]])
    {
        [defaults setObject: cell.textLabel.text forKey:@"selectedLanguage"];
        
        // set language code
        for (id languageCode in [self.languageList allKeys]) 
        {
            NSString *languageVal = [NSString stringWithString:[self.languageList objectForKey:languageCode]];
            if ([languageVal isEqualToString:cell.textLabel.text]) {
                [defaults setObject:languageCode forKey:@"selectedLanguageCode"];
            }     
        }
    }
    
    // set language and code for settings
    if ([self.navigationController isMemberOfClass:[SettingsNavController class]])
    {
        [defaults setObject: cell.textLabel.text forKey:@"selectedDefaultLanguage"];
              
        // set language code
        for (id languageCode in [self.languageList allKeys]) 
        {
            NSString *languageVal = [NSString stringWithString:[self.languageList objectForKey:languageCode]];
            if ([languageVal isEqualToString:cell.textLabel.text]) {
                [defaults setObject:languageCode forKey:@"selectedDefaultLanguageCode"];
            }     
        }
    }

    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)dealloc
{
    self.languages = nil;
    self.languageList = nil;
    self.langTableView = nil;
    self.selectedLanguage = nil;
    [super dealloc];
}

@end
