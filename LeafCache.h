//
//  LeafCache.h
//  ZenLeaf
//
//  Created by 孙 黎 on 11-11-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LeafCache : CCNode {
	CCSpriteBatchNode* batch;
	CCSpriteBatchNode* shadeBatch;
	CCArray* leaves;
	
	int updateCount;
}

-(void) checkForCollisions:(CGPoint)point;

-(void) changeSpeedTo:(float)speed;

-(void) changeOpacityTo:(int)opacity;

-(void) pauseSchedulerAndActions;

-(void) resumeSchedulerAndActions;

@end
