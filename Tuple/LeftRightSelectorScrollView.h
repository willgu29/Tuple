//
//  LeftRightSelectorScrollView.h
//  PictureApp
//
//  Created by William Gu on 6/18/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftRightSelectorScrollView : UIScrollView

-(void)setTextToDisplayArray:(NSArray *)textToDisplay;
-(CGSize)calculateContentSize;
-(int)getCurrentPage;

@end
