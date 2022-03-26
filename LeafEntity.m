//
//  LeafEntity.m
//  ZenLeaf
//
//  Created by 孙 黎 on 11-11-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LeafEntity.h"
#import "GameScene.h"
#import "ZigzagMoveComponent.h"

@interface LeafEntity (PrivateMethods)

-(void) initSpawnFrequency;
-(id) zigzagMove;

@end


@implementation LeafEntity

-(id) initWithType:(LeafTypes)leafType
{
	type = leafType;
	
	width = [GameScene screenRect].size.width;
	height = [GameScene screenRect].size.height;
	
	NSString* frameName;
	NSString* shadeFrameName;
	
	switch (type)
	{
		case LeafType1:
			frameName = @"leaf1.png";
			shadeFrameName = @"leaf1shadow.png";
			break;
		case LeafType2:
			frameName = @"leaf2.png";
			shadeFrameName = @"leaf2shadow.png";
			break;
		case LeafType3:
			frameName = @"leaf3.png";
			shadeFrameName = @"leaf3shadow.png";
			break;
		case LeafType4:
			frameName = @"leaf4.png";
			shadeFrameName = @"leaf4shadow.png";
			break;
		case LeafType5:
			frameName = @"leaf5.png";
			shadeFrameName = @"leaf5shadow.png";
			break;
			
		default:
			[NSException exceptionWithName:@"LeafEntity Exception" reason:@"unhandled leaf type" userInfo:nil];
	}
	
	if ((self = [super initWithSpriteFrameName:frameName]))
	{
		shade = [CCSprite spriteWithSpriteFrameName:shadeFrameName];
		shade.visible = YES;
		shade.position = CGPointMake(-500, -500);
		self.visible = NO;
		[self initSpawnFrequency];
	}
	
	[self scheduleUpdate];
	
	stopwatch = 0;
	[self schedule:@selector(oneSecondElapsed:) interval:1];
	
	return self;
}

-(CCSprite*) getShade
{
	return shade;
}

+(id) leafWithType:(LeafTypes)leafType
{
	return [[[self alloc] initWithType:leafType] autorelease];
}

static CCArray* spawnFrequency;

-(void) initSpawnFrequency
{
	if (spawnFrequency == nil)
	{
		spawnFrequency = [[CCArray alloc] initWithCapacity:LeafType_MAX];
		[spawnFrequency insertObject:[NSNumber numberWithInt:199] atIndex:LeafType1];
		[spawnFrequency insertObject:[NSNumber numberWithInt:211] atIndex:LeafType2];
		[spawnFrequency insertObject:[NSNumber numberWithInt:251] atIndex:LeafType3];
		[spawnFrequency insertObject:[NSNumber numberWithInt:311] atIndex:LeafType4];
		[spawnFrequency insertObject:[NSNumber numberWithInt:401] atIndex:LeafType5];
		[self spawn];
	}
}

+(int) getSpawnFrequencyForLeafType:(LeafTypes)leafType
{
	NSAssert(leafType < LeafType_MAX, @"invalid leaf type");
	NSNumber* number = [spawnFrequency objectAtIndex:leafType];
	return [number intValue];
}

-(void) dealloc
{
	[spawnFrequency release];
	spawnFrequency = nil;
	
	[super dealloc];
}

