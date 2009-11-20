#include <netinet/in.h>
#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>

#include <CoreServices/CoreServices.h>

#include "BetterAuthorizationSampleLib.h"

#include "SampleCommon.h"

static OSStatus DoShutdown(
                          AuthorizationRef			auth,
                          const void *                userData,
                          CFDictionaryRef				request,
                          CFMutableDictionaryRef      response,
                          aslclient                   asl,
                          aslmsg                      aslMsg
                          )
// Implements the Shutdown.
{	
	OSStatus					retval = noErr;
	
    const char                  *shutdownCommand = "/opt/local/sbin/shutdown.sh";
    
	assert(auth != NULL);
    // userData may be NULL
	assert(request != NULL);
	assert(response != NULL);
    // asl may be NULL
    // aslMsg may be NULL
	
    system(shutdownCommand);
    
	return retval;
}

/////////////////////////////////////////////////////////////////
#pragma mark ***** Tool Infrastructure

/*
    IMPORTANT
    ---------
    This array must be exactly parallel to the kSampleCommandSet array 
    in "SampleCommon.c".
*/

static const BASCommandProc kSampleCommandProcs[] = {
    DoShutdown,
    NULL
};

int main(int argc, char **argv)
{
    // Go directly into BetterAuthorizationSampleLib code.
	
    // IMPORTANT
    // BASHelperToolMain doesn't clean up after itself, so once it returns 
    // we must quit.
    
	return BASHelperToolMain(kSampleCommandSet, kSampleCommandProcs);
}
