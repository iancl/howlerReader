//
//  HRFMainViewController.h
//  HowlerReader
//
//  Created by ian.calderon on 7/29/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "HRFProtocols.h"

@interface HRFMainViewController : UIViewController<UISearchBarDelegate, UIPopoverControllerDelegate, HRFFavoritesViewControllerDelegate, HRFSearchViewControllerDelegate, HRFMappingOperationDelegate>{
    
    // will hold a reference of the seach popover
    UIPopoverController *_searchPopover;
    
    // flags
    BOOL _isAnimating;
    
    // loading HUD
    MBProgressHUD *_loadingHUD;
    
    // feed Channel Mapping
    NSOperationQueue *_feedMappingQueue;

}

// show/hide loading hud
-(void)showLoadingHUD;
-(void)hideLoadingHUD;

@end
