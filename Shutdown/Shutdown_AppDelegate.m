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
@synthesize startTime;
@synthesize stopTime;
@synthesize reminderTime;

//+(void)initialize {
//    NSDictionary *defaultsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)32400], kStartTime,
//                                  [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)62400], kStopTime,
//                                  [NSNumber numberWithInt:10], kReminderTime, nil];
//    
//    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDict];
//}
-(void)readPrefs {
    CFPreferencesSynchronize((CFStringRef)HELPERAPP_BUNDLE_IDENTIFIER,
                             kCFPreferencesCurrentUser,
                             kCFPreferencesAnyHost);
    // Read from the prefs.
    CFPropertyListRef startTimeValue = CFPreferencesCopyValue((CFStringRef)kStartTime, (CFStringRef)HELPERAPP_BUNDLE_IDENTIFIER, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFPropertyListRef stopTimeValue = CFPreferencesCopyValue((CFStringRef)kStopTime, (CFStringRef)HELPERAPP_BUNDLE_IDENTIFIER, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFPropertyListRef reminderTimeValue = CFPreferencesCopyValue((CFStringRef)kReminderTime, (CFStringRef)HELPERAPP_BUNDLE_IDENTIFIER, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    [self setStartTime: (NSDate *)startTimeValue];
    [self setStopTime:  (NSDate *)stopTimeValue];
    [self setReminderTime:(NSNumber *)reminderTimeValue];
//    startTime       = (NSDate *)startTimeValue;
//    stopTime        = (NSDate *)stopTimeValue;
//    reminderTime    = (NSNumber *)reminderTimeValue;
//    [startTimeTextField      setObjectValue:startTime];
//    [stopTimeTextField       setObjectValue:stopTime];
//    [reminderTimeTextField   setObjectValue:reminderTime];
    
}

-(void)controlTextDidEndEditing:(NSNotification *)aNotification {
    [self applyPreferences];
}

-(void)applyPreferences {
    CFPreferencesSetValue((CFStringRef)kStartTime,
                          (CFStringRef)[startTimeTextField objectValue],
                          (CFStringRef)HELPERAPP_BUNDLE_IDENTIFIER,
                          kCFPreferencesCurrentUser,
                          kCFPreferencesAnyHost);
    
    CFPreferencesSetValue((CFStringRef)kStopTime,
                          (CFStringRef)[stopTimeTextField objectValue],
                          (CFStringRef)HELPERAPP_BUNDLE_IDENTIFIER,
                          kCFPreferencesCurrentUser,
                          kCFPreferencesAnyHost);
    
    CFPreferencesSetValue((CFStringRef)kReminderTime,
                          (CFStringRef)[reminderTimeTextField objectValue],
                          (CFStringRef)HELPERAPP_BUNDLE_IDENTIFIER,
                          kCFPreferencesCurrentUser,
                          kCFPreferencesAnyHost);

    CFPreferencesSynchronize((CFStringRef)HELPERAPP_BUNDLE_IDENTIFIER,
                             kCFPreferencesCurrentUser,
                             kCFPreferencesAnyHost);
    
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:PrefPanePreferencesChanged 
                                                                   object:@"PrefPane"];
}

-(IBAction)applyPreferences:(id)sender {
    // Set up the preference.
    NSLog(@"About to set the prefs.");
    CFPreferencesSetValue((CFStringRef)kStartTime,
                          (CFStringRef)[startTimeTextField objectValue],
                          (CFStringRef)HELPERAPP_BUNDLE_IDENTIFIER,
                          kCFPreferencesCurrentUser,
                          kCFPreferencesAnyHost);

    ((CFStringRef)kStopTime,
                          (CFStringRef)[stopTimeTextField objectValue],
                          (CFStringRef)HELPERAPP_BUNDLE_IDENTIFIER,
                          kCFPreferencesCurrentUser,
                          kCFPreferencesAnyHost);

    CFPreferencesSetValue((CFStringRef)kReminderTime,
                          (CFStringRef)[reminderTimeTextField objectValue],
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

}

-(void)awakeFromNib {
    helperAppController = [HelperAppController sharedInstance];
    NSDateFormatter *dateFormatter = [startTimeTextField formatter];
    NSTimeZone *timeZone = [dateFormatter timeZone];
    [[startTimeTextField formatter] setTimeZone:[NSTimeZone systemTimeZone]];
    [[stopTimeTextField formatter] setTimeZone:[NSTimeZone systemTimeZone]];
    
}

-(IBAction)startStopHelperApp:(id)sender {
    if ([self shutdownIsRunning]) {
        [self stopHelperApp];
    } else {
        [self startHelperApp];
    }
}

-(void)enableLoginItemWithURL:(NSURL *)itemURL {
    LSSharedFileListRef loginListRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    if (loginListRef) {
        // Insert the item at the bottom of Login Items list.
        LSSharedFileListItemRef loginItemRef = LSSharedFileListInsertItemURL(loginListRef, 
                                                                             kLSSharedFileListItemLast, 
                                                                             NULL, 
                                                                             NULL,
                                                                             (CFURLRef)itemURL, 
                                                                             NULL, 
                                                                             NULL);             
        if (loginItemRef) {
            CFRelease(loginItemRef);
        }
        CFRelease(loginListRef);
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

-(IBAction)shutdownComputer:(id)sender {
    [helperAppController shutdownComputer];
}

#pragma mark Text Field Delegate Methods
// Text Field Delegate Methods

-(BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    // Identify field editing based on the tag
    // Start time: 1, Stop time: 2, Reminder time: 3
    BOOL editImpliesShutdown = NO;
    BOOL newStartTimeIsOutsideLimits = NO;
    BOOL newStopTimeIsOutsideLimits = NO;
    BOOL startOrStopTimeInvalid = NO;
    
    NSDate *editedStartTime;
    NSDate *editedStopTime;
    NSNumber *editedReminderTime;
    id editor = fieldEditor;
    switch ([control tag]) {
        case 1:
            editedStartTime = [[control objectValue] convert1970RefTimeToToday];
            newStartTimeIsOutsideLimits = ([[NSDate date] timeIntervalSinceDate:editedStartTime] < 0);
            editImpliesShutdown = newStartTimeIsOutsideLimits;
            
            startOrStopTimeInvalid = ([editedStartTime timeIntervalSinceDate:[[stopTime convert1970RefTimeToToday] dateByAddingTimeInterval:-([reminderTime intValue]*60)]] > 0);
            break;
        case 2:
            editedStopTime = [[control objectValue] convert1970RefTimeToToday];
            newStopTimeIsOutsideLimits = ([[NSDate date] timeIntervalSinceDate:editedStopTime] > 0);
            editImpliesShutdown = newStopTimeIsOutsideLimits;

            startOrStopTimeInvalid = ([[startTime convert1970RefTimeToToday] timeIntervalSinceDate:[editedStopTime dateByAddingTimeInterval:-([reminderTime intValue]*60)]] > 0);
            break;
        case 3:
            editedReminderTime = [control objectValue];
            startOrStopTimeInvalid = ([[startTime convert1970RefTimeToToday] timeIntervalSinceDate:[[stopTime convert1970RefTimeToToday] dateByAddingTimeInterval:-([editedReminderTime intValue]*60)]] > 0);
            break;
        default:
            break;
    }
    
    if (startOrStopTimeInvalid) {
        // If start or stop time is invalid, display message then exit with NO.
        NSAlert *alert = [NSAlert alertWithMessageText:@"Invalid Edit" 
                                         defaultButton:@"OK" 
                                       alternateButton:nil 
                                           otherButton:nil 
                             informativeTextWithFormat:@"The start time must be earlier than the stop time - reminder time."];
        [alert runModal];
        return NO;
        
    } else if (editImpliesShutdown) {
        // If edit implies shutdown, give the user the option to continue editing, or shutdown immediately.
        NSAlert *alert = [NSAlert alertWithMessageText:@"Commit Edit?" 
                                         defaultButton:@"Continue Editing" 
                                       alternateButton:@"Shutdown Now" 
                                           otherButton:nil 
                             informativeTextWithFormat:@"The current time is outside these new limits. If you commit this change, the computer will shutdown."];
        NSInteger retValue = [alert runModal];
        if (retValue == NSAlertDefaultReturn) {
            return NO;
        } else {
            return YES;
        }
        
    } else {
        return YES;
    }
}

@end
