//
//  GameScene.m
//  ZenLeaf
//
//  Created by 孙 黎 on 11-11-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimpleAudioEngine.h"

#import "GameScene.h"
#import "LeafCache.h"


@implementation GameScene

static CGRect screenRect;

static GameScene* instanceOfGameScene;

+(GameScene*) sharedGameScene
{
	NSAssert(instanceOfGameScene != nil, @"GameScene instance not yet initialized!");
	return instanceOfGameScene;
}

+(id) scene
{
	CCScene* scene = [CCScene node];
	GameScene* layer = [GameScene node];
	[scene addChild:layer z:0 tag:GameSceneLayerTagGame];
	return scene;
}

-(id) init
{
	if ((self = [super init]))
	{
		instanceOfGameScene = self;
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		screenRect = CGRectMake(0, 0, screenSize.width, screenSize.height);
		screenWidth = screenSize.width;
		screenHeight = screenSize.height;
		
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"leaf-art.plist"];

		srandom(time(NULL));
		LeafCache* leafCache = [LeafCache node];
		[self addChild:leafCache z:0 tag:GameSceneNodeTagLeafCache];
		
		self.isTouchEnabled = YES;
		
		CCSprite *sprite;

		sprite = [CCSprite spriteWithSpriteFrameName:@"background.png"];
		[self addChild:sprite z:-1 tag:GameSceneLayerTagBackground];
		sprite.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
		background = [sprite retain];
		
	//	powerBar = [CCProgressTimer progressWithFrameName:@"siderbar.png"];
	//	powerBar.position = CGPointMake(10, screenSize.height / 2 - 30);
	//	powerBar.percentage = 50;
	//	[self addChild:powerBar z:15];
		
		sprite = [CCSprite spriteWithSpriteFrameName:@"Pause.png"];
		sprite.anchorPoint = ccp(1.2f, 1.2f);
		sprite.position = CGPointMake(screenSize.width, screenSize.height);
		[self addChild:sprite z:15];
		pauseButton = [sprite retain];
		pauseRect = CGRectMake(screenWidth - 50, screenHeight - 50, 50, 50);		
		
		sprite = [CCSprite spriteWithSpriteFrameName:@"grayground.png"];
		sprite.position = CGPointMake(screenWidth / 2, screenHeight / 2);
		[self addChild:sprite z:28];
		sprite.visible = NO;		
		grayground = [sprite retain];	
		
		sprite = [CCSprite spriteWithSpriteFrameName:@"Menu.png"];
		sprite.anchorPoint = ccp(1.0f, 0.5f);
		sprite.position = CGPointMake(screenWidth, screenHeight / 2);
		[self addChild:sprite z:29];
		sprite.visible = NO;
		menu = [sprite retain];
		
		sprite = [CCSprite spriteWithSpriteFrameName:@"Continue.png"];
		sprite.position = CGPointMake(screenWidth - 40, screenHeight / 2 - 60);
		[self addChild:sprite z:30];
		sprite.visible = NO;
		resumeButton = [sprite retain];
		resumeRect = CGRectMake(screenWidth - 40 - 20, screenHeight / 2 - 60 - 20, 40, 40);		
		
		sprite = [CCSprite spriteWithSpriteFrameName:@"Sound.png"];
		sprite.position = CGPointMake(screenWidth - 40, screenHeight / 2 - 10);
		[self addChild:sprite z:30];
		sprite.visible = NO;
		soundButton = [sprite retain];
		sprite = [CCSprite spriteWithSpriteFrameName:@"SoundX.png"];
		sprite.position = soundButton.position;
		[self addChild:sprite z:30];
		sprite.visible = NO;
		soundxButton = [sprite retain];
		soundRect = CGRectMake(screenWidth - 40 - 20, screenHeight / 2 - 10 - 20, 40, 40);
		
		muted = NO;

		CCLabelBMFont* label = [CCLabelBMFont labelWithString:@"0" fntFile:@"digits.fnt"];
		label.position = ccp(20,screenSize.height - 20);
		label.visible = YES;
		[self addChild:label];
		scoreLabel = [label retain];
		
		score = 0;
		[self updateScoreLabel:0];

		label = [CCLabelBMFont labelWithString:@"0" fntFile:@"digits.fnt"];
		label.visible = NO;
		[self addChild:label];
		comboLabel = [label retain];
		
	//	[self scheduleUpdate];
		[self schedule: @selector(comboTick:) interval:0.4f];
		[self schedule: @selector(leafEffectTick:) interval:0.2f];
		
		[self setLeafEffect: LeafEffectNothing];
	}
	return self;
}

