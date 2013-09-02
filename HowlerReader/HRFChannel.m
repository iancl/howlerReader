//
//  HRFChannel.m
//  HowlerReaderFree
//
//  Created by Ian Calderon on 7/7/13.
//  Copyright (c) 2013 Ian Calderon. All rights reserved.
//

#import "HRFChannel.h"

@implementation HRFChannel
@synthesize title = _title, link = _link;


-(NSString *)description{
    return [NSString stringWithFormat:@"channel:%@", _title];
}
/*
-(void)dealloc{
    NSLog(@"destroyed channel: %@", _title);
}
*/
@end
