//
//  Shutdown_AppDelegate.h
//  Shutdown
//
//  Created by John Gallagher on 16/11/2009.
//  Copyright 2009 Synaptic Mishap. All rights reserved.
//

@interface Shutdown_AppDelegate : NSObject {
    BOOL            shutdownIsRunning;
    IBOutlet        NSTextField         *shutdownStatusText;
    IBOutlet        NSButton            *shutdownControlButton;
    IBOutlet        NSButton            *applyChangesButton;
    
    IBOutlet        NSTextField         *startTimeTextField;
    IBOutlet        NSTextField         *stopTimeTextField;
    IBOutlet        NSTextField         *reminderTimeTextField;
    
    IBOutlet        NSUserDefaultsController    *userDefaultsController;
    HelperAppController                 *helperAppController;
    
    NSDate      *startTime   ;
    NSDate      *stopTime    ;
    NSNumber    *reminderTime;
    
}

@property (assign) BOOL shutdownIsRunning;
@property (assign) NSDate *startTime;
@property (assign) NSDate *stopTime;
@property (assign) NSNumber *reminderTime;

-(void)readPrefs;

-(void)controlTextDidEndEditing:(NSNotification *)aNotification;

-(void)applyPreferences;

-(void)startHelperApp;

-(void)stopHelperApp;

-(void)preferencesChanged:(NSNotification *)notification;

-(IBAction)startStopHelperApp:(id)sender;

-(IBAction)applyPreferences:(id)sender;

-(IBAction)shutdownComputer:(id)sender;

-(BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor;
@end
