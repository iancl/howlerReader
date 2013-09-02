//
//  HRFSearchViewController.h
//  HowlerReader
//
//  Created by Ian Calderon on 7/29/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>
#import "HRFProtocols.h"

@class HRFQueriedChannel;

@interface HRFSearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, HRFMappingOperationDelegate>{
    
    // will hold current search channels
    NSMutableArray *_allQueriedChannels;
    
    // will hold object mappings in progress
    NSOperationQueue *_mappingQueue;
    
    // loading Spinner
    MBProgressHUD *_loadingHUD;
}

@property (weak, nonatomic) id<HRFSearchViewControllerDelegate> delegate;

// will clear all data on table view
-(void)removeAllItemsFromTableView;

// show spinner
-(void)showLoadingHUD;

// hide spinner
-(void)hideLoadingHUD;

@end
