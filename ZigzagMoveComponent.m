//
//  ZigzagMoveComponent.m
//  ZenLeaf
//
//  Created by 孙 黎 on 11-11-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZigzagMoveComponent.h"
#import "Entity.h"
#import "GameScene.h"

@implementation ZigzagMoveComponent

-(id) init
{
	if ((self = [super init]))
	{
		velocity = CGPointMake(0, -1);
		[self scheduleUpdate];
	}

	return self;
}

-(void) update:(ccTime)delta
{
	if (self.parent.visible)
	{
		NSAssert([self.parent isKindOfClass:[Entity class]], @"node is not a Entity");
		
		Entity* entity = (Entity*)self.parent;
		if (entity.position.x > [GameScene screenRect].size.width * 0.5f)
		{
			[entity setPosition:ccpAdd(entity.position, velocity)];
		}
	}
}

@end
