//
//  PathIntersectionLabView.m
//  PathIntersectionLab
/*
 
 .  /\/\/\__/\/\/\   .   Copyright (c)2013 Tristan Leblanc                .
 .  \/\/\/..\/\/\/   .   MooseFactory Software                            .
 .       |  |        .   tristan@moosefactory.eu                          .
 .       (oo)        .                                                    .
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "PathIntersectionLabView.h"
#import "MFBezierPathCollider.h"

@implementation PathIntersectionLabView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [intersectsImage setHidden:YES];
    }
    
    return self;
}

-(void)awakeFromNib
{
    [self roll:NULL];
}

-(CGFloat)floatRandom:(CGFloat)range
{
    return (CGFloat)(random()%(long)range);
}

-(CGPathRef)randomPath;
{
    CGFloat w = self.bounds.size.width/4;
    CGFloat h = self.bounds.size.height/4;
    
    int n = rand()%10;
    
    
    CGFloat dx = self.bounds.size.width - w;
    CGFloat dy = self.bounds.size.height - h;

    dx = [self floatRandom:dx];
    dy = [self floatRandom:dy];
    
    NSPoint   points[n];

    for (int i=0;i<n;i++) {
        CGFloat x = [self floatRandom:w]+ dx;
        CGFloat y = [self floatRandom:h]+ dy;
        points[i] = NSMakePoint(x,y);
    }
    
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathMoveToPoint(newPath, NULL, points[0].x, points[0].y);
    for (int i =1;i<n;i++) {
        CGPathAddLineToPoint(newPath, NULL, points[i].x, points[i].y);
    }
    CGPathCloseSubpath(newPath);
        
    return newPath;
}

-(CGPathRef)pathAddedToPath:(CGPathRef)pathRef path:(CGPathRef)pathRefToAdd
{
    CGMutablePathRef newPath = CGPathCreateMutableCopy(pathRef);

    CGPathAddPath(newPath,NULL, pathRefToAdd);
    
    return newPath;
}

- (void)drawRect:(NSRect)dirtyRect
{
    
    if (!pathCollider) pathCollider = [[MFBezierPathCollider alloc] initWithView:self];
    else [pathCollider attachToView:self]; // This does nothing if view size has not changed
 
    BOOL intersects = [pathCollider pathIntersectPath:path1 versus:path2];
    
    CGContextRef    ctx = [[NSGraphicsContext currentContext] graphicsPort];
    
    [self drawPolysInContext:ctx];
    
    [intersectsImage setHidden:!intersects];
    
}


-(void)drawPolysInContext:(CGContextRef)ctx
{
    CGContextSetStrokeColorSpace(ctx,CGColorSpaceCreateDeviceRGB());
    CGContextSetFillColorSpace(ctx,CGColorSpaceCreateDeviceRGB());
    CGFloat color1[] = {0.8,0.0,0.0,0.7};
    CGFloat color2[] = {0.0,0.0,0.8,0.7};
    
     CGContextSetStrokeColor(ctx, color1);
     CGContextAddPath(ctx, path1);
     CGContextStrokePath(ctx);
     
     CGContextSetStrokeColor(ctx, color2);
     CGContextAddPath(ctx, path2);
     CGContextStrokePath(ctx);
}


-(IBAction)roll:(id)sender
{
    [intersectsImage setHidden:YES];
    path1 = [self randomPath];
    path2 = [self randomPath];
    [self setNeedsDisplay:YES];
}



@end
