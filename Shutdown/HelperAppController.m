//
//  HelperApp.m
//  Shutdown
//
//  Created by John Gallagher on 15/11/2009.
//  Copyright 2009 Synaptic Mishap. All rights reserved.
//

#import "HelperAppController.h"


@implementation HelperAppController
-(void)awakeFromNib {
    
}

-(void)startHelperApp:(NSError **)error {
    // Launch the helper app
    
    // Check to see if it's running a couple of seconds later.
    
    // If it's not running, try launching the app again.
    
    // Check a couple more seconds later to see if it's running.
    
    // If it's still not running, log an error and return.
    if ([self isHelperAppRunning]) {
        NSLog(@"Helper app is already running.");
    } else {
        NSLog(@"Started Helper App");
        [self launchHelperApp];
    }

}

-(void)stopHelperApp:(NSError **)error {
    // Send the helper app a signal to terminate
    
    // Check to see if it's running a couple of seconds later.
    
    // If it's still running, resend the message.
    
    // Check a couple more seconds later to see if it's running.
    
    // If it's still running, log an error and return.
    if ([self isHelperAppRunning]) {
        NSLog(@"Stop Helper app");
        [self terminateHelperApp];
    } else {
        NSLog(@"Helper app is not running. Nothing to terminate.");
    }
}

-(void)preferencesChangedTo:(NSDictionary *)preferencesDict error:(NSError **)error {
    // send message to the helper app with the updated preferences
    
    // ask the helper app to echo back the new preferences
    
    // If prefs are incorrect, or we get no reply in a second, repeat the message.
    
    // If the message has been sent a second time without any reply or the incorrect reply, log an error.
    NSLog(@"Prefs changed to: %@", preferencesDict);

//    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:PrefPanePreferencesChanged 
//                                                                   object:@"PrefPane"];
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:PrefPanePreferencesChanged 
                                                                   object:@"PrefPane" 
                                                                 userInfo:preferencesDict];
}

-(BOOL)isHelperAppRunning {
    return [self isRunning:HELPERAPP_BUNDLE_IDENTIFIER];
}

-(BOOL)isRunning:(NSString *)theBundleIdentifier {
    BOOL isRunning = NO;
	ProcessSerialNumber PSN = { kNoProcess, kNoProcess };
    
	while (GetNextProcess(&PSN) == noErr) {
		NSDictionary *infoDict = (NSDictionary *)ProcessInformationCopyDictionary(&PSN, kProcessDictionaryIncludeAllInformationMask);
		if(infoDict) {
			NSString *bundleID = [infoDict objectForKey:(NSString *)kCFBundleIdentifierKey];
			isRunning = bundleID && [bundleID isEqualToString:theBundleIdentifier];
			CFMakeCollectable(infoDict);
			[infoDict release];
		}
		if (isRunning)
			break;
	}
    
	return isRunning;
}


-(void)launchHelperApp {
    NSString *helperAppPath = [[NSBundle bundleWithIdentifier:@"com.synapticmishap.shutdown"] pathForResource:@"ShutdownHelperApp" ofType:@"app"];
	NSURL *helperURL = [NSURL fileURLWithPath:helperAppPath];
    
	unsigned options = NSWorkspaceLaunchWithoutAddingToRecents | NSWorkspaceLaunchWithoutActivation | NSWorkspaceLaunchAsync;
    
    
	[[NSWorkspace sharedWorkspace] openURLs:[NSArray arrayWithObject:helperURL]
	                withAppBundleIdentifier:nil
	                                options:options
	         additionalEventParamDescriptor:nil
	                      launchIdentifiers:NULL];
}

-(void)terminateHelperApp {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:HELPERAPP_SHUTDOWN 
                                                                   object:@"PrefPane"];
    
}
@end
