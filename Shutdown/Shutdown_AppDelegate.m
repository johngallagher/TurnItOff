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

//+(void)initialize {
//    NSDictionary *defaultsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)32400], kStartTime,
//                                  [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)62400], kStopTime,
//                                  [NSNumber numberWithInt:10], kReminderTime, nil];
//    
//    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDict];
//}

-(IBAction)applyPreferences:(id)sender {
    // Set up the preference.
    NSLog(@"About to set the prefs.");
    CFPreferencesSetValue((CFStringRef)kStartTime,
                          (CFStringRef)[startTime objectValue],
                          (CFStringRef)HELPERAPP_BUNDLE_IDENTIFIER,
                          kCFPreferencesCurrentUser,
                          kCFPreferencesAnyHost);
    
    // Write out the preference data.
    CFPreferencesSynchronize((CFStringRef)HELPERAPP_BUNDLE_IDENTIFIER,
                             kCFPreferencesCurrentUser,
                             kCFPreferencesAnyHost);
    
    NSLog(@"Just synced the prefs data. Sending notification.");
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:PrefPanePreferencesChanged 
                                                                   object:@"PrefPane"];
//    [helperAppController preferencesChangedTo:nil error:&tellError];

}

-(void)awakeFromNib {
    
    helperAppController = [HelperAppController sharedInstance];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(preferencesChanged:)
//                                                 name:NSUserDefaultsDidChangeNotification 
//                                               object:nil];
    
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
    if ([[notification object] isEqual:[NSUserDefaults standardUserDefaults]]) {
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSError         *tellError = nil;
        [helperAppController preferencesChangedTo:nil error:&tellError];
    }
    NSLog(@"Prefs changed.");
}

@end
