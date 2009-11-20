//
//  HelperApp_AppDelegate.h
//  Shutdown
//
//  Created by John Gallagher on 16/11/2009.
//  Copyright 2009 Synaptic Mishap. All rights reserved.
//

#import "ShutdownHelperToolExecutor.h"

@interface HelperApp_AppDelegate : NSObject {
    NSUserDefaults      *userDefaults;
    NSDate      *startTime   ;
    NSDate      *stopTime    ;
    NSNumber    *reminderTime;
    
    NSDate      *startTimeToday;
    NSDate      *stopTimeToday;
    NSDate      *reminderTimeToday;
    
    NSTimer     *shutdownTimer;
    NSTimer     *warnBeforeShutdownTimer;
}
+(void)initialize;

-(void)convertShutdownTimesToToday;

-(void)applicationDidFinishLaunching:(NSNotification *)note;

-(void)preferencesChanged:(NSNotification *)note;

-(void)terminateHelperApp:(NSNotification *)note;

-(IBAction)shutdownComputerTestAction:(id)sender;

-(void)warnBeforeShutdown:(NSTimer *)theTimer;

-(void)shutdownComputer:(NSTimer *)theTimer;


@end
