//#include <unistd.h>
//#include <netinet/in.h>
//
//#include "BetterAuthorizationSampleLib.h"

#include "SampleCommon.h"

/////////////////////////////////////////////////////////////////
#pragma mark ***** Globals

static AuthorizationRef gAuth;

/////////////////////////////////////////////////////////////////
#pragma mark ***** Objective-C Wrapper

// Our trivial application object, SampleApp, is instantiated by our nib.  It 
// has four actions, three for the buttons and one for the Destroy Rights menu item. 
// It has a two outlets, one pointing to the text view where we log our results 
// and the other referencing the "Force failure" checkbox.

@interface ShutdownHelperToolExecutor : NSObject {
}

-(void)quitOtherApps;

-(IBAction)testQuitOtherApps:(id)sender;


-(IBAction)testShutdown:(id)sender;


-(void)doShutdown;

@end