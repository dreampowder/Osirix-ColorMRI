//
//  ImageSetSelector.m
//  ColorMRI
//
//  Created by Serdar Coskun on 07/12/2017.
//

#import "ImageSetSelector.h"
#import <Accelerate/Accelerate.h>
#import <PXSourceList.h>
#import "ImageItem.h"
#import "AspectFillImageView.h"

@interface ImageSetSelector ()<PXSourceListDelegate,PXSourceListDataSource,NSCollectionViewDelegate,NSCollectionViewDataSource>

@property (strong) IBOutlet NSImageView* imgRed;
@property (strong) IBOutlet NSImageView* imgGreen;
@property (strong) IBOutlet NSImageView* imgBlue;
@property (strong) IBOutlet AspectFillImageView* imgSample;

//@property (strong) IBOutlet NSPopUpButton* btnRed;
//@property (strong) IBOutlet NSPopUpButton* btnGreen;
//@property (strong) IBOutlet NSPopUpButton* btnBlue;

@property (strong) IBOutlet NSCollectionView* collRed;
@property (strong) IBOutlet NSCollectionView* collGreen;
@property (strong) IBOutlet NSCollectionView* collBlue;

@property (strong) IBOutlet NSButton* btnSelectSet;
@property (strong) IBOutlet NSButton* btnApplyColors;

@property (strong) IBOutlet PXSourceList* outlineView;
- (IBAction)didClickDoneButton:(id)sender;

@property (strong) NSArray<DicomSeries*>* seriesArray;
@property (strong) NSMutableDictionary<NSString*,NSMutableArray<DicomSeries*>*>* seriesMap;
@property (strong) NSArray* sortedKeyArray;


@property (strong) DicomSeries* redSeries;
@property (strong) DicomSeries* greenSeries;
@property (strong) DicomSeries* blueSeries;

@property (strong) ImageItem* itemPrototype;

@end

@implementation ImageSetSelector

