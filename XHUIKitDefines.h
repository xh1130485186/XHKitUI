//
//  XHKitUIDefines.h
//  XHKitUIDemo
//
//  Created by 向洪 on 2019/11/5.
//  Copyright © 2019 向洪. All rights reserved.
//

#ifndef XHKitUIDefines_h
#define XHKitUIDefines_h

static inline NSString *XHUIBundlePathForResource(NSString *bundleName, Class aClass, NSString *resourceName, NSString *ofType, BOOL times) {
    NSBundle *bundle = [NSBundle bundleForClass:aClass];
    NSURL *url = [bundle URLForResource:bundleName withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    NSString *name = resourceName;
    if (times) {
        name = [UIScreen mainScreen].scale==3?[name stringByAppendingString:@"@3x"]:[name stringByAppendingString:@"@2x"];
    }
    NSString *imagePath = [bundle pathForResource:name ofType:ofType];
    return imagePath;
}

#define XHUIKitImage(name) [UIImage imageWithContentsOfFile:XHUIBundlePathForResource(@"xhkit.ui", NSClassFromString(@"XHDropDownMenu"), name, @"png", 1)]

#endif /* XHKitUIDefines_h */
