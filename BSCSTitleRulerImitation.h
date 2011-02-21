//
//  BSCSTitleRulerImitation.h
//  IconSetComposer
//
//  Created by Hori,Masaki on 08/03/05.
//  Copyright 2008 Hori,Masaki. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BSTitleRulerAppearance;

typedef enum _BSTitleRulerModeType {
	BSTitleRulerShowTitleOnlyMode		= 0, // スレッドタイトルバーのみ
	BSTitleRulerShowInfoOnlyMode		= 1, // 「dat 落ちと判定されました。」のみ
	BSTitleRulerShowTitleAndInfoMode	= 2, // スレッドタイトルバー、その下に「dat 落ちと判定されました。」
} BSTitleRulerModeType;


@interface BSCSTitleRulerImitation : NSView
{
	BSTitleRulerAppearance *m_appearance;
	
	NSString	*m_titleStr;
	NSString	*m_infoStr;
	
	BSTitleRulerModeType	_currentMode;
	
	// addtional variables.
	NSControlTint representControlTint;
	NSInteger representActiveState; // 0: Inactive. 1: Active.
}

- (BSTitleRulerAppearance *)appearance;
- (void)setAppearance:(BSTitleRulerAppearance *)appearance;

- (NSString *)titleStr;
- (void)setTitleStr:(NSString *)aString;
- (void)setTitleStrWithoutNeedingDisplay:(NSString *)aString;

- (NSString *)infoStr;
- (void)setInfoStr:(NSString *)aString;
- (void)setInfoStrWithoutNeedingDisplay:(NSString *)aString;

- (BSTitleRulerModeType)currentMode;
- (void)setCurrentMode:(BSTitleRulerModeType)newType;

// addtional methods.
- (NSControlTint)representControlTint;
- (void)setRepresentControlTint:(NSControlTint)newTint;

// 0: Inactive. 1: Active.
- (NSInteger)representActiveState;
- (void)setRepresentActiveState:(NSInteger)newState;

@end
