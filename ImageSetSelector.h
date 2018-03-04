//
//  ImageSetSelector.h
//  NevitColorizer
//
//  Created by Serdar Coskun on 07/12/2017.
//

#import <Cocoa/Cocoa.h>
#import <OsiriXAPI/DicomSeries.h>
#import <OsiriXAPI/DicomImage.h>

#import "DCMObject.h"
#import "DCMAttribute.h"
#import "DCMAttributeTag.h"
@protocol ImageSetSelectorDelegate

@required
- (void)didSelectRedChannel:(DicomSeries*)redSeries
               greenChannel:(DicomSeries*)greenSeries
                blueChannel:(DicomSeries*)blueSeries;

@end

@interface ImageSetSelector : NSWindowController

@property (strong) id<ImageSetSelectorDelegate> delegate;

-(instancetype)initWithSeriesArray:(NSArray<DicomSeries*>*)seriesArray;

@end
