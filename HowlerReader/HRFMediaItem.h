//
//  HRFMediaItem.h
//  HowlerReaderFree
//
//  Created by Ian Calderon on 7/7/13.
//  Copyright (c) 2013 Ian Calderon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRFMediaItem : NSObject



@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *medium;
@property (nonatomic) int height;
@property (nonatomic) int width;

@end
