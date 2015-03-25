//
//  ViewController.m
//  spypal
//
//  Created by Andrei Constantinescu on 05/03/15.
//  Copyright (c) 2015 Andrei Constantinescu. All rights reserved.
//

#import "ViewController.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>


@interface ViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (weak, nonatomic) IBOutlet UILabel *speed;
- (IBAction)sendtoParse:(id)sender;
- (IBAction)logout:(id)sender;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//    testObject[@"foo"] = @"bar";
//    [testObject saveInBackground];
    
    _locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    _locationManager.delegate = self; // we set the delegate of locationManager to self.
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accurac
    
    [_latitude sizeToFit];
    [_longitude sizeToFit];
    [_speed sizeToFit];
    
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startUpdatingLocation];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *crnLoc = [locations lastObject];
    NSString *lat =  [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
    NSString *lon =  [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
    [[NSUserDefaults standardUserDefaults] setObject:lat forKey:@"currentLocationLat"];
    [[NSUserDefaults standardUserDefaults] setObject:lon forKey:@"currentLocationLon"];
    _latitude.text = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
    _longitude.text = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
    _speed.text = [NSString stringWithFormat:@"%.1f m/s", crnLoc.speed];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateLocation:(id)sender {

    //requesting location updates
}
- (IBAction)sendToParse:(id)sender {
//    Cod vechi
//
//    PFObject *location = [PFObject objectWithClassName:@"currentLocations"];
//    location[@"latitude"] = _latitude.text;
//    location[@"longitude"] = _longitude.text;
//    location[@"speed"] = _speed.text;
//    [location saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"a mers");
//        } else {
//            NSLog(@"nu a mers");
//        }
//    }];
//    PFObject *user = [PFObject objectWithClassName:@"User"];
//    user[@"currentLocation"] = location;
//    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"a mers si la user");
//        } else {
//            NSLog(@"nu a mers si la user");
//        }
//    }];
//
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    
    // Retrieve the user by phone number
    NSString *phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSLog(@"%@", phoneNumber);
    
    [query whereKey:@"phoneNumber" equalTo:phoneNumber ];
    [query findObjectsInBackgroundWithBlock:^(NSArray *userObjects, NSError *error) {
    
        if (!error) {
            NSLog(@"Successfully retrieved.");
            for (PFObject *userObject in userObjects){
                // TODO de facut obiect cu long si lat
//                userObject[@"currentLocationLong"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLong"];
                userObject[@"currentLocationLat"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLocationLat"];
                userObject[@"currentLocationLon"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLocationLon"];
                [userObject saveInBackground];
            }
        }
    }];
//
}

- (IBAction)PARSE:(UIButton *)sender {
}
- (IBAction)logout:(id)sender {
    [[Digits sharedInstance] logOut];
}
@end
