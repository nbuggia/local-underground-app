//
//  CuratedAccountsProvider.m
//  WhatsUp
//
//  Created by Nathan Buggia on 2/5/11.
//  Copyright 2011 NetOrion.com. All rights reserved.
//

#import "CuratedAccountsProvider.h"


@implementation CuratedAccountsProvider

@synthesize latitude;
@synthesize longitude;

- (id)initWithLatitude:(double)lat longitude:(double)lon targetObject:(id)tarObject targetMethod:(SEL)tarMethod
{
	if(self = [super init])
	{
		latitude = lat;
		longitude = lon;
		targetObject = tarObject;
		targetMethod = tarMethod;
	}
	
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)main
{
	NSAutoreleasePool *fetcherPool;
	
	@try 
	{
		fetcherPool = [[NSAutoreleasePool alloc] init];
		
		if([self isCancelled])
			return;
		
		/*		NSArray* curatedAccounts = [[NSArray alloc] initWithObjects:@"wsdot", @"seattle911", @"curb_cuisine",
		 @"westseattleblog", @"strangerslog", @"wsdot_traffic", @"wsferries", 
		 @"CHSfeed", @"MyGreenLake", @"showboxsea", @"woodlandparkzoo", @"iheartSAM",
		 @"SeattleAquarium", @"TheTripleDoor", @"SPLBuzz",@"SeattleParks",@"SeattleMet",
		 @"KIRO7Seattle",@"seattleweekly",@"myballard",@"Seahawks",@"TheRealMariners",
		 @"seattlePD", @"seattle20", @"SeattleFire", @"soundersfc", @"ctr4woodenboats", 
		 @"tcmseattle", @"PacSci", @"mollymoon", @"neumos", @"ChopSueySeattle", @"empsfm", 
		 @"MOHAI", @"UWSoftball", @"UWAthletics", @"stgpresents", @"LastSupperClub", 
		 @"thecrocodile", @"sunsetballard", @"tractortavern", nil];
		 */		
		NSMutableArray* curatedAccounts = [[NSMutableArray alloc] init];
		CuratedAccountsResponse* c01 = [[CuratedAccountsResponse alloc] initWithAccount:@"wsdot" category:CATEGORY_TRANSIT latitude:-213 longitude:1232];
		CuratedAccountsResponse* c02 = [[CuratedAccountsResponse alloc] initWithAccount:@"wsferries" category:CATEGORY_TRANSIT latitude:-213 longitude:1232];
		CuratedAccountsResponse* c03 = [[CuratedAccountsResponse alloc] initWithAccount:@"westseattleblog" category:CATEGORY_NEWS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c04 = [[CuratedAccountsResponse alloc] initWithAccount:@"uwathletics" category:CATEGORY_SPORTS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c05 = [[CuratedAccountsResponse alloc] initWithAccount:@"woodlandparkzoo" category:CATEGORY_OUTDOORS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c06 = [[CuratedAccountsResponse alloc] initWithAccount:@"iheartSAM" category:CATEGORY_MUSEUMS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c07 = [[CuratedAccountsResponse alloc] initWithAccount:@"seattleAquarium" category:CATEGORY_MUSEUMS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c08 = [[CuratedAccountsResponse alloc] initWithAccount:@"SeattleParks" category:CATEGORY_OUTDOORS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c09 = [[CuratedAccountsResponse alloc] initWithAccount:@"ctr4woodenboats" category:CATEGORY_MUSEUMS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c10 = [[CuratedAccountsResponse alloc] initWithAccount:@"PacSci" category:CATEGORY_MUSEUMS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c11 = [[CuratedAccountsResponse alloc] initWithAccount:@"empsfm" category:CATEGORY_MUSEUMS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c12 = [[CuratedAccountsResponse alloc] initWithAccount:@"mohai" category:CATEGORY_MUSEUMS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c13 = [[CuratedAccountsResponse alloc] initWithAccount:@"strangerslog" category:CATEGORY_NEWS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c14 = [[CuratedAccountsResponse alloc] initWithAccount:@"CHSfeed" category:CATEGORY_NEWS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c15 = [[CuratedAccountsResponse alloc] initWithAccount:@"MyGreenLake" category:CATEGORY_NEWS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c16 = [[CuratedAccountsResponse alloc] initWithAccount:@"kiro7seattle" category:CATEGORY_NEWS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c17 = [[CuratedAccountsResponse alloc] initWithAccount:@"myballard" category:CATEGORY_NEWS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c18 = [[CuratedAccountsResponse alloc] initWithAccount:@"wsdot_traffic" category:CATEGORY_TRANSIT latitude:-213 longitude:1232];
		CuratedAccountsResponse* c19 = [[CuratedAccountsResponse alloc] initWithAccount:@"curb_cuisine" category:CATEGORY_FOOD latitude:-213 longitude:1232];
		CuratedAccountsResponse* c20 = [[CuratedAccountsResponse alloc] initWithAccount:@"showboxsea" category:CATEGORY_NIGHTLIFE latitude:-213 longitude:1232];
		CuratedAccountsResponse* c21 = [[CuratedAccountsResponse alloc] initWithAccount:@"TheTripleDoor" category:CATEGORY_NIGHTLIFE latitude:-213 longitude:1232];
		CuratedAccountsResponse* c22 = [[CuratedAccountsResponse alloc] initWithAccount:@"seattle911" category:CATEGORY_MUNICIPAL latitude:-213 longitude:1232];
		CuratedAccountsResponse* c23 = [[CuratedAccountsResponse alloc] initWithAccount:@"SPLBuzz" category:CATEGORY_MUNICIPAL latitude:-213 longitude:1232];
		CuratedAccountsResponse* c24 = [[CuratedAccountsResponse alloc] initWithAccount:@"SeattleMet" category:CATEGORY_NEWS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c25 = [[CuratedAccountsResponse alloc] initWithAccount:@"Seahawks" category:CATEGORY_SPORTS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c26 = [[CuratedAccountsResponse alloc] initWithAccount:@"TheRealMariners" category:CATEGORY_SPORTS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c27 = [[CuratedAccountsResponse alloc] initWithAccount:@"seattleweekly" category:CATEGORY_NEWS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c28 = [[CuratedAccountsResponse alloc] initWithAccount:@"seattlePD" category:CATEGORY_MUNICIPAL latitude:-213 longitude:1232];
		CuratedAccountsResponse* c29 = [[CuratedAccountsResponse alloc] initWithAccount:@"TheBallroomSTL" category:CATEGORY_NIGHTLIFE latitude:-213 longitude:1232];
		CuratedAccountsResponse* c30 = [[CuratedAccountsResponse alloc] initWithAccount:@"SeattleFire" category:CATEGORY_MUNICIPAL latitude:-213 longitude:1232];
		CuratedAccountsResponse* c31 = [[CuratedAccountsResponse alloc] initWithAccount:@"soundersfc" category:CATEGORY_SPORTS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c32 = [[CuratedAccountsResponse alloc] initWithAccount:@"mollymoon" category:CATEGORY_FOOD latitude:-213 longitude:1232];
		CuratedAccountsResponse* c33 = [[CuratedAccountsResponse alloc] initWithAccount:@"tcmseattle" category:CATEGORY_MUSEUMS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c34 = [[CuratedAccountsResponse alloc] initWithAccount:@"neumos" category:CATEGORY_NIGHTLIFE latitude:-213 longitude:1232];
		CuratedAccountsResponse* c35 = [[CuratedAccountsResponse alloc] initWithAccount:@"ChopSueySeattle" category:CATEGORY_NIGHTLIFE latitude:-213 longitude:1232];
		CuratedAccountsResponse* c36 = [[CuratedAccountsResponse alloc] initWithAccount:@"UWSoftball" category:CATEGORY_SPORTS latitude:-213 longitude:1232];
		CuratedAccountsResponse* c37 = [[CuratedAccountsResponse alloc] initWithAccount:@"stgpresents" category:CATEGORY_NIGHTLIFE latitude:-213 longitude:1232];
		CuratedAccountsResponse* c38 = [[CuratedAccountsResponse alloc] initWithAccount:@"LastSupperClub" category:CATEGORY_NIGHTLIFE latitude:-213 longitude:1232];
		CuratedAccountsResponse* c39 = [[CuratedAccountsResponse alloc] initWithAccount:@"thecrocodile" category:CATEGORY_NIGHTLIFE latitude:-213 longitude:1232];
		CuratedAccountsResponse* c40 = [[CuratedAccountsResponse alloc] initWithAccount:@"sunsetballard" category:CATEGORY_NIGHTLIFE latitude:-213 longitude:1232];
		CuratedAccountsResponse* c41 = [[CuratedAccountsResponse alloc] initWithAccount:@"tractortavern" category:CATEGORY_NIGHTLIFE latitude:-213 longitude:1232];
		CuratedAccountsResponse* c42 = [[CuratedAccountsResponse alloc] initWithAccount:@"acttheatre" category:CATEGORY_THEATER latitude:-213 longitude:1232];
		CuratedAccountsResponse* c43 = [[CuratedAccountsResponse alloc] initWithAccount:@"seattlerep" category:CATEGORY_THEATER latitude:-213 longitude:1232];
		CuratedAccountsResponse* c44 = [[CuratedAccountsResponse alloc] initWithAccount:@"BroadwaySeattle" category:CATEGORY_THEATER latitude:-213 longitude:1232];
		CuratedAccountsResponse* c45 = [[CuratedAccountsResponse alloc] initWithAccount:@"SeattleOpera" category:CATEGORY_THEATER latitude:-213 longitude:1232];
		CuratedAccountsResponse* c46 = [[CuratedAccountsResponse alloc] initWithAccount:@"Biteofseattle" category:CATEGORY_FOOD latitude:-213 longitude:1232];
		CuratedAccountsResponse* c47 = [[CuratedAccountsResponse alloc] initWithAccount:@"SIFFNews" category:CATEGORY_THEATER latitude:-213 longitude:1232];
		CuratedAccountsResponse* c48 = [[CuratedAccountsResponse alloc] initWithAccount:@"5thAveTheatre" category:CATEGORY_THEATER latitude:-213 longitude:1232];
		CuratedAccountsResponse* c49 = [[CuratedAccountsResponse alloc] initWithAccount:@"seattlesymphony" category:CATEGORY_THEATER latitude:-213 longitude:1232];
		CuratedAccountsResponse* c50 = [[CuratedAccountsResponse alloc] initWithAccount:@"IntimanTheatre" category:CATEGORY_THEATER latitude:-213 longitude:1232];
		CuratedAccountsResponse* c51 = [[CuratedAccountsResponse alloc] initWithAccount:@"3DollarBillCine" category:CATEGORY_THEATER latitude:-213 longitude:1232];
		CuratedAccountsResponse* c52 = [[CuratedAccountsResponse alloc] initWithAccount:@"canlis" category:CATEGORY_FOOD latitude:-213 longitude:1232];
		CuratedAccountsResponse* c53 = [[CuratedAccountsResponse alloc] initWithAccount:@"TomDouglasCo" category:CATEGORY_FOOD latitude:-213 longitude:1232];
		CuratedAccountsResponse* c54 = [[CuratedAccountsResponse alloc] initWithAccount:@"larkseattle" category:CATEGORY_FOOD latitude:-213 longitude:1232];
		CuratedAccountsResponse* c55 = [[CuratedAccountsResponse alloc] initWithAccount:@"NFMASeattle" category:CATEGORY_FOOD latitude:-213 longitude:1232];
		CuratedAccountsResponse* c56 = [[CuratedAccountsResponse alloc] initWithAccount:@"SlowFoodSeattle" category:CATEGORY_FOOD latitude:-213 longitude:1232];
		CuratedAccountsResponse* c57 = [[CuratedAccountsResponse alloc] initWithAccount:@"skilletstfood" category:CATEGORY_FOOD latitude:-213 longitude:1232];
		CuratedAccountsResponse* c58 = [[CuratedAccountsResponse alloc] initWithAccount:@"somepigseattle" category:CATEGORY_FOOD latitude:-213 longitude:1232];
		CuratedAccountsResponse* c59 = [[CuratedAccountsResponse alloc] initWithAccount:@"BOKAchef" category:CATEGORY_FOOD latitude:-213 longitude:1232];

		
		[curatedAccounts addObject:c01];
		[curatedAccounts addObject:c02];
		[curatedAccounts addObject:c03];
		[curatedAccounts addObject:c04];
		[curatedAccounts addObject:c05];
		[curatedAccounts addObject:c06];
		[curatedAccounts addObject:c07];
		[curatedAccounts addObject:c08];
		[curatedAccounts addObject:c09];
		[curatedAccounts addObject:c10];
		[curatedAccounts addObject:c11];
		[curatedAccounts addObject:c12];		
		[curatedAccounts addObject:c13];		
		[curatedAccounts addObject:c14];		
		[curatedAccounts addObject:c15];		
		[curatedAccounts addObject:c16];		
		[curatedAccounts addObject:c17];		
		[curatedAccounts addObject:c18];		
		[curatedAccounts addObject:c19];		
		[curatedAccounts addObject:c20];		
		[curatedAccounts addObject:c21];		
		[curatedAccounts addObject:c22];		
		[curatedAccounts addObject:c23];		
		[curatedAccounts addObject:c24];		
		[curatedAccounts addObject:c25];		
		[curatedAccounts addObject:c26];		
		[curatedAccounts addObject:c27];		
		[curatedAccounts addObject:c28];		
		[curatedAccounts addObject:c29];		
		[curatedAccounts addObject:c30];		
		[curatedAccounts addObject:c31];		
		[curatedAccounts addObject:c32];		
		[curatedAccounts addObject:c33];		
		[curatedAccounts addObject:c34];		
		[curatedAccounts addObject:c35];		
		[curatedAccounts addObject:c36];		
		[curatedAccounts addObject:c37];		
		[curatedAccounts addObject:c38];		
		[curatedAccounts addObject:c39];		
		[curatedAccounts addObject:c40];		
		[curatedAccounts addObject:c41];		
		[curatedAccounts addObject:c42];		
		[curatedAccounts addObject:c43];		
		[curatedAccounts addObject:c44];		
		[curatedAccounts addObject:c45];		
		[curatedAccounts addObject:c46];		
		[curatedAccounts addObject:c47];		
		[curatedAccounts addObject:c48];		
		[curatedAccounts addObject:c49];		
		[curatedAccounts addObject:c50];		
		[curatedAccounts addObject:c51];		
		[curatedAccounts addObject:c52];		
		[curatedAccounts addObject:c53];		
		[curatedAccounts addObject:c54];		
		[curatedAccounts addObject:c55];		
		[curatedAccounts addObject:c56];		
		[curatedAccounts addObject:c57];		
		[curatedAccounts addObject:c58];		
		[curatedAccounts addObject:c59];		
//		[curatedAccounts addObject:c60];		
//		[curatedAccounts addObject:c61];		
//		[curatedAccounts addObject:c62];		
//		[curatedAccounts addObject:c63];		
		
		[c01 release];
		[c02 release];
		[c03 release];
		[c04 release];
		[c05 release];
		[c06 release];
		[c07 release];
		[c08 release];
		[c09 release];
		[c10 release];
		[c11 release];
		[c12 release];
		[c13 release];
		[c14 release];
		[c15 release];
		[c16 release];
		[c17 release];
		[c18 release];
		[c19 release];
		[c20 release];
		[c21 release];
		[c22 release];
		[c23 release];
		[c24 release];
		[c25 release];
		[c26 release];
		[c27 release];
		[c28 release];
		[c29 release];
		[c30 release];
		[c31 release];
		[c32 release];
		[c33 release];
		[c34 release];
		[c35 release];
		[c36 release];
		[c37 release];
		[c38 release];
		[c39 release];
		[c40 release];
		[c41 release];
		[c42 release];
		[c43 release];
		[c44 release];
		[c45 release];
		[c46 release];
		[c47 release];
		[c48 release];
		[c49 release];
		[c50 release];
		[c51 release];
		[c52 release];
		[c53 release];
		[c54 release];
		[c55 release];
		[c56 release];
		[c57 release];
		[c58 release];
		[c59 release];
//		[c60 release];
//		[c61 release];
		
		[targetObject performSelectorOnMainThread:targetMethod withObject:curatedAccounts waitUntilDone:NO];
		
		[curatedAccounts release];
	}
	@catch (NSException *e) 
	{
		NSLog(@"Error getting curated accounts", [e reason]);
	}
	@finally 
	{
		[fetcherPool release];
	}
}

@end
