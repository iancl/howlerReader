//
//  HRFFavoritesViewController.h
//  HowlerReader
//
//  Created by Ian Calderon on 7/29/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRFProtocols.h"

@interface HRFFavoritesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *_allFavoriteChannels;
    
}

@property (weak, nonatomic) id<HRFFavoritesViewControllerDelegate> delegate;

@end
