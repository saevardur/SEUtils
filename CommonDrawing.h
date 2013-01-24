//
//  CommonDrawing.h
//  alfred
//
//  Created by Sævarður Einarsson on 1/8/13.
//  Copyright (c) 2013 Stokkur Software ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonDrawing : NSObject

CGRect rectFor1PxStroke(CGRect rect);

CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius);

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor);

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);

@end
