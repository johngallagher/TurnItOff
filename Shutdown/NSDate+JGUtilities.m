//
//  JGDateHelper.m
//  Shutdown
//
//  Created by John Gallagher on 23/11/2009.
//  Copyright 2009 Synaptic Mishap. All rights reserved.
//

#import "NSDate+JGUtilities.h"

@implementation NSDate (JGUtilities)
    
-(NSDate *)convert1970RefTimeToToday {
    NSTimeInterval intervalOffset = [self timeIntervalSince1970];
    
    // Since the 1970 reference is +1 for daylight saving, add 1 hour
    intervalOffset = intervalOffset   + 3600;
    
    // Calculate midnight today.
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *midnightTodayComponents = [gregorian components:unitFlags fromDate:date];
    
    NSDate *midnightTodaysDate = [gregorian dateFromComponents:midnightTodayComponents];
    
    // Add seconds since ref date onto midnight today so we've got the time today.
    return [midnightTodaysDate dateByAddingTimeInterval:intervalOffset];
}

@end
