//
//  HRFProtocols.h
//  HowlerReader
//
//  Created by ian.calderon on 7/29/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HRFHTTPClient, HRFFavoritesViewController, HRFMappingOperation, HRFSearchViewController;


#pragma mark - HRFFavoritesViewControllerDelegateProtocol
@protocol HRFFavoritesViewControllerDelegate <NSObject>

@required
-(void)favoritesViewController: (HRFFavoritesViewController *)vc didSelectFeedChannelWithURLString: (NSString *)strURL;

@optional
-(void)shouldHideFavoritesViewController;

@end

#pragma mark - HRFSearchViewControllerDelegateProtocol
@protocol HRFSearchViewControllerDelegate <NSObject>

@required
-(void)searchViewController: (HRFSearchViewController *)vc didSelectFeedChannelWithURLString: (NSString *)strURL;

@end

#pragma mark - HRFMappingOperationDelegateProtocol
@protocol HRFMappingOperationDelegate <NSObject>

@optional
-(void)mappingQueriedChannelProcessOperationDidFinishMappingData;
-(void)mappingFeedChannelProcessOperationDidFinishMappingData;

@end



