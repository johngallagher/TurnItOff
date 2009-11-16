//
//  HelperApp.h
//  Shutdown
//
//  Created by John Gallagher on 15/11/2009.
//  Copyright 2009 Synaptic Mishap. All rights reserved.
//

@interface HelperAppController : AbstractSingletonObject {

}
-(void)awakeFromNib;

-(void)startHelperApp:(NSError **)error;

-(void)stopHelperApp:(NSError **)error;

-(void)preferencesChangedTo:(NSDictionary *)preferencesDict error:(NSError **)error;

-(BOOL)isHelperAppRunning;

-(BOOL)isRunning:(NSString *)theBundleIdentifier;

-(void)launchHelperApp;

-(void)terminateHelperApp;


@end
