//
//  SampleApp2.m
//  BetterAuthorizationSample
//
//  Created by John Gallagher on 19/11/2009.
//  Copyright 2009 Synaptic Mishap. All rights reserved.
//

#import "ShutdownHelperToolExecutor.h"

@implementation ShutdownHelperToolExecutor

-(IBAction)testQuitOtherApps:(id)sender {
    [self quitOtherApps];
}

-(void)quitOtherApps {
    NSDictionary *error = [NSDictionary dictionary];
    NSURL *scriptURL = [[NSBundle mainBundle] URLForResource:@"QuitAllApps" withExtension:@"scpt"];
    NSAppleScript *quitAllAppsScript = [[NSAppleScript alloc] initWithContentsOfURL:scriptURL error:&error];
    [quitAllAppsScript executeAndReturnError:&error];
    if (error) {
        NSLog(@"Couldn't quit other apps due to applesript error %@", error);
    }
}

-(void)doShutdown {
    OSStatus        err;
    BASFailCode     failCode;
    NSString *      bundleID;
    NSDictionary *  request;
    CFDictionaryRef response;
    
    response = NULL;
    
    // Create our request.  Note that NSDictionary is toll-free bridged to CFDictionary, so 
    // we can use an NSDictionary as our request.
    
    request = [NSDictionary dictionaryWithObjectsAndKeys:@kShutdownCommand, @kBASCommandKey, nil];
    assert(request != NULL);
    
    bundleID = [[NSBundle mainBundle] bundleIdentifier];
    assert(bundleID != NULL);
    
    // Execute it.
    
	err = BASExecuteRequestInHelperTool(
                                        gAuth, 
                                        kSampleCommandSet, 
                                        (CFStringRef) bundleID, 
                                        (CFDictionaryRef) request, 
                                        &response
                                        );
    
    // If it failed, try to recover.
    
    if ( (err != noErr) && (err != userCanceledErr) ) {
        int alertResult;
        
        failCode = BASDiagnoseFailure(gAuth, (CFStringRef) bundleID);
        
        // At this point we tell the user that something has gone wrong and that we need 
        // to authorize in order to fix it.  Ideally we'd use failCode to describe the type of 
        // error to the user.
        
        alertResult = NSRunAlertPanel(@"Needs Install", @"BAS needs to install", @"Install", @"Cancel", NULL);
        
        if ( alertResult == NSAlertDefaultReturn ) {
            // Try to fix things.
            
            err = BASFixFailure(gAuth, (CFStringRef) bundleID, CFSTR("InstallTool"), CFSTR("HelperTool"), failCode);
            
            // If the fix went OK, retry the request.
            
            if (err == noErr) {
                err = BASExecuteRequestInHelperTool(
                                                    gAuth, 
                                                    kSampleCommandSet, 
                                                    (CFStringRef) bundleID, 
                                                    (CFDictionaryRef) request, 
                                                    &response
                                                    );
            }
        } else {
            err = userCanceledErr;
        }
    }
    
    // If all of the above went OK, it means that the IPC to the helper tool worked.  We 
    // now have to check the response dictionary to see if the command's execution within 
    // the helper tool was successful.
    
    if (err == noErr) {
        err = BASGetErrorFromResponse(response);
    }
    
    // Log our results.
    
    if (response != NULL) {
        CFRelease(response);
    }
}


@end

int main(int argc, char *argv[]) {
    OSStatus    junk;
    
    // Create the AuthorizationRef that we'll use through this application.  We ignore 
    // any error from this.  A failure from AuthorizationCreate is very unusual, and if it 
    // happens there's no way to recover; Authorization Services just won't work.
    
    junk = AuthorizationCreate(NULL, NULL, kAuthorizationFlagDefaults, &gAuth);
    assert(junk == noErr);
    assert( (junk == noErr) == (gAuth != NULL) );
    
	// For each of our commands, check to see if a right specification exists and, if not,
    // create it.
    //
    // The last parameter is the name of a ".strings" file that contains the localised prompts 
    // for any custom rights that we use.
    
	BASSetDefaultRules(
                       gAuth, 
                       kSampleCommandSet, 
                       CFBundleGetIdentifier(CFBundleGetMainBundle()), 
                       CFSTR("SampleAuthorizationPrompts")
                       );
    
    // And now, the miracle that is Cocoa...
    
    return NSApplicationMain(argc,  (const char **) argv);
}
