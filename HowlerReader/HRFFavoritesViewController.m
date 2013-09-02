//
//  HRFFavoritesViewController.m
//  HowlerReader
//
//  Created by Ian Calderon on 7/29/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import "HRFFavoritesViewController.h"
#import "HRFFavoriteChannelStore.h"
#import "HRFFavoriteChannel.h"

@interface HRFFavoritesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HRFFavoritesViewController
@synthesize delegate = _delegate, tableView= _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _allFavoriteChannels = [NSMutableArray array];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // load favorites from store and reload table view
    [_allFavoriteChannels addObjectsFromArray:[[HRFFavoriteChannelStore sharedStore] allFavorites]];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"dealloc favorites view");
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allFavoriteChannels.count;
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"favoriteCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // setting cell title
    HRFFavoriteChannel *chan = [_allFavoriteChannels objectAtIndex:[indexPath row]];
    NSString *title = [chan name];
    [[cell textLabel] setText:title];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HRFFavoriteChannel *chan = [_allFavoriteChannels objectAtIndex:indexPath.row];
    
    //do nothing if there is no url specified
    if (!chan.url) return;
    
    // call delegate method
    // method is required
    [self.delegate favoritesViewController:self didSelectFeedChannelWithURLString:chan.url];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
