//
//  PPLockView.m
//  GestureLock
//
//  Created by 王鹏 on 12-9-28.
//  Copyright (c) 2012年 pengjay.cn@gmail.com. All rights reserved.
//

#import "PPLockView.h"

#define startY 50
#define startX 35
#define PaddingX 35
#define PaddingY 35
#define Width 60
#define Height 60
static CGPoint lockPos[9] = {{startX, startY},{startX + Width + PaddingX, startY},{startX + Width*2 + PaddingX*2, startY},{startX, startY+Height+PaddingY},{startX + Width + PaddingX, startY+Height+PaddingY},{startX + Width*2 + PaddingX*2, startY+Height+PaddingY},{startX, startY+Height*2+PaddingY*2},{startX + Width + PaddingX, startY+Height*2+PaddingY*2},{startX + Width*2 + PaddingX*2, startY+Height*2+PaddingY*2}};

@implementation PPLockView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		UIImage *bgImage = [UIImage imageNamed:@"wallpaper_bg.png"];
		self.backgroundColor = [UIColor colorWithPatternImage:bgImage];
		
		_selectedPointArray = [[NSMutableArray alloc]init];
		_passwd = [[NSMutableString alloc]init];
    }
    return self;
}

- (void)dealloc
{
	[_selectedPointArray release];
	_selectedPointArray = nil;
	
	[_passwd release];
	_passwd = nil;
	[super dealloc];
}


- (CGPathRef)linePathStartAt:(CGPoint)startPoint End:(CGPoint)endPoint With:(CGFloat)lineWidth
{
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, nil, startPoint.x, startPoint.y);
	CGPathAddLineToPoint(path, nil, endPoint.x, endPoint.y);
	CGPathCloseSubpath(path);
	return path;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	currentPoint = [touch locationInView:self];
	
	for (int i = 0; i < 9; i++) {
		CGPoint p = lockPos[i];
		CGRect rect = CGRectMake(p.x, p.y, Width, Height);
		if(CGRectContainsPoint(rect, currentPoint))
		{
			CGPoint ap = CGPointMake(p.x+Width/2, p.y+Height/2);
			NSString *curstr = NSStringFromCGPoint(ap);
			if(![_selectedPointArray containsObject:curstr])
			{
				[_selectedPointArray addObject:curstr];
				[_passwd appendFormat:@"%d", i];
			}
		}
	}
	
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if([_passwd length] > 0 && [_delegate respondsToSelector:@selector(lockViewUnlockWithPasswd:)])
	{
		[_delegate lockViewUnlockWithPasswd:_passwd];
		
	}
	NSLog(@"%@", _passwd);
	[_selectedPointArray removeAllObjects];
	[_passwd setString:@""];
	[self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 3.0f);
	CGContextSetStrokeColorWithColor(context, [[UIColor yellowColor] CGColor]);
	CGContextSetLineJoin(context, kCGLineJoinRound);
	if ([_selectedPointArray count] > 0)
	{
		int i = 0;
		for (NSString *posstr in _selectedPointArray)
		{
			CGPoint p = CGPointFromString(posstr);
			if (i == 0)
			{
				CGContextMoveToPoint(context, p.x, p.y);
			}
			else
			{
				CGContextAddLineToPoint(context, p.x, p.y);
			}
			
			i++;
		}
		
		CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
		CGContextStrokePath(context);


	}
	
	for (int i = 0; i < 9; i++) {
		CGPoint p = lockPos[i];
		
		CGPoint ap = CGPointMake(p.x+Width/2, p.y+Height/2);
		NSString *curstr = NSStringFromCGPoint(ap);
		if(![_selectedPointArray containsObject:curstr])
		{
			UIImage *img = [UIImage imageNamed:@"lock_btn_none.png"];
			[img drawAtPoint:CGPointMake(p.x, p.y)];
		}
		else
		{
			UIImage *img = [UIImage imageNamed:@"lock_btn_sel.png"];
			[img drawAtPoint:CGPointMake(p.x, p.y)];

		}
		
	}
}


@end
