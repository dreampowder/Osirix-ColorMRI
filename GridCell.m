//
//  GridCell.m
//  JNWCollectionViewDemo
//
//  Created by Jonathan Willing on 4/15/13.
//  Copyright (c) 2013 AppJon. All rights reserved.
//

#import "GridCell.h"

@implementation GridCell

- (void)setImage:(NSImage *)image {
	_image = image;
	self.backgroundImage = image;
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
}

@end
