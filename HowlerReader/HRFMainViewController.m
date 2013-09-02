//
//  HRFMainViewController.m
//  HowlerReader
//
//  Created by ian.calderon on 7/29/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//
// THERE IS STILL SUPPORT FOR SEARCHVIEW ANIMATIONS. I WILL LEAVE IT THERE IN CASE
// IT NEEDS TO BE CHANGED IN THE FUTURE

#import "HRFMainViewController.h"
#import "HRFSearchViewController.h"
#import "HRFFavoritesViewController.h"
#import "HRFConstants.h"
#import "HRFUtils.h"
#import "HRFHTTPClient.h"
#import "HRFQueriedChannelStore.h"
#import "HRFTableViewController.h"
#import "HRFMappingOperation.h"


@interface HRFMainViewController ()

// network reachability related
-(void)networkReachabilityChangedNotification: (NSNotification *)notification;

// feedChannel related
-(void)feedChannelUpdateNotification: (NSNotification *)notification;

// favorites view related
-(void)favoritesButtonTapped: (id)sender;
-(void)showFavoritesView;
-(void)hideFavoritesView;

// properties
@property (strong, nonatomic) UISearchBar *channelSearchBar;
@property (strong, nonatomic) HRFSearchViewController *searchViewController;
@property (strong, nonatomic) HRFFavoritesViewController *favoritesViewController;

// hide searchBar keyboard
-(void)hideKeyboard;

// start making a channel search
-(void)startSearchingChannelUsingString: (NSString *)str;

// IBACTIONS
-(IBAction)ViewTapped:(id)sender;

@end

// local constants
#define ANIMATION_DURATION 0.2
#define ANIMATION_DELAY 0.0

//ENUMS
typedef enum {
    kFavoritesView = 0,
    kSearchView = 1
} SideViewIdentifier;

@implementation HRFMainViewController
@synthesize channelSearchBar = _channelSearchBar, searchViewController = _searchViewController, favoritesViewController = _favoritesViewController;


// init
-(id)init{
    
    self = [super init];
    
    if (self) {
        
        _isAnimating = NO;
        _feedMappingQueue = [[NSOperationQueue alloc] init];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // start reachability request
    [[HRFUtils sharedUtils] startReachabilityMonitor];
    
    // subscribe to reachability notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityChangedNotification:) name:kNetworkReachabilityNotificationName object:nil];
    
    // subscribe to HTTPClient feedChannel updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feedChannelUpdateNotification:) name:kLoadChannelDataUpdate object:nil];
    
    // subscribe to HRFObjectMappingOperation
    
    // set navigation bar title
    [self.navigationItem setTitle:@"Howler Reader"];
    
    // set favorites button
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Favorites" style:UIBarButtonItemStyleBordered target:self action:@selector(favoritesButtonTapped:)];
    
    // add button
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    // set uisearchBar
    self.channelSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.0)];
    [self.channelSearchBar setDelegate:self];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.channelSearchBar];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    // set view bg color
    [self.view setBackgroundColor:[UIColor colorWithRed:204.0f/255.0f green:216.0f/255.0f blue:238.0f/255.0f alpha:1.0]];

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    // removing notification observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"dealloc main view");
}




#pragma mark - Reachability

// will be invoked every time reachability status changes
-(void)networkReachabilityChangedNotification: (NSNotification *)notification {
    
    //network is reachable
    if ([[notification object] isEqual: kNetworkReachable]) {
        
        // network is not reachable
    } else {
        
        
    }
}

#pragma mark - HRFHTTPClient Updates
-(void)feedChannelUpdateNotification:(NSNotification *)notification{
    
    // storing object reference
    NSDictionary *dict = [notification object];
    
    // starting feed channel mapping process
    HRFMappingOperation *mapper = [[HRFMappingOperation alloc] initWithObjectType:kFeedChannelObjectType dataDict:dict];
    [mapper setDelegate:self];
    [_feedMappingQueue addOperation:mapper];
    
}

