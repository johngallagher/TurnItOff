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
    // Launch the helper app if it's not already running.
    if ([self isHelperAppRunning]) {
        NSLog(@"Helper app is already running.");
    } else {
        NSLog(@"Started Helper App");
        [self launchHelperApp];
    }

}

-(void)stopHelperApp:(NSError **)error {
    // Send the helper app a signal to terminate if it's running.
    if ([self isHelperAppRunning]) {
        NSLog(@"Stop Helper app");
        [self terminateHelperApp];
    } else {
        NSLog(@"Helper app is not running. Nothing to terminate.");
    }
}

-(void)preferencesChangedTo:(NSDictionary *)preferencesDict error:(NSError **)error {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:PrefPanePreferencesChanged 
                                                                   object:@"PrefPane"];
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
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:Terminate_Helper_App 
                                                                   object:@"PrefPane"];
}
-(void)shutdownComputer {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:Shutdown_Computer 
                                                                   object:@"PrefPane"];
}
@end
