//
//  MyDocument.m
//  BSTRAEditor
//
//  Created by Hori,Masaki on 08/03/11.
//  Copyright Hori,Masaki 2008 . All rights reserved.
//

#import "BSTRADocument.h"

@interface BSTRADocument (Addition)
- (void)setAppearance:(BSTitleRulerAppearance *)newAppearance;
- (BSTitleRulerAppearance *)appearance;
- (NSString *)bathyScapheSupportFolder;
- (void)displayItemForKey:(NSString *)key;
@end

@implementation BSTRADocument

- (id)init
{
    self = [super init];
    if (self) {
		
		NSBundle *b = [NSBundle mainBundle];
		id archiPath = [b pathForResource:@"BSTitleRulerAppearance" ofType:@"plist"];
		
        id a = [[NSKeyedUnarchiver unarchiveObjectWithFile:archiPath] retain];
		if(!a) {
			NSLog(@"OIASDFHJJKLSHGFIUORWHEG(UPIOJDSKXCBNKASJLCK");
		}
		[self setAppearance:a];
    }
    return self;
}

- (void)dealloc
{
	[self setAppearance:nil];
	
	[super dealloc];
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"BSTRADocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
	NSString *title = NSLocalizedString(@"Title.", @"Title.");
	NSString *information = NSLocalizedString(@"Information.", @"Information.");
	
	[blueActiveView setAppearance:appearance];
	[blueActiveView setTitleStrWithoutNeedingDisplay:title];
	[blueActiveView setInfoStrWithoutNeedingDisplay:information];
	[blueActiveView setCurrentMode:BSTitleRulerShowTitleOnlyMode];
	[blueActiveView setRepresentControlTint:NSBlueControlTint];
	[blueActiveView setRepresentActiveState:1];
	
	[graphiteActiveView setAppearance:appearance];
	[graphiteActiveView setTitleStrWithoutNeedingDisplay:title];
	[graphiteActiveView setInfoStrWithoutNeedingDisplay:information];
	[graphiteActiveView setCurrentMode:BSTitleRulerShowTitleOnlyMode];
	[graphiteActiveView setRepresentControlTint:NSGraphiteControlTint];
	[graphiteActiveView setRepresentActiveState:1];
	
	[inactiveView setAppearance:appearance];
	[inactiveView setTitleStrWithoutNeedingDisplay:title];
	[inactiveView setInfoStrWithoutNeedingDisplay:information];
	[inactiveView setCurrentMode:BSTitleRulerShowTitleOnlyMode];
	[inactiveView setRepresentControlTint:NSBlueControlTint];
	[inactiveView setRepresentActiveState:0];
	
	[infoView setAppearance:appearance];
	[infoView setTitleStrWithoutNeedingDisplay:title];
	[infoView setInfoStrWithoutNeedingDisplay:information];
	[infoView setCurrentMode:BSTitleRulerShowInfoOnlyMode];
	[infoView setRepresentControlTint:NSBlueControlTint];
	[infoView setRepresentActiveState:1];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    return [NSKeyedArchiver archivedDataWithRootObject:appearance]; 
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    id a = nil;
    @try {
		a = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	}
	@catch(NSException *ex) {
		
		if (outError != NULL) {
			*outError = [NSError errorWithDomain:@"BSTRAEditor" code:10 userInfo:NULL];
		}
		return NO;
	}
	if(!a) {
		if (outError != NULL) {
			*outError = [NSError errorWithDomain:@"BSTRAEditor" code:20 userInfo:NULL];
		}
		return NO;
	}
	
	if(![a isMemberOfClass:[BSTitleRulerAppearance class]]) {
		if (outError != NULL && *outError != nil) {
			*outError = [NSError errorWithDomain:@"BSTRAEditor" code:30 userInfo:NULL];
		}
		return NO;
	}
	
	[self setAppearance:a];
	
    return YES;
}

#pragma mark For Panther
- (NSData *)dataRepresentationOfType:(NSString *)type
{
	return [self dataOfType:type error:NULL];
}
- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)type
{
	return [self readFromData:data ofType:type error:NULL];
}

