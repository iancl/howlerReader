//
//  HRFMappingOperation.m
//  HowlerReader
//
//  Created by ian.calderon on 7/30/13.
//  Copyright (c) 2013 ian.calderon. All rights reserved.
//

#import "HRFMappingOperation.h"

#import "HRFUtils.h"

#import "HRFFeedChannelStore.h"
#import "HRFFeedChannel.h"

#import "HRFQueriedChannelStore.h"
#import "HRFQueriedChannel.h"

#import "HRFItemStore.h"
#import "HRFItem.h"

#import "HRFMediaItemStore.h"
#import "HRFMediaItem.h"

@implementation HRFMappingOperation
@synthesize targetObjectType = _targetObjectType, dictData = _dictData, delegate = _delegate;

// designated initializer
-(id)initWithObjectType:(HRFObjectType)type dataDict:(NSDictionary *)dict{
    
    self = [super init];
    
    if (self) {
        self.targetObjectType = type;
        self.dictData = dict;
    }
    
    return self;
}

-(void)main{
    
    switch (self.targetObjectType) {
        case kQueriedChannelObjectType:{
            
            // kill thread if cancelled
            if(self.isCancelled) return;
            
            //start mapping queried channels
            //release previous items
            [[HRFQueriedChannelStore sharedStore] releaseAllQueriedChannels];
            
            NSMutableArray *channels = [NSMutableArray array];
            
            NSArray *channelsData = [self.dictData valueForKeyPath:@"responseData.entries"];
            
            //throw exeption if dict is not valid
            if (!channelsData) {
                [NSException raise:@"Invalid Channels Data Array" format:@"invalid dictionary data:%@",self.dictData];
            }
            
            // kill thread if cancelled
            if(self.isCancelled) return;
            
            // iterate through each item in array and create channel using data
            for (NSDictionary *chanData in channelsData) {
                
                HRFQueriedChannel *newChannel = [[HRFQueriedChannel alloc] init];
                
                [newChannel setUrl:[chanData objectForKey:@"url"]];
                [newChannel setTitle:[chanData objectForKey:@"title"]];
                [newChannel setContentSnippet:[chanData objectForKey:@"contentSnippet"]];
                [newChannel setLink:[chanData objectForKey:@"link"]];
                
                [channels addObject:newChannel];
                
            }
            
            // kill thread if cancelled
            if(self.isCancelled) return;
            
            // calling delegate method on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // kill thread if cancelled
                if(self.isCancelled) return;
                
                // update queried channel store
                [[HRFQueriedChannelStore sharedStore] addQueriedChannelsUsingContentsOfArray:channels];
                
                if ([self.delegate respondsToSelector:@selector(mappingQueriedChannelProcessOperationDidFinishMappingData)]) {
                    [self.delegate mappingQueriedChannelProcessOperationDidFinishMappingData];
                }
                
            });
            
            
        }
            break;
            
        case kFeedChannelObjectType:{
            
            // kill thread if cancelled
            if(self.isCancelled) return;
            
            // start mapping feed channels
            // getting feedChannel data from dictionary
            NSDictionary *feedChannelData = [self.dictData valueForKeyPath:@"responseData.feed"];
            
            HRFFeedChannel *feedChannel = nil;
            
            // if any feed channel found
            if (feedChannelData) {
                
                // creating current feedChannel
                feedChannel = [[HRFFeedChannel alloc] init];
                
                // setting feedChannel values
                [feedChannel setTitle:[feedChannelData objectForKey:@"title"]];
                [feedChannel setLink:[feedChannelData objectForKey:@"link"]];
                [feedChannel setFeedURL:[feedChannelData objectForKey:@"feedUrl"]];
                [feedChannel setAuthor:[feedChannelData objectForKey:@"author"]];
                [feedChannel setDescription:[feedChannelData objectForKey:@"description"]];
                [feedChannel setType:[feedChannelData objectForKey:@"type"]];
                
                // kill thread if cancelled
                if(self.isCancelled) return;
                
                // fetching all items data
                NSArray *itemsData = [feedChannelData objectForKey:@"entries"];
                
                // if theres item data available
                if (itemsData && itemsData.count > 0) {
                    
                    [[HRFItemStore sharedStore] releaseAllItems];
                    
                    // generating items key
                    NSString *itemsKey = [[HRFUtils sharedUtils] generateUUID];
                    
                    // adding key to feedChannel
                    [feedChannel setItemKey:itemsKey];
                    
                    // kill thread if cancelled
                    if(self.isCancelled) return;
                    
                    // creating an item for each key
                    for (int i=0; i < itemsData.count; i++) {
                        
                        // getting current item data from itemsData
                        NSDictionary *currentItemData = [itemsData objectAtIndex:i];
                        
                        // creating current item
                        HRFItem *item = [[HRFItemStore sharedStore] addItem];
                        
                        // setting item properties
                        [item setTitle:[currentItemData objectForKey:@"title"]];
                        [item setLink:[currentItemData objectForKey:@"link"]];
                        [item setAuthor:[currentItemData objectForKey:@"author"]];
                        [item setPublishedDate:[currentItemData objectForKey:@"publishedDate"]];
                        [item setContentSnippet:[currentItemData objectForKey:@"contentSnippet"]];
                        [item setContent:[currentItemData objectForKey:@"content"]];
                        [item setItemKey:itemsKey];
                        
                        //get mediaItemData from currentItemData
                        NSArray *mediaItemsData = [currentItemData objectForKey:@"mediaGroups"];
                        NSDictionary *mediaItemsContentsData = [mediaItemsData objectAtIndex:0];
                        NSArray *allMediaContentData = [mediaItemsContentsData objectForKey:@"contents"];
                        
                        // kill thread if cancelled
                        if(self.isCancelled) return;
                        
                        // if any mediaItemData on Array
                        if (allMediaContentData && allMediaContentData.count > 0) {
                            
                            [[HRFMediaItemStore sharedStore] releaseAllMediaItems];
                            
                            //generate media items key for each item
                            NSString *mediaItemsKey = [[HRFUtils sharedUtils] generateUUID];
                            
                            // add media key to current item
                            [item setMediaItemKey:mediaItemsKey];
                            
                            //iterate through each media item content found
                            for (int x=0; x < allMediaContentData.count; x++) {
                                
                                // kill thread if cancelled
                                if(self.isCancelled) return;
                                
                                // current media item data
                                NSDictionary *currentMediaContentData = [allMediaContentData objectAtIndex:x];
                                
                                // new mediaItem instance
                                HRFMediaItem *mediaItem = [[HRFMediaItemStore sharedStore] addMediaItem];
                                
                                //nsnumber valies from data
                                int h = [[currentMediaContentData objectForKey:@"height"] intValue];
                                int w = [[currentMediaContentData objectForKey:@"width"] intValue];
                                
                                //setting values
                                [mediaItem setKey:mediaItemsKey];
                                [mediaItem setUrl:[currentMediaContentData objectForKey:@"url"]];
                                [mediaItem setType:[currentMediaContentData objectForKey:@"type"]];
                                [mediaItem setMedium:[currentMediaContentData objectForKey:@"medium"]];
                                [mediaItem setHeight:h];
                                [mediaItem setWidth:w];
                                
                            }//end mediaItem loop
                            
                        }//end if allMediaContentData condition
                        
                    }//end item loop
                    
                }// end if item condition
                
            }
            
            // call delegate method
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // update feed channel store
                [[HRFFeedChannelStore sharedStore] addAFeedChannel:feedChannel];
                
                // call delegate method
                if ([self.delegate respondsToSelector:@selector(mappingFeedChannelProcessOperationDidFinishMappingData)]) {
                    [self.delegate mappingFeedChannelProcessOperationDidFinishMappingData];
                }
                
                
            });
            
        }
            break;
            
        default:
            //do nothing
            break;
    }
    
}

@end
