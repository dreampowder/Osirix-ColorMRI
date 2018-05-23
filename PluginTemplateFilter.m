//
//  PluginTemplateFilter.m
//  PluginTemplate
//
//  Copyright (c) CURRENT_YEAR YOUR_NAME. All rights reserved.
//

#import "PluginTemplateFilter.h"
#import "ImageSetSelector.h"
#import <OsiriXAPI/SeriesView.h>
#import <OsiriXAPI/DICOMExport.h>
#import <OsiriXAPI/BrowserController.h>

@interface PluginTemplateFilter()<ImageSetSelectorDelegate>
@property (strong) ImageSetSelector* windowImageSelector;
@property (assign) BOOL hasErrors;
@end
@implementation PluginTemplateFilter


- (void) initPlugin
{
    
}

- (long) filterImage:(NSString*) menuName
{
    
    
    
    //    ViewerController    *new2DViewer;
    //    new2DViewer = [self duplicateCurrent2DViewerWindow];
    _hasErrors = NO;
    NSMutableArray<DicomSeries*>* seriesArray = @[].mutableCopy;
    
    BrowserController *currentBrowser = [BrowserController currentBrowser];
    NSArray *selectedItems = [currentBrowser databaseSelection];
    for (id item in selectedItems) {
        if ([item isKindOfClass:[DicomStudy class]]) {
            NSArray* listOfSeries = [(DicomStudy*)item imageSeries];
            [seriesArray addObjectsFromArray:listOfSeries];
        }
    }
    
    self.windowImageSelector = [[ImageSetSelector alloc] initWithSeriesArray:seriesArray.copy];
    self.windowImageSelector.delegate = self;
    [self.viewerWindow.window beginSheet:self.windowImageSelector.window completionHandler:nil];
    return 0;
}

//- (long) filterImage:(NSString*) menuName
//{
//
//    NSArray *pixList = [viewerController pixList: 0];
//    int curSlice = [[viewerController imageView] curImage];
//    DCMPix *curPix = [pixList objectAtIndex: curSlice];
//
//    // Number of Pixels
//    int curPos = [curPix pheight] * [curPix pwidth];
//
//    if( [curPix isRGB]) {
//
//        // get pointer to the first pixel of the image
//        unsigned char *rgbImage = (unsigned char*) [curPix fImage];
//
//        while ( curPos--> 0 )
//        {
//
//            // Reading Pixel
//            short RedValue = rgbImage[curPos*4 +1];
//            short GreenValue = rgbImage[curPos*4 +2];
//            short BlueValue = rgbImage[curPos*4 +3];
//
//            // Writing Pixel
//            rgbImage[curPos*4 +1] = RedValue;
//            rgbImage[curPos*4 +2] = GreenValue;
//            rgbImage[curPos*4 +3] = BlueValue;
//
//        }
//    } else {
//
//        // get pointer to the first pixel of the image
//        float *fImage = [curPix fImage];
//
//        while ( curPos--> 0 )
//        {
//            float GreyValue;
//
//            // Reading Pixel
//            GreyValue = fImage[curPos];
//
//            // Writing Pixel
//            fImage[curPos] = GreyValue;
//
//        }
//    }
//
//    // if you've changed pixel values,
//    // don't forget to update the display
//    [viewerController needsDisplayUpdate];
//
//    return 0;
//}
//
//- (long) filterImage:(NSString*) menuName
//{
//
//    _viewerWindow = [self duplicateCurrent2DViewerWindow];
//    for (id file in _viewerWindow.roiList) {
//        NSRunInformationalAlertPanel(@"Welcome!", [NSString stringWithFormat:@"File: %@",file], @"OK", 0L, 0L);
//    }
//
//
//    NSMutableArray* vcArray = [ViewerController getDisplayed2DViewers];
//
//    ViewerController* vc1 = [vcArray objectAtIndex:0];
//    ViewerController* vc2 = [vcArray objectAtIndex:1];
//    ViewerController* vc3 = [vcArray objectAtIndex:2];
//
//    NSArray *pixList = [viewerController pixList: 0];
//    int curSlice = [[viewerController imageView] curImage];
//
//    DCMPix *curPix = [pixList objectAtIndex: curSlice];
//    NSRunInformationalAlertPanel(@"Welcome!", [NSString stringWithFormat:@"Cırpic Name: %@ ",curPix.generatedName], @"OK", 0L, 0L);
//
//    NSArray *pixList1 = [vc1 pixList: 0];
//    NSArray *pixList2 = [vc2 pixList: 0];
//    NSArray *pixList3 = [vc3 pixList: 0];
//
//    DCMPix *curPix1 = [pixList1 objectAtIndex: curSlice];
//    DCMPix *curPix2 = [pixList2 objectAtIndex: curSlice];
//    DCMPix *curPix3 = [pixList3 objectAtIndex: curSlice];
//
//    [curPix ConvertToRGB:3 :curPix.wl :curPix.ww];
//
//    [curPix1 ConvertToRGB:3 :curPix1.wl :curPix1.ww];
//    [curPix2 ConvertToRGB:3 :curPix2.wl :curPix2.ww];
//    [curPix3 ConvertToRGB:3 :curPix3.wl :curPix3.ww];
//
//    if( [curPix isRGB]) {
//
//        // get pointer to the first pixel of the image
//        unsigned char *rgbImage = (unsigned char*) [curPix fImage];
//
//        unsigned char *rgbImage1 = (unsigned char*) [curPix1 fImage];
//        unsigned char *rgbImage2 = (unsigned char*) [curPix2 fImage];
//        unsigned char *rgbImage3 = (unsigned char*) [curPix3 fImage];
//
//        for (int x = 0; x < [curPix pwidth]; x++)
//            for (int y = 0; y < [curPix pheight]; y++)
//            {
//
//                long curPos = y * [curPix pwidth] + x;
//
//                // Reading Pixels
//                short RedValue = rgbImage1[curPos*4 +1];
//                short GreenValue = rgbImage2[curPos*4 +2];
//                short BlueValue = rgbImage3[curPos*4 +3];
//
//                // Writing Pixels
//                rgbImage[curPos*4 +1] = RedValue;
//                rgbImage[curPos*4 +2] = GreenValue;
//                rgbImage[curPos*4 +3] = BlueValue;
//            }
//
//    } else {
//
//        // get pointer to the first pixel of the image
//        float *fImage = [curPix fImage];
//        for (int x = 0; x < [curPix pwidth] / 2; x++)
//            for (int y = 0; y < [curPix pheight] / 2; y++)
//            {
//
//                int curPos = y * [curPix pwidth] + x;
//
//                // Reading Pixel
//                float GreyValue = fImage[curPos];
//
//                // Writing Pixel
//                fImage[curPos] = 255.0f;
//            }
//
//    }
//
//    // if you've changed pixel values,
//    // don't forget to update the display
//    [viewerController needsDisplayUpdate];
//
//    return 0;
//}
//
//- (void)mergeImagesWithRedChannelImage:(DCMPix*)redChannel
//                     greenChannelImage:(DCMPix*)greenChannel
//                      blueChannelImage:(DCMPix*)bluecChannel{
//
//}

