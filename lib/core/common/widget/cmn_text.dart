import 'package:flutter/material.dart';

/// A common, reusable Text widget with customizable parameters.
///
/// Defaults to using the theme's `bodyMedium` text style and `onSurface` color
/// if no specific style or color is provided.
class KText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final Color? textColor; // Explicit color override
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height; // Line height
  final TextDecoration? decoration;
  final bool? bold;
  final bool? selectable;

  const KText(
    this.data, {
    super.key,
    this.style,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.textAlign,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis, // Default to ellipsis overflow
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.decoration,
    this.bold = false, // Optional bold flag
    this.selectable = false, // Optional selectable flag
  });

  @override
  Widget build(BuildContext context) {
    // Get theme and color scheme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine the base text style
    // Priority: 1. Provided style, 2. Theme's bodyMedium, 3. Default TextStyle
    final TextStyle baseStyle =
        style ?? theme.textTheme.bodyMedium ?? const TextStyle();

    // Apply specific overrides to the base style
    // Priority: Explicit param > Style param > Theme default
    final TextStyle effectiveStyle = baseStyle.copyWith(
      color: textColor ??
          baseStyle.color ??
          colorScheme
              .onSurface, // Default to onSurface if no color specified anywhere
      fontSize: fontSize ?? baseStyle.fontSize,
      fontWeight: fontWeight ?? baseStyle.fontWeight,
      fontStyle: fontStyle ?? baseStyle.fontStyle,
      letterSpacing: letterSpacing ?? baseStyle.letterSpacing,
      wordSpacing: wordSpacing ?? baseStyle.wordSpacing,
      height: height ?? baseStyle.height,
      decoration: decoration ?? baseStyle.decoration,
      // Add other properties like foreground, background if needed
    );

    return Text(
      data,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

// --- Specialized Text Widgets ---

/// A convenience Text widget that uses the theme's `primary` color.
///
/// Inherits other style properties from the theme's `bodyMedium` by default,
/// but can be customized further via the `style` parameter or other overrides.
class KTextPrimary extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const KTextPrimary(
    this.data, {
    super.key,
    this.style,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.textAlign,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return KText(
      data,
      key: key, // Pass the key down
      style: style,
      textColor: colorScheme.primary, // <<< Uses primary color
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// A convenience Text widget that uses the theme's `onSurfaceVariant` color.
///
/// Often used for medium-emphasis text like subtitles or helper text.
/// Inherits other style properties from the theme's `bodyMedium` by default.
class KTextOnSurfaceVariant extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const KTextOnSurfaceVariant(
    this.data, {
    super.key,
    this.style,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.textAlign,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Get the base bodyMedium style to potentially inherit non-color properties
    final baseStyle = Theme.of(context).textTheme.bodyMedium;
    // Merge the provided style with the base style if provided
    final mergedStyle =
        style != null ? baseStyle?.merge(style) ?? style : baseStyle;

    return KText(
      data,
      key: key, // Pass the key down
      style: mergedStyle, // Pass merged style if available
      textColor:
          colorScheme.onSurfaceVariant, // <<< Uses onSurfaceVariant color
      fontSize: fontSize, // Allow override
      fontWeight: fontWeight, // Allow override
      fontStyle: fontStyle, // Allow override
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class KTextSecondary extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const KTextSecondary(
    this.data, {
    super.key,
    this.style,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.textAlign,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return KText(
      data,
      key: key, // Pass the key down
      style: style,
      textColor:
          colorScheme.onSecondaryFixedVariant, // <<< Uses secondary color
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// A convenience Text widget specifically for errors, using the theme's `error` color.
class KTextError extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const KTextError(
    this.data, {
    super.key,
    this.style,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.textAlign,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return KText(
      data,
      key: key, // Pass the key down
      style: style,
      textColor: colorScheme.error, // <<< Uses error color
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}


// You could add more variants like:
// KTextSecondary, KTextOnPrimary, KTextTitleLarge (using theme.textTheme.titleLarge), etc.