#pragma mark Actions
- (IBAction)saveToBSSupportFolder:(id)sender
{
	NSString *fileName = [self bathyScapheSupportFolder];
	
	fileName = [fileName stringByAppendingPathComponent:@"BSTitleRulerAppearance.plist"];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	BOOL isDir;
	NSString *information;
	NSString *message;
	NSAlert *alert;
	if([fm fileExistsAtPath:fileName isDirectory:&isDir]) {
		information = NSLocalizedString(@"Message002", @"Message002");
		message = NSLocalizedString(@"Message001", @"Message001");
		
		message = [NSString stringWithFormat:message, fileName];
		alert = [NSAlert alertWithMessageText:message
								defaultButton:NSLocalizedString(@"Cancel", @"Cancel")
							  alternateButton:NSLocalizedString(@"Replace", @"Replace")
								  otherButton:nil
					informativeTextWithFormat:information];
		NSInteger ret = [alert runModal];
		if(ret == NSAlertDefaultReturn) {
			return;
		}
		
		if(ret == NSAlertAlternateReturn && isDir) {
			if(![fm removeFileAtPath:fileName handler:nil]) {
//				information = NSLocalizedString(@"Message003", @"Message003");
//				alert = [NSAlert alertWithMessageText:NSLocalizedString(@"Message004", @"Message004")
//										defaultButton:NSLocalizedString(@"OK", @"OK")
//									  alternateButton:nil
//										  otherButton:nil
//							informativeTextWithFormat:information];
//				[alert setAlertStyle:NSCriticalAlertStyle];
//				[alert runModal];
//				
//				return;
			}
		}
	}
	
	if(![NSKeyedArchiver archiveRootObject:[self appearance] toFile:fileName]) {
		information = NSLocalizedString(@"Message005", @"Message005");
		message = NSLocalizedString(@"Message006", @"Message006");
		
		information = [NSString stringWithFormat:information, fileName];
		message = [NSString stringWithFormat:message, fileName];
		alert = [NSAlert alertWithMessageText:message
								defaultButton:NSLocalizedString(@"OK", @"OK")
							  alternateButton:nil
								  otherButton:nil
					informativeTextWithFormat:information];
		[alert setAlertStyle:NSCriticalAlertStyle];
		[alert runModal];
		
		return;
	}
}
	
@end

@implementation BSTRADocument (Addition)
NSString *resolveAlias(NSString *path)
{
	NSString *newPath = nil;
	
	FSRef	ref;
	char *newPathCString;
	Boolean isDir,  wasAliased;
	OSStatus err;
	
	err = FSPathMakeRef( (UInt8 *)[path fileSystemRepresentation], &ref, NULL );
	if( err == dirNFErr ) {
		NSString *lastPath = [path lastPathComponent];
		NSString *parent = [path stringByDeletingLastPathComponent];
		NSString *f;
		
		if( [@"/" isEqualTo:parent] ) return nil;
		
		parent = resolveAlias( parent );
		if( !parent ) return nil;
		
		f = [parent stringByAppendingPathComponent:lastPath];
		
		err = FSPathMakeRef( (UInt8 *)[f fileSystemRepresentation], &ref, NULL );
	}
	if( err != noErr ) {
		return nil;
	}
	
	err = FSResolveAliasFile( &ref, TRUE, &isDir, &wasAliased );
	if( err != noErr ) {
		return nil;
	}
	
	newPathCString = (char *)malloc( sizeof(unichar) * 1024 );
	if( !newPathCString ) {
		return nil;
	}
	
	err = FSRefMakePath( &ref, (UInt8 *)newPathCString, sizeof(unichar) * 1024 );
	if( err != noErr ) {
		goto final;
	}
	
	newPath = [NSString stringWithUTF8String:newPathCString];
	
final:
	free( (char *)newPathCString );
	
	return newPath;
}
- (NSString *)bathyScapheSupportFolder
{
	static NSString *result = nil;
	
	if(  !result ) {
		NSArray *dirs = NSSearchPathForDirectoriesInDomains( NSLibraryDirectory, NSUserDomainMask, YES );
		NSString *tmp;
		
		if( !dirs || [dirs count] == 0 ) return NSHomeDirectory();
		
		result = [dirs objectAtIndex:0];
		result = [result stringByAppendingPathComponent:@"Application Support"];
		result = [result stringByAppendingPathComponent:@"BathyScaphe"];
		tmp = resolveAlias( result );
		if( tmp ) result = tmp;
		[result retain];
	}
	
	return result;
}
- (void)setAppearance:(BSTitleRulerAppearance *)newAppearance
{
	if(appearance == newAppearance) return;
	
	const NSString *paths[] = {
		@"activeBlueStartColor",
		@"activeBlueEndColor",
		@"activeGraphiteStartColor",
		@"activeGraphiteEndColor",
		@"inactiveStartColor",
		@"inactiveEndColor",
		@"textColor",
		@"infoColor",
		@"infoBackgroundColor",
		@"drawsCarvedText",
		nil
	};
	
	NSString **p = paths;
	while(*p) {
		[appearance removeObserver:self forKeyPath:*p++];
	}
	[appearance autorelease];
	
	appearance = [newAppearance retain];
	
	p = paths;
	while(*p) {
		[appearance addObserver:self
					 forKeyPath:*p++
						options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
						context:NULL];
	}
}
- (BSTitleRulerAppearance *)appearance
{
	return appearance;
}

