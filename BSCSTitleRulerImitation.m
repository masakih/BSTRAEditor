//
//  BSCSTitleRulerImitation.m
//  IconSetComposer
//
//  Created by Hori,Masaki on 08/03/05.
//  Copyright 2008 Hori,Masaki. All rights reserved.
//

#import "BSCSTitleRulerImitation.h"

#import "BSTitleRulerAppearance.h"
#import "NSWorkspace-Extensions.h"
#import "NSBezierPath_AMShading.h"



@implementation BSCSTitleRulerImitation

#define	THICKNESS_FOR_TITLE	22.0
#define	THICKNESS_FOR_INFO	36.0
#define	TITLE_FONT_SIZE		12.0
#define	INFO_FONT_SIZE		13.0

#pragma mark Accessors
- (BSTitleRulerAppearance *)appearance
{
	return m_appearance;
}

- (void)setAppearance:(BSTitleRulerAppearance *)appearance
{
	[appearance retain];
	[m_appearance release];
	m_appearance = appearance;
	[self setNeedsDisplay:YES];
}

- (NSString *)titleStr
{
	return m_titleStr;
}

- (void)setTitleStr:(NSString *)aString
{
	[self setTitleStrWithoutNeedingDisplay:aString];
	[self setNeedsDisplay:YES];
}

- (void)setTitleStrWithoutNeedingDisplay:(NSString *)aString
{
	[aString retain];
	[m_titleStr release];
	m_titleStr = aString;
}

- (NSString *)infoStr
{
	return m_infoStr;
}

- (void)setInfoStr:(NSString *)aString
{
	[self setInfoStrWithoutNeedingDisplay:aString];
	[self setNeedsDisplay:YES];
}

- (void)setInfoStrWithoutNeedingDisplay:(NSString *)aString
{
	[aString retain];
	[m_infoStr release];
	m_infoStr = aString;
}

- (BSTitleRulerModeType)currentMode
{
	return _currentMode;
}

- (void)setCurrentMode:(BSTitleRulerModeType)newType
{
	float newThickness;
	_currentMode = newType;
	
	switch(newType) {
		case BSTitleRulerShowTitleOnlyMode:
			newThickness = THICKNESS_FOR_TITLE;
			break;
		case BSTitleRulerShowInfoOnlyMode:
			newThickness = THICKNESS_FOR_INFO;
			break;
		case BSTitleRulerShowTitleAndInfoMode:
			newThickness = (THICKNESS_FOR_TITLE + THICKNESS_FOR_INFO);
			break;
		default:
			newThickness = THICKNESS_FOR_TITLE;
			break;
	}
	
//	[self setRuleThickness:newThickness];
}
// addtional methods.
- (NSControlTint)representControlTint
{
	return representControlTint;
}
- (void)setRepresentControlTint:(NSControlTint)newTint
{
	representControlTint = newTint;
	// [self setNeedsDisplay:YES];
}

// 0: Inactive. 1: Active.
- (int)representActiveState
{
	return representActiveState;
}
- (void)setRepresentActiveState:(int)newState
{
	representActiveState = newState;
	// [self setNeedsDisplay:YES];
}

#pragma mark Private Utilities
- (NSDictionary *)attrTemplateForTitle
{
	/*static*/ NSDictionary	*tmp = nil;
	if (!tmp) {
		NSColor			*color_;
		
		color_ = [[self appearance] textColor];
		
		tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
			   [NSFont boldSystemFontOfSize:TITLE_FONT_SIZE], NSFontAttributeName,
			   color_, NSForegroundColorAttributeName,
			   nil];
	}
//	return tmp;
	return [tmp autorelease];
}

- (NSDictionary *)attrTemplateForInfo
{
	/*static*/ NSDictionary	*tmp2 = nil;
	if (!tmp2) {
		NSColor			*color_;
		
		color_ = [[self appearance] infoColor];
		
		tmp2 = [[NSDictionary alloc] initWithObjectsAndKeys:
				[NSFont systemFontOfSize:INFO_FONT_SIZE], NSFontAttributeName,
				color_, NSForegroundColorAttributeName,
				nil];
	}
//	return tmp2;
	return [tmp2 autorelease];
}

