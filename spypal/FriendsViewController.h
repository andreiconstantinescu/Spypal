//
//  FriendsViewController.h
//  spypal
//
//  Created by Andrei Constantinescu on 08/04/15.
//  Copyright (c) 2015 Andrei Constantinescu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

typedef void (^AddresBookFetchResult)(NSArray *fetchResults, NSError *error);
@end
