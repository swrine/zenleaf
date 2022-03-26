//
//  SettingsScene.h
//  ZenLeaf
//
//  Created by 孙 黎 on 11-11-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GameScene.h"

@interface SettingsScene : CCLayer {
	float screenWidth;
	float screenHeight;	
}

+(id) scene;
+(SettingsScene*) sharedSettingsScene;

@end
