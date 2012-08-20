//
//  TicketViewController.m
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


#import "TicketViewController.h"
#import "Q.h"

@implementation TicketViewController

@synthesize qrImage;
@synthesize uuidLabel;

-(id)initTicketViewController:(Q *)manager withActiveQueueId:(NSString *)qid {
    self = [super initWithNibName:@"TicketViewController" bundle:nil];
    if(self) {
        amqp = manager;
        activeQueueId = qid;
    }
    return self;
}

-(IBAction)buttonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [amqp remove:activeQueueId withDeviceId:@"ABC"];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Q";
    
    NSString *uuid = nil;
    CFUUIDRef theUUID = CFUUIDCreate(kCFAllocatorDefault);
    if(theUUID) {
        uuid = NSMakeCollectable(CFUUIDCreateString(kCFAllocatorDefault, theUUID));
        [uuid autorelease];
        CFRelease(theUUID);
    }

    NSString *s = @"https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl=";
    s = [s stringByAppendingString:uuid];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:s]];
    UIImage *im = [UIImage imageWithData:data];
    [self.qrImage setImage:im];
    
    self.uuidLabel.text = uuid;
}

-(void)viewDidUnload {
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [super dealloc];
}

@end
