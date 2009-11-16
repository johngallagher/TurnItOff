//
//  HelperApp_AppDelegate.m
//  Shutdown
//
//  Created by John Gallagher on 16/11/2009.
//  Copyright 2009 Synaptic Mishap. All rights reserved.
//

#import "HelperApp_AppDelegate.h"


@implementation HelperApp_AppDelegate

-(void)awakeFromNib {
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
    //    Debugger();
    NSLog(@"Prefs changed. From helper app.");
    NSLog(@"Start Time: %@",[[note userInfo] objectForKey:kStartTime]);
    NSLog(@"Stop Time: %@",[[note userInfo] objectForKey:kStopTime]);
    NSLog(@"Reminder Time: %d",[[[note userInfo] objectForKey:kReminderTime] intValue]);
}

-(void)shutdown:(NSNotification *)note {
#pragma unused(note)
    NSLog(@"Shutdown message recieved. From helper app. Shutting down.");
	[NSApp terminate:nil];
}

@end
