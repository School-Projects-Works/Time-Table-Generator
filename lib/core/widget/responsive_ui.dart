import 'package:flutter/material.dart';

class ResponsiveScreen extends StatelessWidget {
  const ResponsiveScreen({
    super.key,
    this.desktop,
    this.tablet,
    this.mobile,
  });
  final Widget? desktop;
  final Widget? tablet;
  final Widget? mobile;

  //static  size
  static const footerHeaderFontSize = 14.0;
  static const footerBodyFontSize = 12.0;
  static const footerBodyPadding = 10.0;
  static const footerBodySocialPadding = 17.0;

  // get screen size
  static Size sizeOf(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double getFooterHeaderFontSize(BuildContext context) {
    if (ResponsiveScreen.isDesktop(context)) {
      return footerHeaderFontSize * 1.3;
    } else if (ResponsiveScreen.isTablet(context)) {
      return footerHeaderFontSize * 1.2;
    } else if (ResponsiveScreen.isMobile(context)) {
      return footerHeaderFontSize * 1.0;
    }

    return footerHeaderFontSize;
  }

  static double getFooterBodyFontSize(BuildContext context) {
    if (ResponsiveScreen.isDesktop(context)) {
      return footerBodyFontSize * 1.3;
    } else if (ResponsiveScreen.isTablet(context)) {
      return footerBodyFontSize * 1.2;
    } else if (ResponsiveScreen.isMobile(context)) {
      return footerBodyFontSize * 1.0;
    }

    return footerBodyFontSize;
  }

  static double getFooterBodyPadding(BuildContext context) {
    if (ResponsiveScreen.isDesktop(context)) {
      return footerBodyPadding * 1.3;
    } else if (ResponsiveScreen.isTablet(context)) {
      return footerBodyPadding * 1.2;
    } else if (ResponsiveScreen.isMobile(context)) {
      return footerBodyPadding * 1.0;
    }

    return footerBodyPadding;
  }

  static double getFooterSocialSize(BuildContext context) {
    if (ResponsiveScreen.isDesktop(context)) {
      return footerBodySocialPadding * 1.3;
    } else if (ResponsiveScreen.isTablet(context)) {
      return footerBodySocialPadding * 1.2;
    } else if (ResponsiveScreen.isMobile(context)) {
      return footerBodySocialPadding * 1.0;
    }

    return footerBodySocialPadding;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 700;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 800 &&
        MediaQuery.sizeOf(context).width < 1100;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 1100;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1100) {
        return desktop!;
      } else if (constraints.maxWidth > 700 && constraints.maxWidth < 1100) {
        return tablet ?? desktop!;
      } else {
        return mobile!;
      }
    });
  }
}
