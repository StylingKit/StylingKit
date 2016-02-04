//
// Created by Anton Matosov on 2/1/16.
//

#import <objc/runtime.h>
#import "UICollectionViewCell+STKStyling.h"


static const char STYLE_PARENT_KEY;

@implementation UICollectionViewCell (STKStyling)

- (id)pxStyleParent
{
    return objc_getAssociatedObject(self, &STYLE_PARENT_KEY);
}

- (void)setPxStyleParent:(id)parent
{
    objc_setAssociatedObject(self, &STYLE_PARENT_KEY, parent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