#pragma mark - HRFMappingOperation Updates
-(void)mappingFeedChannelProcessOperationDidFinishMappingData{
   
    // hiding loading hud
    [self hideLoadingHUD];
    
    // cancel all mapping threads
    [_feedMappingQueue cancelAllOperations];
    
    // show table view
    HRFTableViewController *tvc = [[HRFTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:tvc animated:YES];
    
}

#pragma mark - HRFFavoritesView

-(void)hideFavoritesView{
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:ANIMATION_DELAY options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         [self setInvisiblePositionForView:kFavoritesView];
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self.favoritesViewController removeFromParentViewController];
                         [self.favoritesViewController.view removeFromSuperview];
                         self.favoritesViewController = nil;
                         _isAnimating = NO;
                     }];
    
}



-(void)showFavoritesView{
    
    // create and position view
    self.favoritesViewController = [[HRFFavoritesViewController alloc] init];
    [self.favoritesViewController setDelegate:self];
    [self addChildViewController:self.favoritesViewController];
    [self resizeViewWithIdentifier:kFavoritesView];
    [self setInvisiblePositionForView:kFavoritesView];
    [self.view addSubview:self.favoritesViewController.view];
    
    
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:ANIMATION_DELAY
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setVisiblePositionForView:kFavoritesView];
                         
                     }
                     completion:^(BOOL finished){
                         _isAnimating = NO;
                     }];
}



-(void)toggleFavoritesView{
    
    // dont do anything if view is animating
    if (_isAnimating) return;
    
    
    // view is animating now
    _isAnimating = YES;
    
    if (self.favoritesViewController) {
        //[self hideOverlay];
        [self hideFavoritesView];
    } else {
        //[self showOverlay];
        [self showFavoritesView];
    }
    
}


-(void)favoritesButtonTapped:(id)sender{
    
    // dismiss popover is avaialble
    if ([_searchPopover isPopoverVisible]) {
        [_searchPopover dismissPopoverAnimated:YES];
    }
    
    //hide keyboard
    [self hideKeyboard];
    
    // show or hide favorites
    [self toggleFavoritesView];
}

#pragma mark - HRFFavoritesViewControllerDelegate

-(void)favoritesViewController:(HRFFavoritesViewController *)vc didSelectFeedChannelWithURLString:(NSString *)strURL{
    
    // hide loading hub
    [self showLoadingHUD];
    
    // start loading feed channel
    [[HRFHTTPClient sharedClient] loadRequestUsingStringUrl:strURL];
}

#pragma mark - HRFSearchViewControllerDelegate
-(void)searchViewController:(HRFSearchViewController *)vc didSelectFeedChannelWithURLString:(NSString *)strURL{
    
    // hide loading hub
    [self showLoadingHUD];
    
    //hide popover
    [_searchPopover dismissPopoverAnimated:YES];
    
    // hide keyboard
    [self hideKeyboard];
    
    // start loading feed channel
    [[HRFHTTPClient sharedClient] loadRequestUsingStringUrl:strURL];
    
}