-(instancetype)initWithSeriesArray:(NSArray<DicomSeries*>*)seriesArray{
    self = [super initWithWindowNibName:@"ImageSetSelector"];
    if (self) {
        self.seriesArray = seriesArray;
        NSMutableDictionary<NSString*,NSMutableArray<DicomSeries*>*>* tempMap =@{}.mutableCopy;
        for(DicomSeries* series in  seriesArray){
            DicomImage* image = series.sortedImages.firstObject;
//            NSLog(@"IMAGE LOCATION: %@",image.);
//            NSString* key = [NSString stringWithFormat:@"R:%li Num:%li-res:%f-%f",series.rotationAngle.integerValue,series.numberOfImages.integerValue,image.width.doubleValue,image.height.doubleValue];
            DCMObject* dicomObject = [DCMObject objectWithContentsOfFile:image.completePath decodingPixelData:false];
            DCMAttributeTag* pOrientationTag = [DCMAttributeTag tagWithName:@"ImageOrientationPatient"];
            DCMAttributeTag* pImagePosition = [DCMAttributeTag tagWithName:@"ImagePositionPatient"];
            
            NSString* orientation = [[dicomObject attributeForTag:pOrientationTag] value];
            NSString* position = [[dicomObject attributeForTag:pImagePosition] value];
            
            NSLog(@">>>>> Orientation : %@, position: %@",orientation,position);
            if (orientation&&position){ //These values must be present, if not, don't add them to the list.
                NSString* key = [NSString stringWithFormat:@"Loc:%@ - Pos:%@ - Ori:%@ - num:%@",image.sliceLocation,position,orientation,series.numberOfImages];
                if(![tempMap.allKeys containsObject:key]){
                    [tempMap setObject:@[series].mutableCopy forKey:key];
                }else{
                    [[tempMap objectForKey:key] addObject:series];
                }
            }
        }
        self.seriesMap = @{}.mutableCopy;
        int counter = 0;
        
        for (NSString* key in tempMap.allKeys) {
            NSMutableArray* array = tempMap[key];
            if (array.count>=2) {
                counter++;
                [_seriesMap setObject:array forKey:[NSString stringWithFormat:@"Group - %i",counter]];
            }
        }
        self.sortedKeyArray = [_seriesMap.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1,NSString* obj2) {
            return [obj1 compare:obj2];
        }];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    self.outlineView.dataSource = self;
    self.outlineView.delegate = self;
    if (_seriesMap.allKeys.count==0) {
        NSRunInformationalAlertPanel(@"Image Set Selector", @"There are no compatible image sets available in this study. You need at least 2 or 3 series with same slice location and same FOV. See documentation for more info.", @"Ok", 0L, 0L);
        [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
    }
    
    self.itemPrototype = [ImageItem new];
    [self setupCollectionView:self.collRed];
    [self setupCollectionView:self.collGreen];
    [self setupCollectionView:self.collBlue];
    
}

- (void)setupCollectionView:(NSCollectionView*)collectionView{
    //NSCollectionViewFlowLayout* layout = [[NSCollectionViewFlowLayout alloc] init];
    //layout.scrollDirection = NSCollectionViewScrollDirectionHorizontal;
    //layout.itemSize = CGSizeMake(CGRectGetHeight(collectionView.bounds), CGRectGetHeight(collectionView.bounds));
    //layout.minimumInteritemSpacing = 8.0f;
    //[collectionView setCollectionViewLayout:layout];
    
//    collectionView.delegate = self;
//    collectionView.dataSource = self;
//    [collectionView setSelectable:YES];
//    [collectionView setItemPrototype:self.itemPrototype];
}

- (void)initializeImageSeries {
    
    if (!self.seriesArray) {
        NSRunInformationalAlertPanel(@"Select Image Set", @"You must select an imageset from the menu on left", @"Ok", 0L, 0L);
    }else{
        DicomSeries* series1 = self.seriesArray[0];
        DicomSeries* series2 = self.seriesArray[1];
        DicomSeries* series3 = self.seriesArray[self.seriesArray.count>2?2:1];
        
        self.redSeries = series1;
        self.greenSeries = series2;
        self.blueSeries = series3;
        
        
        [self.imgRed setImage:self.redSeries.thumbnailImage];
        [self.imgGreen setImage:self.greenSeries.thumbnailImage];
        [self.imgBlue setImage:self.blueSeries.thumbnailImage];
        
        [self.imgRed setNeedsLayout:YES];
        [self.imgGreen setNeedsLayout:YES];
        [self.imgBlue setNeedsLayout:YES];
        
        [self generateSampleImage];
        
        NSLog(@"R: %@, G:%@, B: %@",series1.name,series2.name,series3.name);
        
        [_outlineView reloadData];

        NSMutableArray* contentArray = @[].mutableCopy;
        for (DicomSeries* series in self.seriesArray) {
            [contentArray addObject:@{@"image":series.thumbnail,@"title":series.name}];
        }
        NSLog(@"Content: %@",contentArray);
        [_collRed setContent:contentArray];
        [_collBlue setContent:contentArray];
        [_collGreen setContent:contentArray];
    }
}

- (DicomSeries*)selectSeriesWithName:(NSString*)name{
    for (DicomSeries* series in self.seriesArray) {
        NSString* seriesName = [NSString stringWithFormat:@"%@ (%li images)",series.name,series.images.count];
        if ([seriesName isEqualToString:name]) {
            return series;
        }
    }
    return nil;
}

- (void)generateSampleImage{
    DicomSeries* series1 = self.redSeries;
    DicomSeries* series2 = self.greenSeries;
    DicomSeries* series3 = self.blueSeries;
    
    NSData* redChannel = [self channelDataFromImage:series1.thumbnailImage];
    NSData* greenChannel = [self channelDataFromImage:series2.thumbnailImage];
    NSData* blueChannel = [self channelDataFromImage:series3.thumbnailImage];
    
    self.imgSample.image = [self newImageWithSize:series1.thumbnailImage.size fromRedChannel:redChannel greenChannel:greenChannel blueChannel:blueChannel];
    [self.outlineView reloadData];
//    [_collRed reloadData];
//    [_collGreen reloadData];
//    [_collBlue reloadData];
}

- (NSImage*)newImageWithSize:(CGSize)size fromRedChannel:(NSData*)redImageData greenChannel:(NSData*)greenImageData blueChannel:(NSData*)blueImageData
{
    vImage_Buffer redBuffer;
    redBuffer.data = (void*)redImageData.bytes;
    redBuffer.width = size.width;
    redBuffer.height = size.height;
    redBuffer.rowBytes = [redImageData length]/size.height;
    
    vImage_Buffer greenBuffer;
    greenBuffer.data = (void*)greenImageData.bytes;
    greenBuffer.width = size.width;
    greenBuffer.height = size.height;
    greenBuffer.rowBytes = [greenImageData length]/size.height;
    
    vImage_Buffer blueBuffer;
    blueBuffer.data = (void*)blueImageData.bytes;
    blueBuffer.width = size.width;
    blueBuffer.height = size.height;
    blueBuffer.rowBytes = [blueImageData length]/size.height;
    
    size_t destinationImageBytesLength = size.width*size.height*3;
    const void* destinationImageBytes = valloc(destinationImageBytesLength);
    NSData* destinationImageData = [[NSData alloc] initWithBytes:destinationImageBytes length:destinationImageBytesLength];
    vImage_Buffer destinationBuffer;
    destinationBuffer.data = (void*)destinationImageData.bytes;
    destinationBuffer.width = size.width;
    destinationBuffer.height = size.height;
    destinationBuffer.rowBytes = [destinationImageData length]/size.height;
    
    vImage_Error result = vImageConvert_Planar8toRGB888(&redBuffer, &greenBuffer, &blueBuffer, &destinationBuffer, 0);
    NSImage* image = nil;
    if(result == kvImageNoError)
    {
        //TODO: If you need color matching, use an appropriate colorspace here
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)(destinationImageData));
        CGImageRef finalImageRef = CGImageCreate(size.width, size.height, 8, 24, destinationBuffer.rowBytes, colorSpace, kCGBitmapByteOrder32Big|kCGImageAlphaNone, dataProvider, NULL, NO, kCGRenderingIntentDefault);
        CGColorSpaceRelease(colorSpace);
        CGDataProviderRelease(dataProvider);
        image = [[NSImage alloc] initWithCGImage:finalImageRef size:NSMakeSize(size.width, size.height)];
        CGImageRelease(finalImageRef);
    }
    free((void*)destinationImageBytes);
    return image;
}

