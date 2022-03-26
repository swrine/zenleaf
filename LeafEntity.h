//
//  LeafEntity.h
//  ZenLeaf
//
//  Created by 孙 黎 on 11-11-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

typedef enum
{
	LeafType1 = 0,
	LeafType2,
	LeafType3,
	LeafType4,
	LeafType5,
	
	LeafType_MAX,
} LeafTypes;

typedef enum
{
	LeafTriggerNothing = 0,
	LeafTriggerStealth,
	LeafTriggerSlow,
	
	LeafTrigger_MAX,
} LeafTriggers;

@interface LeafEntity : Entity
{
	LeafTypes type;
	LeafTriggers trigger;
	
	CCSprite* shade;
	
	float width;
	float height;
	float xBegin;
	float yBegin;
	float leafHeight;
	
	int stopwatch;
}

+(id) leafWithType:(LeafTypes)leafType;

+(int) getSpawnFrequencyForLeafType:(LeafTypes)leafType;

-(CCSprite*) getShade;

-(void) spawn;

-(void) gotHit;

@end
