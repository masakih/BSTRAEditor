//
//  MyDocument.h
//  BSTRAEditor
//
//  Created by Hori,Masaki on 08/03/11.
//  Copyright Hori,Masaki 2008 . All rights reserved.
//


#import <Cocoa/Cocoa.h>

#import "BSTitleRulerAppearance.h"
#import "BSCSTitleRulerImitation.h"

@interface BSTRADocument : NSDocument
{
	BSTitleRulerAppearance *appearance;
	
	IBOutlet BSCSTitleRulerImitation* blueActiveView;
	IBOutlet BSCSTitleRulerImitation* graphiteActiveView;
	IBOutlet BSCSTitleRulerImitation* inactiveView;
	IBOutlet BSCSTitleRulerImitation* infoView;	
}

- (IBAction)saveToBSSupportFolder:(id)sender;

@end
