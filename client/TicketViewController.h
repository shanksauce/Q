//
//  TicketViewController.h
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


#import <UIKit/UIKit.h>

@class Q;

@interface TicketViewController : UIViewController {
    @private Q *amqp;
    @private NSString *activeQueueId;    
}

-(id)initTicketViewController:(Q *)manager withActiveQueueId:(NSString *)qid;
-(IBAction)buttonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *qrImage;
@property (strong, nonatomic) IBOutlet UILabel *uuidLabel;

@end
