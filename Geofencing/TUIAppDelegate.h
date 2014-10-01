//
//  TUIAppDelegate.h
//  Geofencing
//
//  Created by Diego Lafuente on 23/09/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TUIAppNotificationDelegate;

@interface TUIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic) id<TUIAppNotificationDelegate> delegate;

@end

@protocol TUIAppNotificationDelegate <NSObject>

- (void)receivedNotificationInRegion:(NSString *)regionIdentifier;

- (void)didEnterBackground;

- (void)didEnterForeground;

@end
