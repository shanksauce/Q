//
//  Q.m
//  Q
//
//  Created by Ben Shank on 7/2/12.
//  Copyright (c) 2012 Aol. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  For the full copyright and license information, please view the 
//  LICENSE file that was distributed with this source code.
//


#import "Q.h"

@implementation Q

-(id)init {
    self = [super init];
    return self;
}

-(NSString *)getLength:(NSString *)id {
    NSString *s = [apiUrl stringByAppendingString:@"getLength&a="];
    s = [s stringByAppendingString:id];

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:s]];
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return [NSString stringWithFormat:@"%d",[[jsonDict objectForKey:@"numInFront"] intValue]];
}

-(void)registerMerchant:(NSString *)id {
    NSString *s = [apiUrl stringByAppendingString:@"registerMerchant&a="];
    s = [s stringByAppendingString:id];
    [NSData dataWithContentsOfURL:[NSURL URLWithString:s]];
}

-(NSArray *)getMerchants {
    NSString *s = [apiUrl stringByAppendingString:@"getMerchants"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:s]]];
    NSArray *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return jsonDict;
}

-(NSString *)add:(NSString *)id {
    NSString *s = [apiUrl stringByAppendingString:@"add&a=[\%22"];
    s = [s stringByAppendingString:id];
    s = [s stringByAppendingString:@"\%22,\%22ABC\%22]"];
    [NSData dataWithContentsOfURL:[NSURL URLWithString:s]];
    return [self getLength:id];
}

-(NSString *)remove:(NSString *)id withDeviceId:(NSString *)deviceId {
    NSString *s = [apiUrl stringByAppendingString:@"remove&a=[\%22"];
    s = [s stringByAppendingString:id];
    s = [s stringByAppendingString:@"\%22,\%22"];
    s = [s stringByAppendingString:deviceId];
    s = [s stringByAppendingString:@"\%22]"];

    [NSData dataWithContentsOfURL:[NSURL URLWithString:s]];
    return [self getLength:id];
}



@end
