//
//  LeftRightSelectorScrollView.m
//  PictureApp
//
//  Created by William Gu on 6/18/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import "LeftRightSelectorScrollView.h"

@interface LeftRightSelectorScrollView()
{
    CGFloat maximumZoomScale;
    CGFloat minimumZoomScale;
}

@property (nonatomic, strong) NSArray *textToDisplay;

@end

@implementation LeftRightSelectorScrollView

-(void)setTextToDisplayArray:(NSArray *)textToDisplay
{
    _textToDisplay = textToDisplay;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        self.contentSize = CGSizeMake(self.contentSize.width,self.frame.size.height);
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self hideScrollIndicators];
        
    }
    return self;
}
-(int)getCurrentPage
{
    int page = self.contentOffset.x / self.frame.size.width;
    return page;
}

-(void)hideScrollIndicators
{
    [self setShowsHorizontalScrollIndicator:NO];
    [self setShowsVerticalScrollIndicator:NO];
}

-(void)getContextSizeWidth
{
    
}

-(void)lockZoom
{
    maximumZoomScale = self.maximumZoomScale;
    minimumZoomScale = self.minimumZoomScale;
    
    self.maximumZoomScale = 1.0;
    self.minimumZoomScale = 1.0;
}

-(void)unlockZoom
{
    
    self.maximumZoomScale = maximumZoomScale;
    self.minimumZoomScale = minimumZoomScale;
    
}
-(CGSize)calculateContentSize
{
    CGFloat width = [_textToDisplay count]*320;
    CGFloat height = self.bounds.size.height;
    return CGSizeMake(width, height);
}
-(CGPoint)getCenterPoint:(UIView *)view
{
    CGFloat centerX = self.bounds.size.width/2 - view.bounds.size.width/2;
    CGFloat centerY = self.bounds.size.height/2 - view.bounds.size.height/2;
    return CGPointMake(centerX, centerY);
}

-(void)addArrayTextToView
{
    for (int i = 0; i < [_textToDisplay count]; i++)
    {
        NSString *text = [_textToDisplay objectAtIndex:i];
        CGSize dimensions = [self getDimensionsOfString:text];
        UILabel *label = [[UILabel alloc] init];
        label.text = text;
        [label sizeToFit];
        CGPoint centerPoint = [self getCenterPoint:label];
        CGRect frame =  CGRectMake((i*320)+centerPoint.x, centerPoint.y, dimensions.width, dimensions.height);
        label.frame = frame;
        [self addSubview:label];
    }
}

-(CGSize)getDimensionsOfString:(NSString *)string
{
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:17.0f]};
    CGSize size = [string sizeWithAttributes:attributes];
    
    return size;
}

@end
