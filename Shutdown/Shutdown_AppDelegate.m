//
//  Shutdown_AppDelegate.m
//  Shutdown
//
//  Created by John Gallagher on 16/11/2009.
//  Copyright 2009 Synaptic Mishap. All rights reserved.
//

#import "Shutdown_AppDelegate.h"


@implementation Shutdown_AppDelegate

@synthesize shutdownIsRunning;
+(void)initialize {
    NSDictionary *defaultsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)32400], kStartTime,
                                  [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)62400], kStopTime,
                                  [NSNumber numberWithInt:10], kReminderTime, nil];
    [[[NSUserDefaultsController sharedUserDefaultsController] defaults] registerDefaults:defaultsDict];
    
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defaultsDict];
}

-(void)awakeFromNib {

    helperAppController = [HelperAppController sharedInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferencesChanged:)
                                                 name:NSUserDefaultsDidChangeNotification 
                                               object:nil];
    [self startHelperApp];
}

-(void)applicationDidFinishLaunching:(NSNotification *)notification {
}

-(IBAction)startStopHelperApp:(id)sender {
    if ([self shutdownIsRunning]) {
        [self stopHelperApp];
    } else {
        [self startHelperApp];
    }
}

-(void)startHelperApp {
    NSError                 *startupError = nil;
    
    [shutdownControlButton setEnabled:NO];
    [helperAppController startHelperApp:&startupError];

    if(startupError == nil) {
        [self setShutdownIsRunning:YES];
        [shutdownStatusText setStringValue:@"Shutdown is running"];
        [shutdownControlButton setTitle:@"Stop Shutdown"];
    } else {
        NSLog(@"Error starting Helper App");
    }
    [shutdownControlButton setEnabled:YES];
}

-(void)stopHelperApp {
    NSError                 *stopError = nil;
    
    [shutdownControlButton setEnabled:NO];
    [helperAppController stopHelperApp:&stopError];
    if(stopError == nil) {
        [self setShutdownIsRunning:NO];
        [shutdownStatusText setStringValue:@"Shutdown is not running"];
        [shutdownControlButton setTitle:@"Start Shutdown"];
    } else {
        NSLog(@"Error stopping Helper App.");
    }
    [shutdownControlButton setEnabled:YES];
    
}

-(void)preferencesChanged:(NSNotification *)notification {
    if ([[notification object] isEqual:[[NSUserDefaultsController sharedUserDefaultsController] defaults]]) {
        NSError         *tellError = nil;
        // Show error message if the time is before start time or after stop time.
        // Spending far too much time on this. Do it later!
//        NSDate *startTimeDate = [[[NSUserDefaultsController sharedUserDefaultsController] defaults] objectForKey:kStartTime];
//        NSDate *stopTimeDate = [[[NSUserDefaultsController sharedUserDefaultsController] defaults] objectForKey:kStopTime];
//        NSTimeInterval *startTimeInterval = [startTimeDate timeIntervalSince1970];
//        
//        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        // Get the hour and minute 
//        
//        if ([[NSDate date]  ] || [stopTimeDate isLessThan:[NSDate date]] ) {
//        }
//        
        NSDictionary    *preferencesDict = [[[NSUserDefaultsController sharedUserDefaultsController] defaults] dictionaryRepresentation];
        [helperAppController preferencesChangedTo:preferencesDict error:&tellError];
    }
    NSLog(@"Prefs changed.");
}

@end
