import 'package:flutter/material.dart';

import '../cmn_text.dart';

// Assume KButton is defined as in the previous example
// Assume lightColorScheme is defined elsewhere

class KSecondaryBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final ButtonStyle?
      overrideStyle; // Allow overriding the default secondary (tonal) style

  const KSecondaryBtn({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.overrideStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filledButtonTheme = Theme.of(context).filledButtonTheme;

    // Define the default style for a secondary (tonal) button
    // Start with the general theme style for FilledButton (for shape, padding etc.)
    // Then override colors for the tonal look using the current API.
    final ButtonStyle defaultSecondaryStyle =
        (filledButtonTheme.style ?? const ButtonStyle()).copyWith(
      // Use WidgetStatePropertyAll for properties that don't change with state
      backgroundColor:
          WidgetStatePropertyAll(colorScheme.secondary.withOpacity(0.7)),
      // foregroundColor: WidgetStatePropertyAll(colorScheme.onSecondaryContainer),

      // Use WidgetStateProperty.resolveWith for properties that DO change with state
      overlayColor: WidgetStateProperty.resolveWith((states) {
        // Use WidgetState enum constants for checking states
        if (states.contains(WidgetState.hovered)) {
          return colorScheme.onSecondaryContainer.withOpacity(0.08);
        }
        if (states.contains(WidgetState.focused) ||
            states.contains(WidgetState.pressed)) {
          return colorScheme.onSecondaryContainer.withOpacity(0.12);
        }
        // Check for disabled state if needed, otherwise rely on ButtonStyleButton's defaults
        // if (states.contains(WidgetState.disabled)) {
        //     return Colors.transparent; // Or specific disabled overlay
        // }
        return null; // Use default overlay from the base ButtonStyleButton
      }),
      // You might also need to define disabledBackgroundColor and disabledForegroundColor
      // if the default handling via opacity in ButtonStyleButton isn't sufficient.
      // Example:
      // surfaceTintColor: ..., // For elevation overlay color if needed
      // elevation: ..., // Base elevation
      // shadowColor: ...,
    );

    // If overrideStyle is provided, use it. Otherwise, use our calculated tonal style.
    // Note: Merging styles can be complex. If overrideStyle is provided, it might
    // fully replace defaultSecondaryStyle depending on how ButtonStyle.copyWith works.
    // For simple overrides (like just padding), ButtonStyle.merge might be better,
    // but for full overrides, using the provided style directly is often intended.
    final ButtonStyle effectiveStyle = overrideStyle ?? defaultSecondaryStyle;

    return KButton(
      key: key,
      onPressed: onPressed,
      text: text,
      icon: icon,
      isLoading: isLoading,
      style:
          effectiveStyle, // Pass the calculated or overridden secondary style
    );
  }
}

// --- KButton and KPrimaryBtn remain the same as the previous correct version ---

/// A common base button widget that handles layout, icons, and loading state.
/// It uses FilledButton internally and expects styling via the [style] parameter.
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

class KDoneBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final IconData? icon;
  final bool isLoading;
  final String? tooltip;
  const KDoneBtn({
    super.key,
    this.onPressed,
    this.label,
    this.icon,
    this.isLoading = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed: isLoading ? null : onPressed,
      tooltip: tooltip ?? "Done",
      label: isLoading
          ? const CircularProgressIndicator(
              strokeWidth: 2.0,
              color: Colors.white,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon ?? Icons.done,
                  size: 20,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                if (label != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: KText(
                      label!,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
              ],
            ),
    );
  }
}

class KSubmitBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final ButtonStyle? overrideStyle;

  const KSubmitBtn({
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
      onPressed: onPressed,
      text: text,
      icon: icon ?? Icons.check, // Default to check icon if none provided
      isLoading: isLoading,
      style: overrideStyle,
    );
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
    // KButton uses FilledButton internally.
    // FilledButton automatically picks up primary colors from the theme's
    // colorScheme when style is null or doesn't specify colors.
    // We pass overrideStyle directly. If it's null, KButton receives null,
    // and its internal FilledButton uses theme defaults for primary buttons.
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

class KTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final Color? textColor; // Explicit color override
  final EdgeInsetsGeometry? padding;
  final bool? bold;

  const KTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.textColor,
    this.padding,
    this.bold = true,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor ?? Theme.of(context).colorScheme.secondary,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
        side: BorderSide(
          color: textColor?.withOpacity(0.5) ??
              Theme.of(context).colorScheme.secondaryFixedDim, // Border color
          width: 1.5, // Optional: thickness of border
        ),
      ),
      icon: (isLoading || icon == null)
          ? const SizedBox.shrink() // No icon when loading
          : Icon(
              icon,
              color: textColor ?? Theme.of(context).colorScheme.primary,
            ),
      label: isLoading
          ? const CircularProgressIndicator()
          : KText(
              bold: true,
              text,
              style: TextStyle(
                color: textColor ?? Theme.of(context).colorScheme.primary,
              ),
            ),
    );
  }
}

class KCancelButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;

  const KCancelButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return KTextButton(
      onPressed: onPressed,
      text: text,
      icon: icon ?? Icons.cancel, // Default to cancel icon if none provided
      isLoading: isLoading,
      textColor:
          Theme.of(context).colorScheme.error, // Use error color for cancel
    );
  }
}

class KDeleteBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final String text;

  const KDeleteBtn({
    super.key,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.text = "",
  });

  @override
  Widget build(BuildContext context) {
    return KTextButton(
      onPressed: onPressed,
      text: text,
      icon: icon ?? Icons.delete,
    );
  }
}

class KAddBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;

  const KAddBtn({
    super.key,
    required this.onPressed,
    this.text = "Add",
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return KTextButton(
      onPressed: onPressed,
      text: text,
      icon: icon ?? Icons.add,
      isLoading: isLoading,
    );
  }
}