- (NSData*)channelDataFromImage:(NSImage*)sourceImage
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)[sourceImage TIFFRepresentation], NULL);
    if(imageSource == NULL){return NULL;}
    CGImageRef image = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    CFRelease(imageSource);
    if(image == NULL){return NULL;}
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image);
    CGFloat width = CGImageGetWidth(image);
    CGFloat height = CGImageGetHeight(image);
    size_t bytesPerRow = CGImageGetBytesPerRow(image);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(image);
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, colorSpace, bitmapInfo);
    NSData* data = NULL;
    if(NULL != bitmapContext)
    {
        CGContextDrawImage(bitmapContext, CGRectMake(0.0, 0.0, width, height), image);
        CGImageRef imageRef = CGBitmapContextCreateImage(bitmapContext);
        if(NULL != imageRef)
        {
            data = (NSData*)CFBridgingRelease(CGDataProviderCopyData(CGImageGetDataProvider(imageRef)));
        }
        CGImageRelease(imageRef);
        CGContextRelease(bitmapContext);
    }
    CGImageRelease(image);
    return data;
}

- (IBAction)didClickDoneButton:(id)sender{
    
    [self.delegate didSelectRedChannel:self.redSeries greenChannel:self.greenSeries blueChannel:self.blueSeries];
    [self.window.sheetParent endSheet:self.window returnCode:NSModalResponseOK];
    
}

#pragma mark - <NSOutlineViewDelegate, NSOutlineViewDataSource>

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item{
    if (!item) {
        return _seriesMap.allKeys.count;
    }else if ([[item class] isSubclassOfClass:[NSMutableArray class]]){
        NSMutableArray* array = (NSMutableArray*)item;
        NSLog(@"NumChild Array: %li",array.count);
        return array.count;
    }else{
        NSLog(@"NumChild Else: %@",[item className]);
        return 0;
    }
}
- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item{
    if (!item) {
//        NSString* key = _seriesMap.allKeys[index];
        NSString* key = _sortedKeyArray[index];
        return _seriesMap[key]; //Return Array
    }else if ([[item class] isSubclassOfClass:[NSMutableArray class]]){
        NSMutableArray* array = (NSMutableArray*)item;
        return array[index]; //Return DicomSeries
    }else{
        return nil;
    }
}
- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item{
    return ![[item class] isSubclassOfClass:[DicomSeries class]];
}

- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item{
    if ([[item class] isSubclassOfClass:[NSMutableArray class]]) {
        for(NSString* key in _seriesMap.allKeys){
            if ([_seriesMap[key] isEqual:item]) {
                return key;
            }
        }
        return @"not found";
    }else if([[item class] isSubclassOfClass:[DicomSeries class]]){
        DicomSeries* series = (DicomSeries*)item;
        return series.name;
    }else{
        return nil;
    }
}

- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasBadge:(id)item
{
    return YES;
}

- (NSInteger)sourceList:(PXSourceList*)aSourceList badgeValueForItem:(id)item
{
    if ([[item class] isSubclassOfClass:[DicomSeries class]]) {
        DicomSeries* series = (DicomSeries*)item;
        return series.numberOfImages.integerValue;
    }else{
        NSMutableArray* array = (NSMutableArray*)item;
        return array.count;
    }
}

- (NSColor*)sourceList:(PXSourceList*)aSourceList badgeTextColorForItem:(id)item{
    if ([[item class] isSubclassOfClass:[DicomSeries class]]) {
        DicomSeries* series = (DicomSeries*)item;
        if (self.blueSeries&&[self.blueSeries.uniqueFilename isEqualToString:series.uniqueFilename]) {
            return [NSColor blueColor];
        }else if (self.redSeries&&[self.redSeries.uniqueFilename isEqualToString:series.uniqueFilename]) {
            return [NSColor redColor];
        }else if (self.greenSeries&&[self.greenSeries.uniqueFilename isEqualToString:series.uniqueFilename]) {
            return [NSColor greenColor];
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group{
    return YES;
}

- (BOOL)sourceList:(PXSourceList*)aSourceList shouldSelectItem:(id)item{
    self.seriesArray = [aSourceList parentForItem:item];
    NSLog(@"selected Item: %@ - Array: %@",item,self.seriesArray);
    [self initializeImageSeries];
    return YES;
}

#pragma mark NSCollectionViewDatasource
- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.redSeries&&self.greenSeries&&self.blueSeries){
        return self.seriesArray.count;
    }else{
        return 0;
    }
}

- (NSCollectionViewItem*)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath{
    ImageItem* cell = (ImageItem*)[collectionView makeItemWithIdentifier:@"ImageItem" forIndexPath:indexPath];
    DicomSeries* series = self.seriesArray[indexPath.item];
    cell.imageView.image = series.thumbnailImage;
    cell.textField.stringValue = series.name;
    if(collectionView == _collRed){
        cell.cellColor = NSColor.redColor;
        [cell toggleOverlayView:[series isEqual:_redSeries]];
    }else if (collectionView == _collBlue){
        cell.cellColor = NSColor.blueColor;
        [cell toggleOverlayView:[series isEqual:_blueSeries]];
    }else if (collectionView == _collGreen){
        cell.cellColor = NSColor.greenColor;
        [cell toggleOverlayView:[series isEqual:_greenSeries]];
    }
    return cell;
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths{
    DicomSeries* series = self.seriesArray[indexPaths.allObjects.firstObject.item];
    if(collectionView == _collRed){
        self.redSeries = series;
        self.imgRed.image = series.thumbnailImage;
    }else if (collectionView == _collBlue){
        self.blueSeries = series;
        self.imgBlue.image = series.thumbnailImage;
    }else if (collectionView == _collGreen){
        self.greenSeries = series;
        self.imgGreen.image = series.thumbnailImage;
    }
    NSLog(@"SELECTING IMAGE!");
    NSIndexPath* selectedIndexPath = indexPaths.allObjects.firstObject;
    ImageItem* cell = (ImageItem*)[collectionView itemAtIndexPath:selectedIndexPath];
    [cell toggleOverlayView:YES];
    [self.imgRed setNeedsLayout:YES];
    [self.imgGreen setNeedsLayout:YES];
    [self.imgBlue setNeedsLayout:YES];
    [self generateSampleImage];

}

- (NSSet<NSIndexPath *> *)collectionView:(NSCollectionView *)collectionView shouldSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths{
    return indexPaths;
}

@end
