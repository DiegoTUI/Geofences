//
//  TUIViewController.m
//  Geofencing
//
//  Created by Diego Lafuente on 23/09/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "TUIViewController.h"
#import "TUISettingsViewController.h"
#import "TUIAppDelegate.h"
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>
#include <stdlib.h>

@interface TUIViewController () <CLLocationManagerDelegate, TUIModalViewControllerDelegate, TUIAppNotificationDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLCircularRegion *region1;
@property (strong, nonatomic) CLCircularRegion *region2;

@property (weak, nonatomic) IBOutlet UILabel *region1Label;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *region2Label;

@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;

@property (strong, nonatomic) NSMutableSet *currentRegions;
@property (nonatomic) BOOL isFirstLocationUpdate;

@end

@implementation TUIViewController


#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setUserDefaultsIfNeeded];
    [self initLocationServices];
    [self stopMonitoringRegions];
    [self startMonitoringRegions];
    [self setupLabels];
    
    // become delegate for the apps local notifications
    [(TUIAppDelegate *)[[UIApplication sharedApplication] delegate] setDelegate:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}


#pragma mark - Init

- (void)setupLabels
{
    _region1Label.textColor = [UIColor redColor];
    _region2Label.textColor = [UIColor blueColor];
}

#pragma mark - Hide/Show labels

- (void)showAllLabels
{
}

- (void)hideAllLabels
{
}


#pragma mark - Location services

- (void)initLocationServices
{
    _locationManager = [CLLocationManager new];
    //_locationManager.distanceFilter = 10.0;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    
    _currentRegions = [NSMutableSet set];
    _isFirstLocationUpdate = YES;
}

- (void)stopMonitoringRegions
{
    /*for (CLRegion *region in _locationManager.monitoredRegions)
    {
        NSLog(@"Stop monitoring for region: %@", region.identifier);
        [_locationManager stopMonitoringForRegion:region];
    }*/
    
    [_locationManager stopUpdatingLocation];
    
}

- (void)startMonitoringRegions
{
    //update regions
    [self updateRegions];
    
    [_locationManager startUpdatingLocation];
    
    //[_locationManager startMonitoringForRegion:_region1];
    //[_locationManager startMonitoringForRegion:_region2];
}

- (void)updateRegions
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *region1Dictionary = [userDefaults objectForKey:REGION_1_IDENTIFIER];
    _region1 = region1Dictionary ? [self regionFromDictionary:region1Dictionary] : nil;
    
    NSDictionary *region2Dictionary = [userDefaults objectForKey:REGION_2_IDENTIFIER];
    _region2 = region2Dictionary ? [self regionFromDictionary:region2Dictionary] : nil;
}

- (CLCircularRegion *)regionFromDictionary:(NSDictionary *)dictionary
{
    return [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake([(NSNumber *)dictionary[@"latitude"] doubleValue], [(NSNumber *)dictionary[@"longitude"] doubleValue])
                                             radius:[(NSNumber *)dictionary[@"radius"] doubleValue]
                                         identifier:(NSString *)dictionary[@"identifier"]];
}

- (void)didEnterRegion:(CLRegion *)region
{
    // notify here whatever you need to notify
    NSLog(@"Did enter region: %@", region.identifier);
    
    _statusLabel.text = [NSString stringWithFormat:@"entered %@", region.identifier];
    
    if ([region.identifier isEqualToString:REGION_1_IDENTIFIER])
    {
        _region1Label.text = @"Inside Region 1";
    }
    if ([region.identifier isEqualToString:REGION_2_IDENTIFIER])
    {
        _region2Label.text = @"Inside Region 2";
    }
    // send notifications
    NSLog(@"Sending notification for %@", region.identifier);
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    //localNotification.fireDate = [NSDate date];
    NSString *alertBody = [region.identifier isEqualToString:REGION_1_IDENTIFIER] ? @"Check out this cool facts about Palma Cathedral!!" : @"Happy hour now at Tony's. You are right there!!";
    localNotification.alertBody = alertBody;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.userInfo = @{@"regionId": region.identifier};
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)didExitRegion:(CLRegion *)region
{
    NSLog(@"Did exit region: %@", region.identifier);
    
    _statusLabel.text = [NSString stringWithFormat:@"exited %@", region.identifier];
    
    if ([region.identifier isEqualToString:REGION_1_IDENTIFIER])
    {
        _region1Label.text = @"Outside Region 1";
    }
    if ([region.identifier isEqualToString:REGION_2_IDENTIFIER])
    {
        _region2Label.text = @"Outside Region 2";
    }
}


