//
//  NormalCircle.m
//  SuQian
//
//  Created by Suraj on 24/9/12.
//  Copyright (c) 2012 Suraj. All rights reserved.
//

#import "NormalCircle.h"
#import <QuartzCore/QuartzCore.h>
#import "PSSAppDelegate.h"

#define kInnerColor			[UIColor colorWithRed:46.0/255.0 green:144.0/255.0 blue:90.0/255.0 alpha:0.0]
#define kHighlightColor	[UIColor colorWithRed:46.0/255.0 green:144.0/255.0 blue:90.0/255.0 alpha:0.9]

@implementation NormalCircle
@synthesize selected,cacheContext;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
	}
	return self;
}

- (id)initwithRadius:(CGFloat)radius
{
	CGRect frame = CGRectMake(0, 0, 2*radius, 2*radius);
	NormalCircle *circle = [self initWithFrame:frame];
	if (circle) {
		[circle setBackgroundColor:[UIColor clearColor]];
	}
	return circle;
}

- (void)drawRect:(CGRect)rect
{
    UIColor * tintColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
	CGContextRef context = UIGraphicsGetCurrentContext();
	self.cacheContext = context;
	CGFloat lineWidth = 1.0;
	CGRect rectToDraw = CGRectMake(rect.origin.x+lineWidth, rect.origin.y+lineWidth, rect.size.width-2*lineWidth, rect.size.height-2*lineWidth);
	CGContextSetLineWidth(context, lineWidth);
	CGContextSetStrokeColorWithColor(context, tintColor.CGColor);
	CGContextStrokeEllipseInRect(context, rectToDraw);
	
	// Fill inner part
	CGRect innerRect = CGRectInset(rectToDraw,1, 1);
	CGContextSetFillColorWithColor(context, kInnerColor.CGColor);
	CGContextFillEllipseInRect(context, innerRect);
	
	if(self.selected == NO)
		return;
	
	// For selected View
	CGRect smallerRect = CGRectInset(rectToDraw,10, 10);
	CGContextSetFillColorWithColor(context, kHighlightColor.CGColor);
	CGContextFillEllipseInRect(context, smallerRect);
}

- (void)highlightCell
{
	self.selected = YES;
	[self setNeedsDisplay];
}

- (void)resetCell
{
	self.selected = NO;
	[self setNeedsDisplay];
}


@end
