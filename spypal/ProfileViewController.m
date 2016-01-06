//
//  ProfileViewController.m
//  spypal
//
//  Created by Andrei Constantinescu on 31/03/15.
//  Copyright (c) 2015 Andrei Constantinescu. All rights reserved.
//

#import "ProfileViewController.h"
#import "ViewController.h"

@interface ProfileViewController () <UIGestureRecognizerDelegate>
- (IBAction)saveSettings:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nicknameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    
    [query whereKey:@"phoneNumber" equalTo:phoneNumber ];
    [query findObjectsInBackgroundWithBlock:^(NSArray *userObjects, NSError *error) {
        
        if (!error) {
            NSLog(@"Successfully retrieved.");
            for (PFObject *userObject in userObjects){
                // TODO de facut obiect cu long si lat
                //                userObject[@"currentLocationLong"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLong"];
                _nicknameField.text = userObject[@"nickname"];
                [_nicknameField setTextAlignment:NSTextAlignmentCenter];
                _emailField.text = userObject[@"email"];
                [_emailField setTextAlignment:NSTextAlignmentCenter];
                [userObject saveInBackground];
            }
        }
    }];
}

-(void)dismissKeyboard {
    [_nicknameField resignFirstResponder];
    [_emailField resignFirstResponder];
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

- (IBAction)saveSettings:(id)sender {
    NSString *nickname = _nicknameField.text;
    NSString *email = _emailField.text;
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    
    [query whereKey:@"phoneNumber" equalTo:phoneNumber ];
    [query findObjectsInBackgroundWithBlock:^(NSArray *userObjects, NSError *error) {
        
        if (!error) {
            NSLog(@"Successfully retrieved.");
            for (PFObject *userObject in userObjects){
                // TODO de facut obiect cu long si lat
                //                userObject[@"currentLocationLong"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLong"];
                userObject[@"nickname"] = nickname;
                userObject[@"email"] = email;
                [userObject saveInBackground];
            }
        }
    }];
    
}
@end
