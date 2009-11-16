//
//  ShutdownPref.h
//  Shutdown
//
//  Created by John Gallagher on 15/11/2009.
//  Copyright (c) 2009 Synaptic Mishap. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>


@interface ShutdownPref : NSPreferencePane {
    BOOL shutdownIsRunning;
}

-(void)mainViewDidLoad;

@end
