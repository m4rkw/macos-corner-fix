#import <AppKit/AppKit.h>
#import <objc/runtime.h>

static CGFloat kDesiredCornerRadius = 10.0;  // Sequoia (macOS 15) default

static double swizzled_cornerRadius(id self, SEL _cmd) {
    return kDesiredCornerRadius;
}

static double swizzled_getCachedCornerRadius(id self, SEL _cmd) {
    return kDesiredCornerRadius;
}

static CGSize swizzled_topCornerSize(id self, SEL _cmd) {
    return CGSizeMake(kDesiredCornerRadius, kDesiredCornerRadius);
}

static CGSize swizzled_bottomCornerSize(id self, SEL _cmd) {
    return CGSizeMake(kDesiredCornerRadius, kDesiredCornerRadius);
}

__attribute__((constructor))
static void init(void) {
    Class cls = NSClassFromString(@"NSThemeFrame");
    if (!cls) return;

    Method m1 = class_getInstanceMethod(cls, @selector(_cornerRadius));
    if (m1) method_setImplementation(m1, (IMP)swizzled_cornerRadius);

    Method m2 = class_getInstanceMethod(cls, @selector(_getCachedWindowCornerRadius));
    if (m2) method_setImplementation(m2, (IMP)swizzled_getCachedCornerRadius);

    Method m3 = class_getInstanceMethod(cls, @selector(_topCornerSize));
    if (m3) method_setImplementation(m3, (IMP)swizzled_topCornerSize);

    Method m4 = class_getInstanceMethod(cls, @selector(_bottomCornerSize));
    if (m4) method_setImplementation(m4, (IMP)swizzled_bottomCornerSize);

    NSLog(@"[CornerTweak] Swizzled NSThemeFrame corner radius to %.1f", kDesiredCornerRadius);
}
