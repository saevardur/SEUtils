//
//  NSArray+Helpers.m
//  valderama
//
//  Created by Sævarður Einarsson on 6/11/12.
//  Copyright (c) 2012 Stokkur Mobile Software ehf. All rights reserved.
//

#import "NSArray+Helpers.h"

@implementation NSArray (Helpers)

- (NSArray *) shuffled
{
	// create temporary autoreleased mutable array
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[self count]];
    
	for (id anObject in self)
	{
		NSUInteger randomPos = arc4random()%([tmpArray count]+1);
		[tmpArray insertObject:anObject atIndex:randomPos];
	}
    
	return [NSArray arrayWithArray:tmpArray];  // non-mutable autoreleased copy
}

@end
