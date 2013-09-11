//
//  NOImageFetcher.m
//
//  Created by Nathan Buggia on 1/16/11.
//  Copyright 2011 netorion.com. All rights reserved.
//

#import "NOImageFetcher.h"

@implementation NOImageFetcher


#pragma mark -
#pragma mark Instance methods


- (id)initWithImageUrl:(NSURL *)url targetObject:(id)tarObject targetMethod:(SEL)tarMethod
{
	if(self = [super init])
	{
		imageUrl = [url retain];
		targetObject = tarObject;
		targetMethod = tarMethod;
	}
	
	return self;
}


- (void)dealloc
{
	[imageUrl release];
	[super dealloc];
}


- (void)main
{
	NSAutoreleasePool *imageFetcherPool;
	
	@try 
	{
		imageFetcherPool = [[NSAutoreleasePool alloc] init];
		
		if([self isCancelled])
			return;
		
		NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
		UIImage *image = [[UIImage alloc] initWithData:imageData];
		
		NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys: image, @"image", imageUrl, @"url", nil];
		
		[targetObject performSelectorOnMainThread:targetMethod withObject:result waitUntilDone:NO];
		
		[imageData release];
		[image release];
		[result release];
	}
	@catch (NSException *e) 
	{
		NSLog(@"Error: %@", [e reason]);
	}
	@finally 
	{
		[imageFetcherPool release];
	}
}


@end

