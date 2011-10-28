//
//  TranslateViewController.h
//  PocketTranslator
//
//  Created by Shana Golden on 4/30/11.
//  Copyright 2011 S. Golden. All rights reserved.
//

#import <UIKit/UIKit.h>

//View Controller that displays the language translations
@interface TranslateViewController : UIViewController <UITextViewDelegate> {
    UIButton *_startLanguage_btn;
    UIButton *_endLanguage_btn;
    UITextView *_startTranslate_field;
    UITextView *_endTranslate_field;
    UILabel *_userMsg;
    int selectedBtn;
    NSMutableData *_responseData;
    NSString *_startLanguage_code;
    NSString *_endLanguage_code;
    UIButton *_saveTranslation_btn;
    
}

@property (nonatomic, retain) IBOutlet UIButton *startLanguage_btn;
@property (nonatomic, retain) IBOutlet UIButton *endLanguage_btn;
@property (nonatomic, retain) IBOutlet UITextView *startTranslate_field;
@property (nonatomic, retain) IBOutlet UITextView *endTranslate_field;
@property (nonatomic, assign) int selectedBtn;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSString *startLanguage_code;
@property (nonatomic, retain) NSString *endLanguage_code;
@property (nonatomic, retain) IBOutlet UILabel *userMsg;
@property (nonatomic, retain) IBOutlet UIButton *saveTranslation_btn;

- (IBAction)displayAndSetLanguage:(id)sender;
- (IBAction)saveTranslation;
- (void)load:(NSString *)query;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)handleResponse;
- (void)modifyUI;

@end
