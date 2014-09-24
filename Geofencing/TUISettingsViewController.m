//
//  TUISettingsViewController.m
//  Geofencing
//
//  Created by Diego Lafuente on 23/09/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "TUISettingsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"

@interface TUISettingsViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *region1LatitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *region1LongitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *region1RadiusTextField;

@property (weak, nonatomic) IBOutlet UITextField *region2LatitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *region2LongitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *region2RadiusTextField;

@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)currentLocation1Clicked:(id)sender;
- (IBAction)currentLocation2Clicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;


@end

@implementation TUISettingsViewController


#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTextFieldsWithStoredValues];
    _locationManager = [CLLocationManager new];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
}

- (void) initTextFieldsWithStoredValues
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *region1 = [userDefaults dictionaryForKey:REGION_1_IDENTIFIER];
    if (region1)
    {
        _region1LatitudeTextField.text = [(NSNumber *)region1[@"latitude"] stringValue];
        _region1LongitudeTextField.text = [(NSNumber *)region1[@"longitude"] stringValue];
        _region1RadiusTextField.text = [(NSNumber *)region1[@"radius"] stringValue];
    }
    
    NSDictionary *region2 = [userDefaults dictionaryForKey:REGION_2_IDENTIFIER];
    if (region2)
    {
        _region2LatitudeTextField.text = [(NSNumber *)region2[@"latitude"] stringValue];
        _region2LongitudeTextField.text = [(NSNumber *)region2[@"longitude"] stringValue];
        _region2RadiusTextField.text = [(NSNumber *)region2[@"radius"] stringValue];
    }
}


#pragma mark - Persist into NSUserDefaults

- (void)persistValues
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:@{@"latitude": @([_region1LatitudeTextField.text floatValue]),
                              @"longitude": @([_region1LongitudeTextField.text floatValue]),
                              @"radius": @([_region1RadiusTextField.text floatValue]),
                              @"identifier": REGION_1_IDENTIFIER} forKey:REGION_1_IDENTIFIER];
    
    [userDefaults setObject:@{@"latitude": @([_region2LatitudeTextField.text floatValue]),
                              @"longitude": @([_region2LongitudeTextField.text floatValue]),
                              @"radius": @([_region2RadiusTextField.text floatValue]),
                              @"identifier": REGION_2_IDENTIFIER} forKey:REGION_2_IDENTIFIER];
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Keyboard hiding -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - Buttons clicked

- (IBAction)currentLocation1Clicked:(id)sender
{
    [_region1LatitudeTextField setEnabled:NO];
    [_region1LongitudeTextField setEnabled:NO];
    [_locationManager startUpdatingLocation];
}

- (IBAction)currentLocation2Clicked:(id)sender
{
    [_region2LatitudeTextField setEnabled:NO];
    [_region2LongitudeTextField setEnabled:NO];
    [_locationManager startUpdatingLocation];
}

- (IBAction)doneButtonClicked:(id)sender
{
    [self persistValues];
    [_delegate modalViewAboutToBeDismissed];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Did update locations");
    [_locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    if (![_region1LatitudeTextField isEnabled])
    {
        [_region1LatitudeTextField setEnabled:YES];
        _region1LatitudeTextField.text = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    }
    if (![_region1LongitudeTextField isEnabled])
    {
        [_region1LongitudeTextField setEnabled:YES];
        _region1LongitudeTextField.text = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    }
    if (![_region2LatitudeTextField isEnabled])
    {
        [_region2LatitudeTextField setEnabled:YES];
        _region2LatitudeTextField.text = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    }
    if (![_region2LongitudeTextField isEnabled])
    {
        [_region2LongitudeTextField setEnabled:YES];
        _region2LongitudeTextField.text = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Did fail with error: %@", error);
    [_region1LatitudeTextField setEnabled:YES];
    [_region1LongitudeTextField setEnabled:YES];
    [_region2LatitudeTextField setEnabled:YES];
    [_region2LongitudeTextField setEnabled:YES];
}
@end
