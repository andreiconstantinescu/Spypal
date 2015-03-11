//
//  ViewController.m
//  spypal
//
//  Created by Andrei Constantinescu on 05/03/15.
//  Copyright (c) 2015 Andrei Constantinescu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    
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
    
    _latitude.text = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
    _longitude.text = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
    _speed.text = [NSString stringWithFormat:@"%.1f m/s", crnLoc.speed];

    
    NSLog(@"dede %d", 7);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateLocation:(id)sender {

    //requesting location updates
}
@end
