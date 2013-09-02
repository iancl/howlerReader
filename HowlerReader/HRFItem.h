//
//  HRFItem.h
//  HowlerReaderFree
//
//  Created by Ian Calderon on 7/7/13.
//  Copyright (c) 2013 Ian Calderon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRFItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *publishedDate;
@property (nonatomic, copy) NSString *contentSnippet;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *itemKey;
@property (nonatomic, copy) NSString *mediaItemKey;


@end
