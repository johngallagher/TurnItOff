//
//  HelperApp_AppDelegate.m
//  Shutdown
//
//  Created by John Gallagher on 16/11/2009.
//  Copyright 2009 Synaptic Mishap. All rights reserved.
//

#import "HelperApp_AppDelegate.h"

@class ShutdownHelperToolExecutor;

@implementation HelperApp_AppDelegate

+(void)initialize {
//    
    NSDictionary *defaultsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)32400], kStartTime,
                                  [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)62400], kStopTime,
                                  [NSNumber numberWithInt:10], kReminderTime, nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDict];
}

-(void)convertShutdownTimesToToday {
    // Start and stop dates are just times taken with respect to the 1970 reference date. We need to convert that into a time today.
    // Get seconds since ref date
      NSTimeInterval startTimeIntervalOffset = [startTime timeIntervalSince1970];
    NSTimeInterval stopTimeIntervalOffset = [stopTime timeIntervalSince1970];

    // Calculate midnight today.
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *midnightTodayComponents = [gregorian components:unitFlags fromDate:date];

    NSDate *midnightTodayDate = [gregorian dateFromComponents:midnightTodayComponents];
    
    // Add seconds since ref date onto midnight today so we've got the start stop time today.
    startTimeToday      = [midnightTodayDate dateByAddingTimeInterval:startTimeIntervalOffset];
    stopTimeToday       = [midnightTodayDate dateByAddingTimeInterval:stopTimeIntervalOffset];
    
    // Work out the time we need to fire the reminder.
    int                 reminderSecondsBeforeShutdown = 0 - ([reminderTime intValue] * 60);
    NSTimeInterval      reminderTimeIntervalBeforeShutdown = (NSTimeInterval)reminderSecondsBeforeShutdown;
    
    reminderTimeToday   = [stopTimeToday  dateByAddingTimeInterval:reminderTimeIntervalBeforeShutdown];

}

-(void)installShutdownTimer {
    // Start time should be before the reminder time. If not, something's gone wrong.
    NSAssert([reminderTimeToday timeIntervalSinceDate:startTimeToday] > 0, @"Start time should be before reminder time.");
    // Should we be able to use our computer now? 
    BOOL timeIsAfterStart = ([[NSDate date] timeIntervalSinceDate:startTimeToday] > 0);
    BOOL timeIsBeforeStop = ([[NSDate date] timeIntervalSinceDate:stopTimeToday] < 0);

    BOOL currentTimeIsLegal = (timeIsAfterStart && timeIsBeforeStop);
    if (currentTimeIsLegal) {
        // If so, setup the timers to warn and shutdown the computer.
        // Setup timers for shutdown
        warnBeforeShutdownTimer     = [[NSTimer alloc] initWithFireDate:reminderTimeToday interval:0 target:self selector:@selector(warnBeforeShutdown:) userInfo:nil repeats:NO];
        shutdownTimer               = [[NSTimer alloc] initWithFireDate:stopTimeToday interval:0 target:self selector:@selector(shutdownComputer:) userInfo:nil repeats:NO];
    } else {
        // If not, tell the user then shutdown the computer immediately.
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert setMessageText:@"Shutdown."];
        [alert addButtonWithTitle:@"OK"];
        [alert setInformativeText:@"You can't log in now. The computer will shut down immediately."];
        
        [NSApp activateIgnoringOtherApps:YES];
        
        NSInteger returnValue = [alert runModal];
        [self shutdownComputer:nil];
    }

}

-(void)updateShutdownTimes {
    // Get current prefs
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    startTime      = [[NSUserDefaults standardUserDefaults] objectForKey:kStartTime];
    stopTime       = [[NSUserDefaults standardUserDefaults] objectForKey:kStopTime];
    reminderTime   = [[NSUserDefaults standardUserDefaults] objectForKey:kReminderTime];
    
    // Calculate shutdown dates
    [self convertShutdownTimesToToday];
        
    [self installShutdownTimer];
}

-(void)applicationDidFinishLaunching:(NSNotification *)note {
    // Register for distributed notifications
    NSDistributedNotificationCenter *NSDNC = [NSDistributedNotificationCenter defaultCenter];
    
    [NSDNC addObserver:self
              selector:@selector(preferencesChanged:)
                  name:PrefPanePreferencesChanged
                object:nil];
    [NSDNC addObserver:self
              selector:@selector(terminateHelperApp:)
                  name:Terminate_Helper_App
                object:nil];
    [NSDNC addObserver:self
              selector:@selector(shutdownComputer:)
                  name:Shutdown_Computer
                object:nil];
    
    [self updateShutdownTimes];
}

-(void)preferencesChanged:(NSNotification *)note {
    NSLog(@"Prefs changed. From helper app.");
    // We've changed startup/shutdown times so update the NSTimers and shutdown if needed.
    [self updateShutdownTimes];

    //   [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    startTime      = [[NSUserDefaults standardUserDefaults] objectForKey:kStartTime];
//    stopTime       = [[NSUserDefaults standardUserDefaults] objectForKey:kStopTime];
//    reminderTime   = [[NSUserDefaults standardUserDefaults] objectForKey:kReminderTime];

//    NSLog(@"Start Time: %@",    startTime);
//    NSLog(@"Stop Time: %@",     stopTime);
//    NSLog(@"Reminder Time: %d", [reminderTime intValue]);
}

-(void)terminateHelperApp:(NSNotification *)note {
#pragma unused(note)
    NSLog(@"Shutdown message recieved. From helper app. Shutting down.");
	[NSApp terminate:nil];
}

-(IBAction)shutdownComputerTestAction:(id)sender {
    [self shutdownComputer:nil];
}

-(void)warnBeforeShutdown:(NSTimer *)theTimer {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert setMessageText:@"Shutdown."];
    [alert addButtonWithTitle:@"OK"];
    [alert setInformativeText:[NSString stringWithFormat:@"The computer will shut down in %d minutes. Please save your work.", [reminderTime intValue]]];
    
    [NSApp activateIgnoringOtherApps:YES];
    
    NSInteger returnValue = [alert runModal];
}

-(void)shutdownComputer:(NSTimer *)theTimer {
    NSLog(@"Shutting down the computer...");
    //    ShutdownHelperToolExecutor *helperTool = [[ShutdownHelperToolExecutor alloc] init];
    //    [helperTool doShutdown];
}

@end
