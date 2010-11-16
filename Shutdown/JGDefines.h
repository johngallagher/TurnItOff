/*
 *  JGDefines.h
 *  SysPrefPane
 *
 *  Created by John Gallagher on 10/11/2009.
 *  Copyright 2009 Synaptic Mishap. All rights reserved.
 *
 */

#ifdef __OBJC__
#define XSTR(x) (@x)
#else
#define XSTR CFSTR
#endif

#define PrefPanePreferencesChanged              XSTR("PrefPanePreferencesChanged")
#define Terminate_Helper_App                    XSTR("TerminateHelperApp")
#define Shutdown_Computer                       XSTR("ShutdownComputer")
#define DisablePrefPaneControls                 XSTR("DisablePrefPaneControls")

#define HELPERAPP_BUNDLE_IDENTIFIER             XSTR("com.synapticmishap.shutdown.HelperApp")
#define PREFPANE_BUNDLE_IDENTIFIER              XSTR("com.synapticmishap.shutdown.SysPrefPane")
