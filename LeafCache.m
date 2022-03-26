//
//  LeafCache.m
//  ZenLeaf
//
//  Created by 孙 黎 on 11-11-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LeafCache.h"
#import "LeafEntity.h"
#import "GameScene.h"


@interface LeafCache (PrivateMethods)

-(void) initLeaves;

@end


@implementation LeafCache

+(id) cache
{
	return [[[self alloc] init] autorelease];
}

-(id) init
{
	if ((self = [super init]))
	{
		// get any image from the Texture Atlas we're using
		CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"leaf1.png"];
		batch = [CCSpriteBatchNode batchNodeWithTexture:frame.texture];
		shadeBatch = [CCSpriteBatchNode batchNodeWithTexture:frame.texture];		
		[self addChild:batch z:7];
		[self addChild:shadeBatch z:6];
		
		[self initLeaves];
		[self scheduleUpdate];
	}
	
	return self;
}

-(void) initLeaves
{
	leaves = [[CCArray alloc] initWithCapacity:LeafType_MAX];
	
	for (int i = 0; i < LeafType_MAX; i++)
	{
		int capacity;
		switch (i)
		{
			case LeafType1:
				capacity = 1;
				break;
			case LeafType2:
				capacity = 1;
				break;
			case LeafType3:
				capacity = 1;
				break;
			case LeafType4:
				capacity = 1;
				break;
			case LeafType5:
				capacity = 1;
				break;				
				
			default:
				[NSException exceptionWithName:@"LeafCache Exception" reason:@"unhandled leaf type" userInfo:nil];
				break;
		}
		
		CCArray* leavesOfType = [CCArray arrayWithCapacity:capacity];
		[leaves addObject:leavesOfType];
	}
	
	for (int i = 0; i < LeafType_MAX; i++)
	{
		CCArray* leavesOfType = [leaves objectAtIndex:i];
		int numLeavesOfType = [leavesOfType capacity];
		
		for (int j = 0; j < numLeavesOfType; j++)
		{
			LeafEntity* leaf = [LeafEntity leafWithType:i];
			[batch addChild:leaf z:0 tag:i];
			[shadeBatch addChild:[leaf getShade] z:6 tag:numLeavesOfType + i];
			[leavesOfType addObject:leaf];
		}
	}
}

-(void) dealloc
{
	[leaves release];
	[super dealloc];
}


-(void) spawnLeafOfType:(LeafTypes)leafType
{
	CCArray* leavesOfType = [leaves objectAtIndex:leafType];
	
	LeafEntity* leaf;
	CCARRAY_FOREACH(leavesOfType, leaf)
	{
		if (leaf.visible == NO)
		{
			//CCLOG(@"spawn leaf type %i", leafType);
			[leaf spawn];
			break;
		}
	}
}

-(void) checkForCollisions:(CGPoint)point
{
	
	LeafEntity* leaf;
	CCARRAY_FOREACH([batch children], leaf)
	{
		if (leaf.visible)
		{
			CGRect bbox = [leaf boundingBox];
			if (CGRectContainsPoint(bbox, point))
			{
				[leaf gotHit];
				
				CCParticleSystem *ps = [CCParticleExplosion node];
				[[GameScene sharedGameScene] addChild:ps z:12];
				//	ps.blendAdditive = YES;
				ps.position = point;
				ps.life = 0.3f;
				ps.lifeVar = 0.3f;
				ps.totalParticles = 20.0f;
				ps.startSize = 2;
				ps.endSize = 1;
				ps.autoRemoveOnFinish = YES;
				
				[[GameScene sharedGameScene] updateScoreLabel: 1];

				[[GameScene sharedGameScene] updateComboWithPosition: point];
			}
		}
	}
}

-(void) update:(ccTime)delta
{
	updateCount++;
	
	for (int i = LeafType_MAX - 1; i >= 0; i--)
	{
		int spawnFrequency = [LeafEntity getSpawnFrequencyForLeafType:i];
		
		if (updateCount % spawnFrequency == 0)
		{
			[self spawnLeafOfType:i];
			break;
		}
	}
}

-(void) changeSpeedTo:(float)speed
{
	LeafEntity* leaf;
	CCARRAY_FOREACH([batch children], leaf)
	{
//		if (leaf.visible == YES)
//			[(CCSpeed*)[leaf getActionByTag:9] setSpeed:speed];
	}
	
}

-(void) changeOpacityTo:(int)opacity
{
	LeafEntity* leaf;
	CCARRAY_FOREACH([batch children], leaf)
	{
		if (leaf.visible == YES)
			[leaf runAction:[CCFadeTo actionWithDuration:0.8f opacity:opacity]];
	}
	
}

-(void) pauseSchedulerAndActions
{
	[super pauseSchedulerAndActions];
	LeafEntity* leaf;
	CCARRAY_FOREACH([batch children], leaf)
	{
		[leaf pauseSchedulerAndActions];
		[[leaf getShade] pauseSchedulerAndActions];
	}
	
}

-(void) resumeSchedulerAndActions
{
	[super resumeSchedulerAndActions];
	LeafEntity* leaf;
	CCARRAY_FOREACH([batch children], leaf)
	{
		[leaf resumeSchedulerAndActions];
		[[leaf getShade] resumeSchedulerAndActions];
	}
	
}

@end