
/////////////////////////////////////////////////////////////////
#pragma mark ***** Globals

static AuthorizationRef gAuth;

/////////////////////////////////////////////////////////////////
#pragma mark ***** Objective-C Wrapper

// Our trivial application object, SampleApp, is instantiated by our nib.  It 
// has four actions, three for the buttons and one for the Destroy Rights menu item. 
// It has a two outlets, one pointing to the text view where we log our results 
// and the other referencing the "Force failure" checkbox.

@interface ShutdownHelperTool : NSObject {
}

//- (IBAction)doGetVersion:(id)sender;
//- (IBAction)doGetUIDs:(id)sender;
//- (IBAction)doLowNumberedPorts:(id)sender;
//- (IBAction)doShutdown:(id)sender;
//- (IBAction)destroyRights:(id)sender;

@end