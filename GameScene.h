//
//  GameScene.h
//  ZenLeaf
//
//  Created by 孙 黎 on 11-11-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "LeafCache.h"
#import "SettingsScene.h"

typedef enum
{
	GameSceneLayerTagGame = 1,
	GameSceneLayerTagBackground,
} GameSceneLayerTags;

typedef enum
{
	GameSceneNodeTagLeafCache = 1,
} GameSceneNodeTags;

typedef enum
{
	LeafEffectNothing = 0,
	LeafEffectStealth,
	LeafEffectSlow,
	
	LeafEffect_MAX,
} LeafEffects;

@interface GameScene : CCLayer
{
	float screenWidth;
	float screenHeight;
	
	CCSprite* background;
	CCSprite* pauseButton;
	CCSprite* grayground;
	CCSprite* menu;
	CCSprite* soundButton;
	CCSprite* soundxButton;
	CCSprite* resumeButton;
	
	CGRect soundRect;
	CGRect pauseRect;
	CGRect resumeRect;	
	
	BOOL muted;
	int score;
	CCLabelBMFont* scoreLabel;
	CCLabelBMFont* comboLabel;	
	int comboCount;
	
	CCProgressTimer* powerBar;
	
	LeafEffects globalLeafEffect;
}

+(id) scene;
+(GameScene*) sharedGameScene;

+(CGRect) screenRect;

-(void) updateScoreLabel:(int)delta;

-(void) updateComboWithPosition:(CGPoint)position;

-(void) comboTick:(ccTime)dt;

-(LeafEffects) getLeafEffect;

-(void) setLeafEffect:(LeafEffects)leafEffect;

-(void) leafEffectTick:(ccTime)dt;

@property (readonly, nonatomic) LeafCache* leafCache;

@end
