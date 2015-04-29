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
@synthesize mapView = _mapView;
@synthesize currentFriend;

- (IBAction)callFriend:(id)sender {
    NSURL *URL = [NSURL URLWithString:[@"tel://" stringByAppendingString:labelPhonenumber]];
    
    [[UIApplication sharedApplication] openURL:URL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [_usernameTextlabel setText:labelUsername];
    [_usernameTextlabel setText:currentFriend.nickname];
    [_phoneNumberTextLabel setText:labelPhonenumber];
    [_latTextLabel setText:labelLat];
    [_LongTextLabel setText:labelLong];
    
    _phoneNumberTextLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:16];
   
    
    
    CLLocationCoordinate2D currentLocation = CLLocationCoordinate2DMake([labelLat floatValue], [labelLong floatValue]);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion reg = {currentLocation, span};
    
    MKPointAnnotation *annon = [[MKPointAnnotation alloc]init];
    [annon setCoordinate:currentLocation];
    
    [annon setTitle:labelUsername];
    
    
    [self.mapView setDelegate: self];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setRegion:reg animated:YES];
    [self.mapView addAnnotation:annon];
    
    
       
}

- (void)zoomToLocation:(CLLocation *)location
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = location.coordinate.latitude;
    zoomLocation.longitude= location.coordinate.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 7.5*1609.34,7.5*1609.34);
    [self.mapView setRegion:viewRegion animated:YES];
    [self.mapView regionThatFits:viewRegion];
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
