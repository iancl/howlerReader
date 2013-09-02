//
//  HRFWebViewController.m
//  HowlerReader
//
//  Created by Ian Calderon on 7/30/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import "HRFWebViewController.h"

@interface HRFWebViewController ()

@property(weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HRFWebViewController
@synthesize webView = _webView, currentURL = _currentURL, channelTitle = _channelTitle;


// designated init
-(id)initWithStringURL: (NSString *)strURL channelTitle: (NSString *)title{
    
    self = [super initWithNibName:@"HRFWebViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.currentURL = strURL;
        self.channelTitle = title;
    }
    return self;
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self showLoadingHUD];
    
    // set title
    [[self navigationItem] setTitle:self.channelTitle];
    
    
    // load page
    NSURL *url = [NSURL URLWithString:self.currentURL];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView setScalesPageToFit:YES];
    [self.webView loadRequest:req];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"dealloc webview");
}

#pragma mark - MBProgressHUD

// show hide loading HUD
-(void)showLoadingHUD{
    if (!_loadingHUD) {
        _loadingHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

-(void)hideLoadingHUD{
    if (_loadingHUD) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        _loadingHUD = nil;
    }
}

#pragma mark - HRFWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoadingHUD];
}


@end
