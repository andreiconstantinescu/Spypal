//
//  FriendDetailsViewController.h
//  spypal
//
//  Created by Andrei Constantinescu on 28/04/15.
//  Copyright (c) 2015 Andrei Constantinescu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendDetailsViewController : UIViewController {
    NSString *labelUsername;
    NSString *labelPhonenumber;
    NSString *labelLat;
    NSString *labelLong;
}

@property (weak, nonatomic) IBOutlet UILabel *usernameTextlabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *latTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *LongTextLabel;

- (void) setUsername: (NSString *)text;
- (void) setPhonenumber: (NSString *)text;
- (void) setLat: (NSString *)text;
- (void) setLong: (NSString *)text;

@end
