//
//  SettingsScene.m
//  ZenLeaf
//
//  Created by 孙 黎 on 11-11-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimpleAudioEngine.h"

#import "SettingsScene.h"


@implementation SettingsScene

static SettingsScene* instanceOfSettingsScene;

+(SettingsScene*) sharedSettingsScene
{
	NSAssert(instanceOfSettingsScene != nil, @"SettingsScene instance not yet initialized!");
	return instanceOfSettingsScene;
}

+(id) scene
{
	CCScene* scene = [CCScene node];
	SettingsScene* layer = [SettingsScene node];
	[scene addChild:layer z:0];
	return scene;
}

-(id) init
{
	if ((self = [super init]))
	{
		instanceOfSettingsScene = self;
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		screenWidth = screenSize.width;
		screenHeight = screenSize.height;
		
		self.isTouchEnabled = YES;
		
		/*
		CCSprite *sprite;
		sprite = [CCSprite spriteWithSpriteFrameName:@"background.png"];
		[self addChild:sprite z:-1 tag:SettingsSceneLayerTagBackground];
		sprite.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
		background = [sprite retain];
		*/

	}
	return self;
}

-(void) dealloc
{
	instanceOfSettingsScene = nil;
	[super dealloc];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	[[CCDirector sharedDirector] popScene];
	return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

@end
