//
//  HelperApp_AppDelegate.m
//  Shutdown
//
//  Created by John Gallagher on 16/11/2009.
//  Copyright 2009 Synaptic Mishap. All rights reserved.
//

#import "HelperApp_AppDelegate.h"


@implementation HelperApp_AppDelegate

+(void)initialize {
//    
    NSDictionary *defaultsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)32400], kStartTime,
                                  [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)62400], kStopTime,
                                  [NSNumber numberWithInt:10], kReminderTime, nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDict];
}

-(void)applicationDidFinishLaunching:(NSNotification *)note {
    NSDistributedNotificationCenter *NSDNC = [NSDistributedNotificationCenter defaultCenter];
    
    [NSDNC addObserver:self
              selector:@selector(preferencesChanged:)
                  name:PrefPanePreferencesChanged
                object:nil];
    [NSDNC addObserver:self
              selector:@selector(shutdown:)
                  name:HELPERAPP_SHUTDOWN
                object:nil];
}

-(void)preferencesChanged:(NSNotification *)note {
    NSLog(@"Prefs changed. From helper app.");
   [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDate      *startTime      = [[NSUserDefaults standardUserDefaults] objectForKey:kStartTime];
    NSDate      *stopTime       = [[NSUserDefaults standardUserDefaults] objectForKey:kStopTime];
    NSNumber    *reminderTime   = [[NSUserDefaults standardUserDefaults] objectForKey:kReminderTime];
    NSLog(@"Start Time: %@",    startTime);
    NSLog(@"Stop Time: %@",     stopTime);
    NSLog(@"Reminder Time: %d", [reminderTime intValue]);
}

-(void)shutdown:(NSNotification *)note {
#pragma unused(note)
    NSLog(@"Shutdown message recieved. From helper app. Shutting down.");
	[NSApp terminate:nil];
}

@end