-(id) zigzagMove
{
	float rAngle = 110 + 40 * CCRANDOM_0_1();
	float elemTime = 1.3 + CCRANDOM_0_1() * 0.5;
	id am1 = [CCMoveBy actionWithDuration:elemTime position: ccp(170 + CCRANDOM_0_1() * 110, -(150 + CCRANDOM_0_1() * 100))];
	id am2 = [CCMoveBy actionWithDuration:elemTime position: ccp(-(170 + CCRANDOM_0_1() * 110), -(150 + CCRANDOM_0_1() * 100))];
	id am3 = [CCMoveBy actionWithDuration:elemTime position: ccp(170 + CCRANDOM_0_1() * 110, -(150 + CCRANDOM_0_1() * 100))];
	id am4 = [CCMoveBy actionWithDuration:elemTime position: ccp(-(170 + CCRANDOM_0_1() * 110), -(150 + CCRANDOM_0_1() * 100))];
	id am5 = [CCMoveBy actionWithDuration:elemTime position: ccp(170 + CCRANDOM_0_1() * 110, -(150 + CCRANDOM_0_1() * 100))];
	id am6 = [CCMoveBy actionWithDuration:elemTime position: ccp(-(170 + CCRANDOM_0_1() * 110), -(150 + CCRANDOM_0_1() * 100))];
	id alr = [CCRotateBy actionWithDuration:elemTime angle: -rAngle];
	id arr = [CCRotateBy actionWithDuration:elemTime angle: rAngle];
	id ar1 = [CCSpawn actions:am1, alr, nil];
	id ar2 = [CCSpawn actions:am2, arr, nil];
	id ar3 = [CCSpawn actions:am3, alr, nil];
	id ar4 = [CCSpawn actions:am4, arr, nil];
	id ar5 = [CCSpawn actions:am5, alr, nil];
	id ar6 = [CCSpawn actions:am6, arr, nil];
	id ae1 = [CCEaseSineInOut actionWithAction:ar1];
	id ae2 = [CCEaseSineInOut actionWithAction:ar2];
	id ae3 = [CCEaseSineInOut actionWithAction:ar3];
	id ae4 = [CCEaseSineInOut actionWithAction:ar4];
	id ae5 = [CCEaseSineInOut actionWithAction:ar5];
	id ae6 = [CCEaseSineInOut actionWithAction:ar6];
	id aFromTopLeft = [CCSequence actions: ae1, ae2, ae3, ae4, ae5, ae6, nil];
	id aFromTopRight = [CCSequence actions: ae2, ae1, ae4, ae3, ae6, ae5, nil];
	id aZigzag = [CCRepeatForever actionWithAction: (xBegin < width / 2 ? aFromTopLeft : aFromTopRight)];
	return aZigzag;
}

-(id) snowMove
{
	float moveDuration = 2 + CCRANDOM_0_1() * 4;
	float xOffset = (0.5 + CCRANDOM_0_1() * 0.5) * width;
	if (xBegin > width * 0.5)
		xOffset = -xOffset;
	float yOffset = -(yBegin + [self contentSize].height);
	float easeRate = 1 + CCRANDOM_0_1() * 0.5;
	float rotateDuration = 1.8 + CCRANDOM_0_1() * 0.3;
	id aMove = [CCMoveBy actionWithDuration:moveDuration position:ccp(xOffset, yOffset)];
	id aEase = [CCEaseIn actionWithAction:aMove rate:easeRate];
	id aRotateElem = [CCRotateBy actionWithDuration:rotateDuration angle: 720];
	id aRotate = [CCRepeat actionWithAction:aRotateElem times:moveDuration];
	id aFall = [CCSpawn actions: aEase, aRotate, nil];
	return aFall;
}

