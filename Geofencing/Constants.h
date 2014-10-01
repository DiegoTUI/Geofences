//
//  Constants.h
//  Geofencing
//
//  Created by Diego Lafuente on 23/09/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// Defaukt values for latitude, longitude and radius
#define REGION_1_LATITUDE           39.543497
#define REGION_1_LONGITUDE          2.715863
#define REGION_1_RADIUS             10.0
#define REGION_1_IDENTIFIER         @"region1"
#define REGION_2_LATITUDE           39.543542
#define REGION_2_LONGITUDE          2.716512
#define REGION_2_RADIUS             10.0
#define REGION_2_IDENTIFIER         @"region2"