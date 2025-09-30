import 'package:flutter/material.dart';

class KButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final ButtonStyle? style;
  final Color? backgroundColor; // <-- Added optional parameter

  const KButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.style, // Nullable, defaults will be picked from Theme's FilledButtonTheme
    this.icon,
    this.isLoading = false,
    this.backgroundColor, // <-- Added to constructor
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;

    // If backgroundColor is provided, override the style's backgroundColor
    final ButtonStyle? effectiveStyle = backgroundColor != null
        ? (style ?? const ButtonStyle()).copyWith(
            backgroundColor: WidgetStatePropertyAll(backgroundColor),
          )
        : style ?? Theme.of(context).filledButtonTheme.style;

    // Determine the child widget based on the loading state
    Widget childContent;
    if (isLoading) {
      // Attempt to get a reasonable foreground color for the loader
      Color loaderColor =
          Theme.of(context).colorScheme.onSurface; // Default fallback
      final ButtonStyle? effectiveStyle =
          style ?? Theme.of(context).filledButtonTheme.style;

      // Use WidgetStateProperty resolver for consistency
      if (effectiveStyle?.foregroundColor != null) {
        try {
          // Resolve for an empty set representing the default state
          loaderColor =
              effectiveStyle!.foregroundColor!.resolve({}) ?? loaderColor;
        } catch (_) {
          /* Ignore potential resolution errors if state is needed */
        }
      } else {
        // Fallback if no foregroundColor is defined in the style or theme
        // Maybe use the button's default foreground based on its type if possible?
        // For FilledButton (primary), default is onPrimary
        // For FilledButton.tonal (secondary), default is onSecondaryContainer
        // This logic gets complex here; relying on explicit style or onSurface fallback is safer.
        loaderColor = Theme.of(context)
            .colorScheme
            .primary; // Guess primary as common case
      }

      childContent = SizedBox(
        key: const ValueKey('KButton_Loader'), // Add key for potential testing
        width: 18 // Consistent size with icon
        ,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: loaderColor,
        ),
      );
    } else {
      // If not loading, Text is the base child content.
      // The Icon is handled by using the FilledButton.icon constructor below.
      childContent = Text(text);
    }

    // Use the appropriate FilledButton constructor based on icon presence (when not loading)
    if (icon != null && !isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: FilledButton.icon(
          onPressed: effectiveOnPressed,
          style: effectiveStyle, // Use possibly overridden style
          icon: Icon(icon, size: 18),
          label: childContent, // The label is always the Text widget
        ),
      );
    } else {
      // Use the standard FilledButton if no icon or if loading
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: FilledButton(
          onPressed: effectiveOnPressed,
          style: effectiveStyle, // Use possibly overridden style
          child: childContent, // Child is Text or Loader
        ),
      );
    }
  }
}

// --- KPrimaryBtn using KButton (no changes needed here) ---

class KPrimaryBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final ButtonStyle? overrideStyle;
  const KPrimaryBtn({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.overrideStyle,
  });

  @override
  Widget build(BuildContext context) {
    return KButton(
      key: key,
      onPressed: onPressed,
      text: text,
      icon: icon,
      isLoading: isLoading,
      style: overrideStyle, // Pass override or null
    );
  }
}