-(id) bezierMove
{
	float rotateAngle = 850 + 120 * CCRANDOM_0_1();
	float moveDuration = 2.5 + CCRANDOM_0_1() * 1.5;
	float xControl_1 = width * CCRANDOM_0_1() * 0.25;
	if (xBegin < width * 0.5)
		xControl_1 += width * 0.75;
	float xControl_2 = width * CCRANDOM_0_1() * 0.25;
	if (xControl_1 > width * 0.25)
		xControl_2 += width * 0.75;
	float xEndPosition = width * CCRANDOM_0_1() * 0.25;
	if (xControl_2 < width * 0.25)
		xEndPosition += width * 0.75;
	int yControl_1 = height * (0.6 + CCRANDOM_0_1() * 0.4);
	int yControl_2 = height * (0.4 - CCRANDOM_0_1() * 0.4);
	float yEndPosition = -[self contentSize].height;
	ccBezierConfig bConf;
	bConf.controlPoint_1 = CGPointMake(xControl_1 - xBegin, yControl_1 - yBegin);
	bConf.controlPoint_2 = CGPointMake(xControl_2 - xBegin, yControl_2 - yBegin);
	bConf.endPosition = CGPointMake(xEndPosition - xBegin, yEndPosition - yBegin);
	id aBezier = [CCBezierBy actionWithDuration:moveDuration bezier:bConf];
	id aRotate = [CCRotateBy actionWithDuration:moveDuration angle: rotateAngle];
	id aMove = [CCSpawn actions: aBezier, aRotate, nil];
	return aMove;
}

-(void) spawn
{
	xBegin = CCRANDOM_0_1() * (width - 100) + 50;
	yBegin = height + 2 * [self contentSize].height;
	
	self.position = CGPointMake(xBegin, yBegin);
	self.rotation = CCRANDOM_0_1() * 360;
	shade.rotation = self.rotation;
	float r = CCRANDOM_0_1();
	self.scale = 1 - r * 0.2;
	float offset = (1 - r) * 15 + 25;
	float xOffset = cos(M_PI * (1 + stopwatch / 180.0f)) * offset;
	float yOffset = sin(M_PI * (1 + stopwatch / 180.0f)) * offset;
	shade.position = CGPointMake(xBegin + xOffset, yBegin + yOffset);
	shade.scale = 0.8f;
	self.visible = YES;
	self.opacity = 255;
	shade.opacity = 192;
	
	float choice = CCRANDOM_0_1();
	id move = [self zigzagMove];	
	if (choice < 0.4f)
		move = [self bezierMove];
	else if (choice < 0.8f)
		move = [self snowMove];
	id action = move;//id action = [CCSpeed actionWithAction:action speed:1.0f];
	id shadeAction = [[action copy] autorelease];
	
	LeafEffects effect = [[GameScene sharedGameScene] getLeafEffect];
	trigger = LeafTriggerNothing;
	switch (effect) {
		case LeafEffectStealth:
			self.opacity = 0;
			break;
		case LeafEffectSlow:
	//		[action setSpeed:0.5f];
			break;
		case LeafEffectNothing: {
			float chance = CCRANDOM_0_1();
			if (chance > 0.8)
				trigger = LeafTriggerStealth;
			break;			
		}
		default:
			break;
	}
	switch (trigger) {
		case LeafTriggerStealth:
			self.opacity = 128;
			break;
		case LeafTriggerSlow:
			[self setColor:ccc3(0, 0, 0)];
			break;
		case LeafTriggerNothing:
			break;
		default:
			break;
	}
	
	[self runAction:action];
	[shade runAction:shadeAction];
}

-(void) gotHit
{
	[self setColor:ccc3(255, 255, 255)];
	self.visible = NO;
	[self stopAllActions];
	shade.opacity = 0;
	[shade stopAllActions];
	
	GameScene* scene = [GameScene sharedGameScene];
	if (trigger != LeafEffectNothing)
		[scene setLeafEffect:trigger];
	switch (trigger) {
		case LeafTriggerStealth:
			[[scene leafCache] changeOpacityTo:0];
			break;
		case LeafTriggerSlow:
			[[scene leafCache] changeSpeedTo:0.5f];
			break;
		case LeafTriggerNothing:
			break;
		default:
			break;
	}
}

-(void) update:(ccTime)delta
{
	if (self.position.y < -0.5 * [self contentSize].height) {
		[self setColor:ccc3(255, 255, 255)];
		self.visible = NO;
		shade.opacity = 0;
		[self stopAllActions];
		[shade stopAllActions];
	}
}

-(void) oneSecondElapsed:(ccTime)delta
{
	stopwatch += 6;
}

@end
