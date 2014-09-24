//
//  TUISettingsViewController.m
//  Geofencing
//
//  Created by Diego Lafuente on 23/09/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "TUISettingsViewController.h"

@interface TUISettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *region1LatitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *region1LongitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *region1RadiusTextField;

@property (weak, nonatomic) IBOutlet UITextField *region2LatitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *region2LongitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *region2RadiusTextField;


- (IBAction)doneButtonClicked:(id)sender;


@end

@implementation TUISettingsViewController

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/


#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTextFieldsWithStoredValues];
}


- (void) initTextFieldsWithStoredValues
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *region1 = [userDefaults dictionaryForKey:@"Region1"];
    if (region1)
    {
        _region1LatitudeTextField.text = [(NSNumber *)region1[@"latitude"] stringValue];
        _region1LongitudeTextField.text = [(NSNumber *)region1[@"longitude"] stringValue];
        _region1RadiusTextField.text = [(NSNumber *)region1[@"radius"] stringValue];
    }
    
    NSDictionary *region2 = [userDefaults dictionaryForKey:@"Region2"];
    if (region2)
    {
        _region2LatitudeTextField.text = [(NSNumber *)region2[@"latitude"] stringValue];
        _region2LongitudeTextField.text = [(NSNumber *)region2[@"longitude"] stringValue];
        _region2RadiusTextField.text = [(NSNumber *)region2[@"radius"] stringValue];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Buttons clicked

- (IBAction)doneButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
