//
//  ImageItem.h
//  ColorMRI
//
//  Created by Serdar Coskun on 09/03/2018.
//

#import <Cocoa/Cocoa.h>

@interface ImageItem : NSCollectionViewItem

@property (nonatomic, strong) IBOutlet NSView* colorOverlayView;
@property (nonatomic, strong) NSColor* cellColor;

- (void)setOverlayColor:(NSColor*)color;
- (void)toggleOverlayView:(BOOL)enabled;
@end
