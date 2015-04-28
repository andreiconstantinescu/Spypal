//
//  FriendDetailsViewController.m
//  spypal
//
//  Created by Andrei Constantinescu on 28/04/15.
//  Copyright (c) 2015 Andrei Constantinescu. All rights reserved.
//

#import "FriendDetailsViewController.h"

@interface FriendDetailsViewController ()
@end

@implementation FriendDetailsViewController

@synthesize usernameTextlabel = _usernameTextlabel;
@synthesize phoneNumberTextLabel = _phoneNumberTextLabel;
@synthesize latTextLabel = _latTextLabel;
@synthesize LongTextLabel = _LongTextLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_usernameTextlabel setText:labelUsername];
    [_phoneNumberTextLabel setText:labelPhonenumber];
    [_latTextLabel setText:labelLat];
    [_LongTextLabel setText:labelLong];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUsername:(NSString *)text    {
    labelUsername = text;
}

- (void) setPhonenumber:(NSString *)text    {
    labelPhonenumber = text;
}

- (void) setLat:(NSString *)text    {
    labelLat = text;
}

- (void) setLong:(NSString *)text   {
    labelLong = text;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
