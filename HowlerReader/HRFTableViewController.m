//
//  HRFTableViewController.m
//  HowlerReader
//
//  Created by Ian Calderon on 7/30/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import "HRFTableViewController.h"
#import "HRFFeedChannelStore.h"
#import "HRFFeedChannel.h"
#import "HRFItemStore.h"
#import "HRFItem.h"
#import "HRFWebViewController.h"
#import "HRFFavoriteChannel.h"
#import "HRFFavoriteChannelStore.h"

@interface HRFTableViewController ()


-(void)favoritesButtonTapped: (id)sender;


@end

@implementation HRFTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _allItems = [[HRFItemStore sharedStore] allItems];
        _currentChannel = [[[HRFFeedChannelStore sharedStore] getAllFeedChannels] lastObject];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set nav bar title
    [self.navigationItem setTitle:_currentChannel.title];
    
    // add favs button
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"add fav" style:UIBarButtonItemStyleBordered target:self action:@selector(favoritesButtonTapped:)];
    
    [self.navigationItem setRightBarButtonItem:item];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)favoritesButtonTapped:(id)sender{
    HRFFavoriteChannel *favorite = [[HRFFavoriteChannelStore sharedStore] favoriteForKey:_currentChannel.feedURL];
    
    if (favorite) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"warning" message:@"channels is already a favorite" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"warning" message:@"set favorite name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert setDelegate:self];
        [alert show];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // very simple and without validation
    UITextField *txField = [alertView textFieldAtIndex:0];
    
    HRFFavoriteChannel *fav = [[HRFFavoriteChannel alloc] init];
    [fav setName:txField.text];
    [fav setUrl:_currentChannel.feedURL];
    
    [[HRFFavoriteChannelStore sharedStore] setFavorite:fav forKey:_currentChannel.feedURL];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _allItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //set cell text
    
    HRFItem *item = [_allItems objectAtIndex:indexPath.row];
    
    [[cell textLabel] setText:item.title];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    HRFItem *item = [_allItems objectAtIndex:indexPath.row];
    
    HRFWebViewController *webView = [[HRFWebViewController alloc] initWithStringURL:item.link channelTitle:item.title];
    
    [self.navigationController pushViewController:webView animated:YES];
}

@end
