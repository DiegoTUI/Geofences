//
//  TUIViewController.m
//  Geofencing
//
//  Created by Diego Lafuente on 23/09/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "TUIViewController.h"
#import "Constants.h"

@interface TUIViewController ()

@end

@implementation TUIViewController


#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setUserDefaultsIfNeeded];
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


#pragma mark - User defaults

- (void) setUserDefaultsIfNeeded
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![userDefaults dictionaryForKey:@"Region1"])
    {
        [userDefaults setObject:@{@"latitude": @REGION_1_LATITUDE,
                                  @"longitude": @REGION_1_LONGITUDE,
                                  @"radius": @REGION_1_RADIUS} forKey:@"Region1"];
    }
    
    if (![userDefaults dictionaryForKey:@"Region2"])
    {
        [userDefaults setObject:@{@"latitude": @REGION_2_LATITUDE,
                                  @"longitude": @REGION_2_LONGITUDE,
                                  @"radius": @REGION_2_RADIUS} forKey:@"Region2"];
    }
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