- (SEL)selForKey:(NSString *)key
{
	if([key isEqualToString:@"activeBlueStartColor"]) {
		return @selector(setActiveBlueStartColor:);
	}
	if([key isEqualToString:@"activeBlueEndColor"]) {
		return @selector(setActiveBlueEndColor:);
	}
	if([key isEqualToString:@"activeGraphiteStartColor"]) {
		return @selector(setActiveGraphiteStartColor:);
	}
	if([key isEqualToString:@"activeGraphiteEndColor"]) {
		return @selector(setActiveGraphiteEndColor:);
	}
	if([key isEqualToString:@"inactiveStartColor"]) {
		return @selector(setInactiveStartColor:);
	}
	if([key isEqualToString:@"inactiveEndColor"]) {
		return @selector(setInactiveEndColor:);
	}
	if([key isEqualToString:@"textColor"]) {
		return @selector(setTextColor:);
	}
	if([key isEqualToString:@"infoColor"]) {
		return @selector(setInfoColor:);
	}
	if([key isEqualToString:@"infoBackgroundColor"]) {
		return @selector(setInfoBackgroundColor:);
	}
	
	return NULL;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if([[change objectForKey:NSKeyValueChangeKindKey] intValue] != NSKeyValueChangeSetting) return;
	id old, new;
	old = [change objectForKey:NSKeyValueChangeOldKey];
	new = [change objectForKey:NSKeyValueChangeNewKey];
	if([old isEqual:new]) return;
	
	NSUndoManager *undo = [self undoManager];
	SEL sel = [self selForKey:keyPath];
	[undo beginUndoGrouping];
	if(old && sel) {
		[undo registerUndoWithTarget:appearance
							selector:sel
							  object:old];
	}
	if([keyPath isEqual:@"drawsCarvedText"]) {
		[[undo prepareWithInvocationTarget:appearance] setDrawsCarvedText:[old boolValue]];
	}
	[undo registerUndoWithTarget:self
						selector:@selector(displayItemForKey:)
						  object:keyPath];
	[undo endUndoGrouping];
	
	[self displayItemForKey:keyPath];
}
- (void)displayItemForKey:(NSString *)key
{
	if([key hasPrefix:@"activeBlue"]) {
		[blueActiveView setNeedsDisplay:YES];
	} else if([key hasPrefix:@"activeGraphite"]) {
		[graphiteActiveView setNeedsDisplay:YES];
	} else if([key hasPrefix:@"inactive"]) {
		[inactiveView setNeedsDisplay:YES];
	} else if([key hasPrefix:@"infoBack"]) {
		[infoView setNeedsDisplay:YES];
	} else { // Maybe text color or carved.
		[blueActiveView setNeedsDisplay:YES];
		[graphiteActiveView setNeedsDisplay:YES];
		[inactiveView setNeedsDisplay:YES];
		[infoView setNeedsDisplay:YES];
	}
}

@end
