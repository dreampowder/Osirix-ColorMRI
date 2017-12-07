//
//  PluginTemplateFilter.h
//  PluginTemplate
//
//  Copyright (c) CURRENT_YEAR YOUR_NAME. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OsiriXAPI/PluginFilter.h>
#import <OsiriXAPI/DicomStudy.h>
#import <OsiriXAPI/DicomSeries.h>
#import <OsiriXAPI/BrowserController.h>

@interface PluginTemplateFilter : PluginFilter {

}

@property(nonatomic, strong) ViewerController    *viewerWindow;

- (long) filterImage:(NSString*) menuName;

@end