- (NSAttributedString *)titleForDrawing
{
	return [[[NSAttributedString alloc] initWithString:[self titleStr] attributes:[self attrTemplateForTitle]] autorelease];
}

- (NSAttributedString *)infoForDrawing
{
	return [[[NSAttributedString alloc] initWithString:[self infoStr] attributes:[self attrTemplateForInfo]] autorelease];
}

- (NSArray *)activeColors
{
	BSTitleRulerAppearance *appearance = [self appearance];
	return ([self representControlTint] == NSGraphiteControlTint) ? [appearance activeGraphiteColors] : [appearance activeBlueColors];
}

#pragma mark Setup & Cleanup
- (id)initWithFrame:(NSRect)frame
{
	if (self = [super initWithFrame:frame]) {
		// BSTitleRulerView Properties
		[self setCurrentMode:BSTitleRulerShowTitleOnlyMode];
//		[self setAppearance:appearance];
	}
	return self;
}

- (void)dealloc
{
	[m_titleStr release];
	[m_infoStr release];
	[m_appearance release];
	
	[super dealloc];
}

#pragma mark Drawing
- (void)drawTitleBarInRect:(NSRect)aRect
{
	NSArray	*colors_;
	NSColor *gradientStartColor, *gradientEndColor;
	
	BSTitleRulerAppearance	*appearance = [self appearance];
	
	colors_ = [self representActiveState] ? [self activeColors] : [appearance inactiveColors];
	
	gradientStartColor = [colors_ objectAtIndex:0];
	gradientEndColor = [colors_ objectAtIndex:1];
	
	[[NSBezierPath bezierPathWithRect:aRect] linearGradientFillWithStartColor:gradientStartColor endColor:gradientEndColor];
	
	if ([appearance drawsCarvedText]) {
		// このへん、暫定的
		NSMutableAttributedString *foo = [[self titleForDrawing] mutableCopy];
		NSRange	range = NSMakeRange(0,[foo length]);
		[foo removeAttribute:NSForegroundColorAttributeName range:range];
		[foo addAttributes:[NSDictionary dictionaryWithObject:[NSColor grayColor] forKey:NSForegroundColorAttributeName] range:range];
		[foo drawInRect:NSInsetRect(aRect, 5.0, 3.0)];
		[foo release];
	}
	
	[[self titleForDrawing] drawInRect:NSInsetRect(aRect, 5.0, 2.0)];
}

- (BOOL)isOpaque
{
	return YES;
}

- (void)drawInfoBarInRect:(NSRect)aRect
{
	NSRect	iconRect;
	NSImage *icon_ = [[NSWorkspace sharedWorkspace] systemIconForType:kAlertNoteIcon];
	[icon_ setSize:NSMakeSize(32, 32)];
	[icon_ setFlipped:[self isFlipped]];
	
	[[[self appearance] infoBackgroundColor] set];
	NSRectFill(aRect);	
	
	iconRect = NSMakeRect(NSMinX(aRect)+5.0, NSMinY(aRect)+2.0, 32, 32);
	
	[icon_ drawInRect:iconRect fromRect:NSMakeRect(0,0,32,32) operation:NSCompositeSourceOver fraction:1.0];
	
	aRect = NSInsetRect(aRect, 5.0, 7.0);
	aRect.origin.x += 36.0;
	[[self infoForDrawing] drawInRect:NSInsetRect(aRect, 5.0, 2.0)];
}

- (void)drawRect:(NSRect)aRect
{
	switch ([self currentMode]) {
		case BSTitleRulerShowTitleOnlyMode:
			[self drawTitleBarInRect:aRect];
			break;
		case BSTitleRulerShowInfoOnlyMode:
			[self drawInfoBarInRect:aRect];
			break;
		case BSTitleRulerShowTitleAndInfoMode:
		{
			NSRect titleRect, infoRect;
			NSDivideRect(aRect, &infoRect, &titleRect, THICKNESS_FOR_INFO, NSMaxYEdge);
			[self drawTitleBarInRect:titleRect];
			[self drawInfoBarInRect:infoRect];
		}
			break;
	}
}

// additional methods.
- (BOOL)isFlipped
{
	return YES;
}
@end

