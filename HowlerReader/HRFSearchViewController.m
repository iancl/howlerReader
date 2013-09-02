//
//  HRFSearchViewController.m
//  HowlerReader
//
//  Created by Ian Calderon on 7/29/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import "HRFSearchViewController.h"
#import "HRFMappingOperation.h"
#import "HRFConstants.h"

#import "HRFQueriedChannelStore.h"
#import "HRFQueriedChannel.h"

#import "HRFUtils.h"

#import <MBProgressHUD.h>

@interface HRFSearchViewController ()

-(void)handleNewQueriedChannelData: (NSNotification *)notification;

// table view
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HRFSearchViewController
@synthesize tableView = _tableView, delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _allQueriedChannels = [NSMutableArray array];
        _mappingQueue = [[NSOperationQueue alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //subscribe for HRFHTTPClien find channel updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNewQueriedChannelData:) name:kFindChannelDataUpdate object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    // remove from notification center
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"dealloc Search view");
}

// will clear all data on table view
-(void)removeAllItemsFromTableView{
    [_allQueriedChannels removeAllObjects];
    [[self tableView] reloadData];
}

// show spinner
-(void)showLoadingHUD{
    if (!_loadingHUD) {
        _loadingHUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [_loadingHUD setBackgroundColor:[[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];

    }
}

// hide spinner
-(void)hideLoadingHUD{
    if (_loadingHUD) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        _loadingHUD = nil;
        
    }
}

#pragma mark - NSNotificationCenter

// will process the new data received on the notification
-(void)handleNewQueriedChannelData:(NSNotification *)notification{
    
    NSDictionary *dict = [notification object];
    
    HRFMappingOperation *mapping = [[HRFMappingOperation alloc] initWithObjectType:kQueriedChannelObjectType dataDict:dict];
    [mapping setDelegate:self];
    //clear queue and start mapping new results
    [_mappingQueue cancelAllOperations];
    [_mappingQueue addOperation:mapping];
    
}

#pragma mark - HRFMappingOperationDelegate

// will be called when the mapping operation is complete
// will start showing data on screen
-(void)mappingQueriedChannelProcessOperationDidFinishMappingData{
    
    //hide spinner
    [self hideLoadingHUD];
    
    // clear local array
    [_allQueriedChannels removeAllObjects];
    
    // get channels from store and add it to local array
    [_allQueriedChannels addObjectsFromArray:[[HRFQueriedChannelStore sharedStore] allQueriedChannels]];
    
    
    //reload
    [self.tableView reloadData];
    
}


#pragma mark - UITableViewDataSourceDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allQueriedChannels.count;
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"resultCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // setting cell values
    HRFQueriedChannel *chan = [_allQueriedChannels objectAtIndex:[indexPath row]];
    NSString *title = [[HRFUtils sharedUtils] stringByStrippingHTML:chan.title];
    [[cell textLabel] setText:title];
    
    
    return cell;
}
#pragma mark - UITableViewDelegate


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HRFQueriedChannel *chan = [_allQueriedChannels objectAtIndex:indexPath.row];
    
    //do nothing if there is no url specified
    if (!chan.url) return;
    
    // call delegate method if available
    // method is required
    [self.delegate searchViewController:self didSelectFeedChannelWithURLString:chan.url];
    
}

@end
