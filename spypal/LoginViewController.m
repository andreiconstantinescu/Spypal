//
//  LoginViewController.m
//  spypal
//
//  Created by Andrei Constantinescu on 11/03/15.
//  Copyright (c) 2015 Andrei Constantinescu. All rights reserved.
//

#import "LoginViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "ViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        //Verifying if a user has already signed up
       if ([[NSUserDefaults standardUserDefaults] objectForKey:@"digitsSessionAuthToken"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"digitsSessionAuthTokenSecret"])
       {
            DGTAuthenticateButton *authenticateButton = [DGTAuthenticateButton buttonWithAuthenticationCompletion:^(DGTSession *session, NSError *error) {
                NSString * storyboardName = @"Main";
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"LocationView"];
                [self presentViewController:vc animated:YES completion:nil];
               [[NSUserDefaults standardUserDefaults] setObject:session.authToken forKey:@"digitsSessionAuthToken"];
               [[NSUserDefaults standardUserDefaults] setObject:session.authTokenSecret forKey:@"digitsSessionAuthTokenSecret"];
               [[NSUserDefaults standardUserDefaults] setObject:session.phoneNumber forKey:@"phoneNumber"];
                //check if number is already in use
                PFQuery *query = [PFQuery queryWithClassName:@"User"];
                [query whereKey:@"phoneNumber" equalTo:session.phoneNumber];
                
                if (![query getFirstObject]) {
                    //if a user never used the app
                    PFObject *userData = [PFObject objectWithClassName:@"User"];
                    userData[@"nickname"] = @"Dummy";
                    userData[@"phoneNumber"] = session.phoneNumber;
                    userData[@"gravatarEmailHash"] = @"something";
                    userData[@"currentLocation"] = @"";
                    userData[@"pastLocations"] = @[];
                    [userData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            // The object has been saved.
                        } else {
                            // There was a problem, check error.description
                        }
                    }];
                    
                }
                //[[Digits sharedInstance] session].phoneNumber;
                // play with Digits session
            }];
            authenticateButton.center = self.view.center;
            [self.view addSubview:authenticateButton];
       } else {
           NSString * storyboardName = @"Main";
           UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
           UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"LocationView"];
           [self presentViewController:vc animated:YES completion:nil];

       }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
