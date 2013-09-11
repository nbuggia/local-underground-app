//
//  ImageFetcher.h
//  WhatsUp
//
//  Created by Nathan Buggia on 1/16/11.
//  Copyright 2011 netorion.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NOImageFetcher : NSOperation 
{
	NSURL *imageUrl;
	id targetObject;
	SEL targetMethod;
}

- (id)initWithImageUrl:(NSURL*)url targetObject:(id)tarObject targetMethod:(SEL)tarMethod;

@end