- (void)generateRGBSetWithRedChannel:(DicomSeries*)redSeries
                     andGreenChannel:(DicomSeries*)greenSeries
                      andBlueChannel:(DicomSeries*)blueSeries
                      isReverseOrder:(BOOL)isReverseOrder{
    
    [[BrowserController currentBrowser] databaseOpenStudy:redSeries];
    ViewerController* newViewerController = nil;
    for (ViewerController* vc in [ViewerController getDisplayed2DViewers]) {
        if ([vc.imageView.seriesObj.name isEqualToString:redSeries.name]) {
            newViewerController = vc;
            NSLog(@"Set ViewerWindow");
        }
        [vc setImageIndex:0];
    }
    NSArray *pixList = [newViewerController pixList];
    NSArray* sortedRed = redSeries.sortedImages;
    NSArray* sortedGreen = greenSeries.sortedImages;
    NSArray* sortedBlue = blueSeries.sortedImages;
    
    @autoreleasepool{
        for (int i = 0;i<pixList.count;i++) {
            NSInteger currentIndex = i;
            [newViewerController setImageIndex:i];
//            int curSlice = [[newViewerController imageView] curImage];
            NSInteger curSlice = (!isReverseOrder)?i:(pixList.count-i-1);
            NSLog(@"curSlice: %li,curIndex: %li, redCount: %li, blueCount:%li, greenCount: %li",curSlice,currentIndex,sortedRed.count,sortedBlue.count,sortedGreen.count);
            DCMPix *curPix = [pixList objectAtIndex:i];
            [self convertPixToRGB:curPix Red:sortedRed[curSlice] Green:sortedGreen[curSlice] Blue:sortedBlue[curSlice]];
            [newViewerController needsDisplayUpdate];
        }
    }
    
    [newViewerController becomeFirstResponder];
    [self pressFullDynamicButton];
    if(_hasErrors){
        _hasErrors = NO;
        NSRunInformationalAlertPanel(@"Compose Image", @"We have encountered some problems while composing the image. The result image may look corrupted.", @"Ok", 0L, 0L);
    }
    
}

