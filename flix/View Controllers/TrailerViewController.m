//
//  TrailerViewController.m
//  flix
//
//  Created by dkaviani on 6/25/20.
//  Copyright © 2020 dkaviani. All rights reserved.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>
#import "DetailsViewController.h"

@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    // As a property or local variable
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchTrailer];
}

- (void)fetchTrailer {
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               //network error!
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSArray *results = dataDictionary[@"results"];
               NSString *key = results[0][@"key"];
               NSLog(@"%@", key);
               NSString *baseurl =  @"https://www.youtube.com/watch?v=";
               NSString *finalString = [baseurl stringByAppendingString:key];
               // Convert the url String to a NSURL object.
               NSURL *url = [NSURL URLWithString:finalString];
               
               // Place the URL in a URL Request.
               NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                    timeoutInterval:10.0];
               // Load Request into WebView.
               [self.webView loadRequest:request];
        }
       }];
    
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
