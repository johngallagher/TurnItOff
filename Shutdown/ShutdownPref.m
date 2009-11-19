//
//  ShutdownPref.m
//  Shutdown
//
//  Created by John Gallagher on 15/11/2009.
//  Copyright (c) 2009 Synaptic Mishap. All rights reserved.
//

#import "ShutdownPref.h"

@implementation ShutdownPref

-(void)awakeFromNib {
}

-(void)mainViewDidLoad {
    [(Shutdown_AppDelegate *)[NSApp delegate] startHelperApp];
    [(Shutdown_AppDelegate *)[NSApp delegate] readPrefs];
//    [(Shutdown_AppDelegate *)[NSApp delegate] performSelector:@selector(readPrefs) withObject:nil afterDelay:1];
//    [(Shutdown_AppDelegate *)[NSApp delegate] readPrefs];
}

@end
