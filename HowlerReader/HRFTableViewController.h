//
//  HRFTableViewController.h
//  HowlerReader
//
//  Created by Ian Calderon on 7/30/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRFFeedChannel;

@interface HRFTableViewController : UITableViewController<UIAlertViewDelegate>{
    
    NSArray *_allItems;
    HRFFeedChannel *_currentChannel;
}


@end
