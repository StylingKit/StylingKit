//
// Created by Anton Matosov on 1/18/16.
//

#import <Foundation/Foundation.h>

@interface STKTheme : NSObject

@property(strong, nonatomic) NSString* name;
@property(strong, nonatomic) NSString* stylesheetFileName;
@property(strong, nonatomic) NSBundle* bundle;

@property(assign, nonatomic) NSUInteger origin; // TODO: get rid of this once full themes support is implemented

+ (instancetype)themeWithName:(NSString*)name
                       bundle:(NSBundle*)bundle;
+ (instancetype)themeWithName:(NSString*)name
           stylesheetFileName:(NSString*)stylesheetFileName
                       bundle:(NSBundle*)bundle;

- (void)activate;

@end
