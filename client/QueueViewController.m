//
//  ViewController.m
//  Q
//
//  Created by Ben Shank on 4/3/12.
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


#import "QueueViewController.h"
#import "TicketViewController.h"
#import "Q.h"

@implementation QueueViewController

@synthesize peopleInFront;
@synthesize averageWaitTime;
@synthesize estimatedService;
@synthesize queueIdLabel;

-(id)initQueueViewController:(Q *)manager {
    self = [super initWithNibName:@"QueueViewController" bundle:nil];
    if(self) amqp = manager;
    return self;
}

-(void)setActiveQueueId:(NSString *)id {
    activeQueueId = id;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Q";
    ticketViewController = [[TicketViewController alloc] initTicketViewController:amqp withActiveQueueId:activeQueueId];
    peopleInFront.text = [amqp getLength:activeQueueId];
    averageWaitTime.text = @"12 minutes";
    estimatedService.text = @"1:15pm";
    queueIdLabel.text = activeQueueId;
}

-(IBAction)buttonPressed:(id)sender {
    self.peopleInFront.text = [amqp add:activeQueueId];
    [self.navigationController pushViewController:ticketViewController animated:YES];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [super dealloc];
}

-(void)viewDidUnload {
    [super viewDidUnload];
    [ticketViewController release]; 
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    peopleInFront.text = [amqp getLength:activeQueueId];
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

@end