#pragma mark - MBProgressHUD
// show/hide loading hud
-(void)showLoadingHUD{
    
    if (!_loadingHUD) {
        _loadingHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [_loadingHUD setBackgroundColor:[[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
        [_loadingHUD setLabelText:@"Loading"];
    }    
}

-(void)hideLoadingHUD{
 
    if (_loadingHUD) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        _loadingHUD = nil;
    }
    
}


#pragma mark - UISearchBarDelegate

-(void)startSearchingChannelUsingString: (NSString *)str{
    // send request only if string.count > 0
    if ([str length] > 0) {
        
        //show loading spinner on search view
        [self.searchViewController showLoadingHUD];
        
        NSString *query = [[HRFUtils sharedUtils] URLEncodeForString:str];
        
        // start a find request search
        // searchView is subscribed to receive new updates
        [[HRFHTTPClient sharedClient] cancelAllFindRequests];
        [[HRFHTTPClient sharedClient] findChannelsUsingKeywords:query];
    } else {
        [[HRFQueriedChannelStore sharedStore] releaseAllQueriedChannels];
        [self.searchViewController removeAllItemsFromTableView];
    }
    
    
    
    // show popover if it is not being shown
    if (![_searchPopover isPopoverVisible]) {
        
        // instantiate searchView if it is not instantiated
        if (!self.searchViewController) {
            self.searchViewController = [[HRFSearchViewController alloc] init];
            [self.searchViewController setDelegate:self];
        }
        
        // instantiate and show popover
        _searchPopover = [[UIPopoverController alloc] initWithContentViewController:self.searchViewController];
        [_searchPopover setDelegate:self];
        [_searchPopover presentPopoverFromBarButtonItem:[self.navigationItem rightBarButtonItem] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }

}

// show popover when user is typing
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self startSearchingChannelUsingString:searchText];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
   
    // hide favs view if necessary
    [self hideFavoritesView];
    
    [self startSearchingChannelUsingString:[searchBar text]];
    
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self startSearchingChannelUsingString:[searchBar text]];
}

// hides search bar keyboard
-(void)hideKeyboard{
    if (self.channelSearchBar) {
        [self.channelSearchBar endEditing:YES];
        
    }
}

#pragma mark - IUPopoverControllerDelegate

// hides keyboard when popover is going to be dismissed
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    
    // hide keyboard
    [self hideKeyboard];
    
    //cancel all find requests
    [[HRFHTTPClient sharedClient] cancelAllFindRequests];
    
    return YES;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    
    // release searchViewController
    self.searchViewController = nil;
    
    // release popover
    [_searchPopover setDelegate:nil];
    _searchPopover = nil;
    
}

#pragma mark - IBACTIONs

// view was tapped
-(IBAction)ViewTapped:(id)sender{
    [self hideKeyboard];
    [self hideFavoritesView];
}

#pragma mark - ResizeAndPositionViews

// will resize view specified with identifier search or favorites view
-(void)resizeViewWithIdentifier: (SideViewIdentifier)identifier{
    
    CGRect frame = self.view.frame;
    
    switch (identifier) {
        case kFavoritesView:{
            frame.size.width = frame.size.width / 2;
            [self.favoritesViewController.view setFrame:frame];
        }
            break;
            
        case kSearchView:{
            frame.size.width = frame.size.width / 2;
            [self.searchViewController.view setFrame:frame];
        }
            break;
            
        default:
            // do nothing
            break;
    }
    
}

// will set invisible position specified with identifier search or favorites view
-(void)setInvisiblePositionForView: (SideViewIdentifier)identifier{
    
    CGRect mainFrame = self.view.frame;
    
    switch (identifier) {
        case kFavoritesView:{
            
            CGRect frame = self.favoritesViewController.view.frame;
            frame.origin.x = frame.size.width * -1;
            [self.favoritesViewController.view setFrame:frame];
            
        }
            break;
            
        case kSearchView:{
            
            CGRect frame = self.searchViewController.view.frame;
            frame.origin.x = mainFrame.size.width;
            [self.searchViewController.view setFrame:frame];
        }
            break;
            
        default:
            // do nothing
            break;
    }
    
}

// will set visible position specified with identifier search or favorites view
-(void)setVisiblePositionForView:(SideViewIdentifier)identifier{
    
    CGRect mainFrame = self.view.frame;
    
    switch (identifier) {
        case kFavoritesView:{
            CGRect frame = self.favoritesViewController.view.frame;
            frame.origin.x = 0;
            [self.favoritesViewController.view setFrame:frame];
            
        }
            break;
            
        case kSearchView:{
            
            CGRect frame = self.searchViewController.view.frame;
            frame.origin.x = mainFrame.size.width / 2;
            [self.searchViewController.view setFrame:frame];
        }
            break;
            
        default:
            // do nothing
            break;
    }
    
}

#pragma mark - HandleOrientationChanges
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return YES;
    
}

@end