-(void) dealloc
{
	instanceOfGameScene = nil;
	[super dealloc];
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

+(CGRect) screenRect
{
	return screenRect;
}

-(LeafCache*) leafCache
{
	CCNode* node = [self getChildByTag:GameSceneNodeTagLeafCache];
	NSAssert([node isKindOfClass:[LeafCache class]], @"not a LeafCache");
	return (LeafCache*)node;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	comboCount = 0;
	return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint locationView = [touch locationInView: [touch view]];
	CGPoint location = [[CCDirector sharedDirector] convertToGL:locationView];
	[[self leafCache] checkForCollisions:location];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint locationView = [touch locationInView: [touch view]];
	CGPoint location = [[CCDirector sharedDirector] convertToGL:locationView];
	if (CGRectContainsPoint(pauseRect, location) && menu.visible == NO)
	{
		[self.leafCache pauseSchedulerAndActions];
		pauseButton.visible = NO;
		grayground.visible = YES;
		menu.visible = YES;
		resumeButton.visible = YES;
		if (muted) {
			soundxButton.visible = YES;
		}
		else {
			soundButton.visible = YES;
		}
	}
	else if (CGRectContainsPoint(soundRect, location) && menu.visible == YES)
	{
		if (muted) {
			[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
			muted = NO;
			soundButton.visible = YES;
			soundxButton.visible = NO;
		}
		else {
			[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
			muted = YES;
			soundButton.visible = NO;
			soundxButton.visible = YES;
		}
	}
	else if (CGRectContainsPoint(resumeRect, location) && menu.visible == YES)
	{
		[self.leafCache resumeSchedulerAndActions];
		pauseButton.visible = YES;
		grayground.visible = NO;
		menu.visible = NO;
		resumeButton.visible = NO;
		soundButton.visible = NO;
		soundxButton.visible = NO;
	}
}

-(void) comboTick:(ccTime)dt
{
	if (comboCount >= 3) {
		[comboLabel setString:[NSString stringWithFormat:@"%d",comboCount]];
		[self updateScoreLabel:comboCount];
		comboLabel.visible = YES;
		id aOut = [CCFadeOut actionWithDuration:1.0f];
		id aScale = [CCScaleTo actionWithDuration:0.6f scale:2.0f];
		[comboLabel runAction:[CCSpawn actions:aOut, aScale, nil]];
		comboCount = -1;
	}
//	comboCount = 0;
}

-(void) updateComboWithPosition:(CGPoint)position
{
	comboLabel.position = position;
	if (comboCount != -1) {
		comboCount += 1;
	}
}

-(void) updateScoreLabel:(int)delta
{
	score += delta;
	[scoreLabel setString:[NSString stringWithFormat:@"%d",score]];
}

-(LeafEffects) getLeafEffect
{
	return globalLeafEffect;
}

-(void) setLeafEffect:(LeafEffects) leafEffect
{
	globalLeafEffect = leafEffect;
}

-(void) leafEffectTick:(ccTime)dt
{
	static int count = 0;
	if (globalLeafEffect != LeafEffectNothing) {
		count++;
		if (count > 30) {
			switch (globalLeafEffect) {
				case LeafEffectStealth:
					[[self leafCache] changeOpacityTo:255];
					break;
				case LeafEffectSlow:
					[[self leafCache] changeSpeedTo:1.0f];
					break;

				default:
					break;
			}
			globalLeafEffect = LeafEffectNothing;
			count = 0;
		}
	}
}

@end
