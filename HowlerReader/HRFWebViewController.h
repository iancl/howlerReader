//
//  HRFWebViewController.h
//  HowlerReader
//
//  Created by Ian Calderon on 7/30/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface HRFWebViewController : UIViewController<UIWebViewDelegate>{
    
    MBProgressHUD *_loadingHUD;
    
}

@property (copy, nonatomic) NSString *currentURL;
@property (copy, nonatomic) NSString *channelTitle;

// designated init
-(id)initWithStringURL: (NSString *)strURL channelTitle: (NSString *)title;

// show hide loading HUD
-(void)showLoadingHUD;
-(void)hideLoadingHUD;

@end