- (unsigned char*)convertPixToRGB:(DCMPix*)currentPix
                     Red:(DicomImage*)redImg
                   Green:(DicomImage*)greenImg
                    Blue:(DicomImage*)blueImg{
    
    
    [currentPix ConvertToRGB:3 :currentPix.wl :currentPix.ww];
    
    DCMPix* redPix = [DCMPix dcmPixWithImageObj:redImg];
    [redPix ConvertToRGB:0 :redPix.wl :redPix.ww];
    
    DCMPix* greenPix = [DCMPix dcmPixWithImageObj:greenImg];
    [greenPix ConvertToRGB:1 :greenPix.wl :greenPix.ww];
    
    DCMPix* bluePix = [DCMPix dcmPixWithImageObj:blueImg];
    [bluePix ConvertToRGB:2 :bluePix.wl :bluePix.ww];
    
    
    
    NSLog(@"current: %ld-%ld\n\n\nred: %ld-%ld\n\n\ngreen: %ld-%ld\n\n\nblur:%ld-%ld",currentPix.pwidth,currentPix.pheight,redPix.pwidth,redPix.pwidth,greenPix.pheight,greenPix.pwidth,bluePix.pheight,bluePix.pwidth);
    unsigned char *rgbImage = (unsigned char*) [currentPix fImage];
    unsigned char *redImage = (unsigned char*) [redPix fImage];
    unsigned char *greenImage = (unsigned char*) [greenPix fImage];
    unsigned char *blueImage = (unsigned char*) [bluePix fImage];
    
    for (int x = 0; x < [currentPix pwidth]; x++){
        for (int y = 0; y < [currentPix pheight]; y++)
        {
            long curPos = y * [currentPix pwidth] + x;
            // Reading Pixels
                short redValue = redImage[curPos*4 +1];
                short greenValue = greenImage[curPos*4 +2];
                short blueValue = blueImage[curPos*4 +3];
//            short redValue = [self getValueForFImage:redImage length:redPix.pwidth*redPix.pheight*4 forPosition:(curPos*4 +1) defaultFImage:rgbImage];
//            short greenValue = [self getValueForFImage:greenImage length:greenPix.pwidth*greenPix.pheight*4 forPosition:(curPos*4 +2) defaultFImage:rgbImage];
//            short blueValue = [self getValueForFImage:blueImage length:bluePix.pwidth*bluePix.pheight*40 forPosition:(curPos*4 +3) defaultFImage:rgbImage];
            
            // Writing Pixels
            rgbImage[curPos*4 +1] = redValue;
            rgbImage[curPos*4 +2] = greenValue;
            rgbImage[curPos*4 +3] = blueValue;
        }
    }
    
    //We return the original image if we encounter any problems
    rgbImage = (unsigned char*) [currentPix fImage];
    return rgbImage;
}

//In some cases position gathered from the main image might be greater than the position found in the target image, which couses crash. So if the position is greater than the length, we return the default value (grayscale pixel from the original source)
- (short)getValueForFImage:(unsigned char*)fImage length:(long)length forPosition:(long)position defaultFImage:(unsigned char*)defautImage{
    if (length>position) {
        return fImage[position];
    }else{
        _hasErrors = YES;
        return defautImage[position];
    }
}

//The easiest way to accomplist zero key press is to send default "0" keypress to the system for "Full Dynamic"
- (void)pressFullDynamicButton{
    NSLog(@"Pressing Zero!");
    //Apply Full Dynamic WL/WW to the window by pressing default "0" button for this event
    CGEventSourceRef src =
    CGEventSourceCreate(kCGEventSourceStateHIDSystemState);
    CGEventRef cmdd = CGEventCreateKeyboardEvent(src, (CGKeyCode)0x1D, true);
    CGEventRef cmdu = CGEventCreateKeyboardEvent(src, (CGKeyCode)0x1D, false);
    CGEventTapLocation loc = kCGHIDEventTap; // kCGSessionEventTap also works
    CGEventPost(loc, cmdd);
    CGEventPost(loc, cmdu);
    CFRelease(cmdd);
    CFRelease(cmdu);
    //Pressed down and up to "0" key (keycode 29)
}

#pragma mark <ImageSetSelectorDelegate>

- (void)didSelectRedChannel:(DicomSeries *)redSeries greenChannel:(DicomSeries *)greenSeries blueChannel:(DicomSeries *)blueSeries isReverseOrder:(BOOL)isReverseOrder{
    if (self.windowImageSelector){
        [self.windowImageSelector close];
    }
    [self generateRGBSetWithRedChannel:redSeries andGreenChannel:greenSeries andBlueChannel:blueSeries isReverseOrder:isReverseOrder];
}


@end
