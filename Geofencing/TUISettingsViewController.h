//
//  TUISettingsViewController.h
//  Geofencing
//
//  Created by Diego Lafuente on 23/09/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import <UIKit/UIKit.h>

// Forward declarations
@protocol TUIModalViewControllerDelegate;

@interface TUISettingsViewController : UIViewController

@property (nonatomic, weak) id<TUIModalViewControllerDelegate> delegate;

@end

@protocol TUIModalViewControllerDelegate <NSObject>

- (void)modalViewAboutToBeDismissed;

@end
