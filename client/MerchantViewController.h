//
//  MerchantViewController.h
//  Q
//
//  Created by Ben Shank on 7/3/12.
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
@class QueueViewController;

@interface MerchantViewController : UITableViewController {
    @private Q *amqp;
    @private QueueViewController *queueViewController;
    @private NSMutableArray *tableItems;
}

-(id)initMerchantViewController:(Q *)manager;

@end