#pragma mark - CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"Did update locations: %d", arc4random_uniform(100));
    CLLocation *location = [locations lastObject];
    // check for region 1
    if ([_region1 containsCoordinate:location.coordinate])
    {
        if (![_currentRegions containsObject:_region1])
        {
            [_currentRegions addObject:_region1];
            if (!_isFirstLocationUpdate)
            {
                [self didEnterRegion:_region1];
            }
            else
            {
                _isFirstLocationUpdate = NO;
            }
        }
    }
    else
    {
        if ([_currentRegions containsObject:_region1])
        {
            [_currentRegions removeObject:_region1];
            [self didExitRegion:_region1];
        }
    }
    // check for region 2
    if ([_region2 containsCoordinate:location.coordinate])
    {
        if (![_currentRegions containsObject:_region2])
        {
            [_currentRegions addObject:_region2];
            if (!_isFirstLocationUpdate)
            {
                [self didEnterRegion:_region2];
            }
            else
            {
                _isFirstLocationUpdate = NO;
            }
        }
    }
    else
    {
        if ([_currentRegions containsObject:_region2])
        {
            [_currentRegions removeObject:_region2];
            [self didExitRegion:_region2];
        }
    }
    
    _latitudeLabel.text = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    _longitudeLabel.text = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    
    UIColor *textColor = [UIColor blackColor];
    if ([_region1 containsCoordinate:location.coordinate]) textColor = [UIColor redColor];
    if ([_region2 containsCoordinate:location.coordinate]) textColor = [UIColor blueColor];
    if ([_region1 containsCoordinate:location.coordinate] && [_region2 containsCoordinate:location.coordinate]) textColor = [UIColor greenColor];
    
    _latitudeLabel.textColor = textColor;
    _longitudeLabel.textColor = textColor;
    
    /*[_locationManager requestStateForRegion:_region1];
    [_locationManager requestStateForRegion:_region2];*/
}

/*- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"Did enter region: %@", region.identifier);
    
    _statusLabel.text = [NSString stringWithFormat:@"entered %@", region.identifier];
    
    if ([region.identifier isEqualToString:REGION_1_IDENTIFIER])
    {
        _region1Label.text = @"Inside Region 1";
    }
    if ([region.identifier isEqualToString:REGION_2_IDENTIFIER])
    {
        _region2Label.text = @"Inside Region 2";
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"Did exit region: %@", region.identifier);
    
    _statusLabel.text = [NSString stringWithFormat:@"exited %@", region.identifier];
    
    if ([region.identifier isEqualToString:REGION_1_IDENTIFIER])
    {
        _region1Label.text = @"Outside Region 1";
    }
    if ([region.identifier isEqualToString:REGION_2_IDENTIFIER])
    {
        _region2Label.text = @"Outside Region 2";
    }
}
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"Did start monitoring for region: %@", region.identifier);
    
    _statusLabel.text = [NSString stringWithFormat:@"started %@", region.identifier];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"Did determine state %d for region: %@", (int)state, region.identifier);
    if ([region.identifier isEqualToString:REGION_1_IDENTIFIER])
    {
        if (state == CLRegionStateOutside)
            _region1Label.text = @"Outside Region 1";
        if (state == CLRegionStateInside)
            _region1Label.text = @"Inside Region 1";
    }
    if ([region.identifier isEqualToString:REGION_2_IDENTIFIER])
    {
        if (state == CLRegionStateOutside)
            _region2Label.text = @"Outside Region 2";
        if (state == CLRegionStateInside)
            _region2Label.text = @"Inside Region 2";
    }
}*/


#pragma mark - TUIModalViewController delegate

- (void)modalViewAboutToBeDismissed
{
    [self stopMonitoringRegions];
    [self startMonitoringRegions];
}


#pragma mark - TUIModalViewController delegate

- (void)receivedNotificationInRegion:(NSString *)regionIdentifier
{
    NSLog(@"Did receive local notification for: %@", regionIdentifier);
}


#pragma mark - User defaults

- (void) setUserDefaultsIfNeeded
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![userDefaults dictionaryForKey:REGION_1_IDENTIFIER])
    {
        [userDefaults setObject:@{@"latitude": @REGION_1_LATITUDE,
                                  @"longitude": @REGION_1_LONGITUDE,
                                  @"radius": @REGION_1_RADIUS,
                                  @"identifier": REGION_1_IDENTIFIER} forKey:REGION_1_IDENTIFIER];
    }
    
    if (![userDefaults dictionaryForKey:REGION_2_IDENTIFIER])
    {
        [userDefaults setObject:@{@"latitude": @REGION_2_LATITUDE,
                                  @"longitude": @REGION_2_LONGITUDE,
                                  @"radius": @REGION_2_RADIUS,
                                  @"identifier": REGION_2_IDENTIFIER} forKey:REGION_2_IDENTIFIER];
    }
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TUISettingsViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.delegate = self;
}


#pragma mark - Shaking -

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self performSegueWithIdentifier:@"ShowSettingsSegue" sender:self];
    }
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
