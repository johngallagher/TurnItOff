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
    
    IBOutlet        NSTextField         *startTime;
    IBOutlet        NSTextField         *stopTime;
    IBOutlet        NSTextField         *reminderTime;
    
    IBOutlet        NSUserDefaultsController    *userDefaultsController;
    HelperAppController                 *helperAppController;
}

@property (assign) BOOL shutdownIsRunning;

-(void)readPrefs;

-(void)controlTextDidEndEditing:(NSNotification *)aNotification;

-(void)applyPreferences;

-(void)startHelperApp;

-(void)stopHelperApp;

-(void)preferencesChanged:(NSNotification *)notification;

-(IBAction)startStopHelperApp:(id)sender;

-(IBAction)applyPreferences:(id)sender;

-(IBAction)shutdownComputer:(id)sender;
@end
