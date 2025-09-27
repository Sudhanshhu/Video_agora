import 'package:flutter/material.dart';

import '../../../utils/app_icons.dart';
import '../../../utils/colors/colors.dart';

class KIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? size;
  final Color? circleColor;
  final bool withCircle;
  const KIcon(
    this.icon, {
    super.key,
    this.color,
    this.circleColor,
    this.size,
    this.withCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return withCircle
        ? Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: circleColor ??
                    Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                // shape: ,

                borderRadius: BorderRadius.circular(6)),
            child: Icon(
              icon,
              color: color ?? Theme.of(context).colorScheme.secondary,
              size: size ?? 26,
            ),
          )
        : Icon(
            icon,
            color: color ?? Theme.of(context).colorScheme.secondary,
            size: size ?? 26,
          );
  }
}

class KIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double? size;
  final Color? color;
  final bool withCircle;
  final Color? circleColor;
  final String? tooltip;

  const KIconButton(
    this.icon, {
    super.key,
    this.onPressed,
    this.size,
    this.color,
    this.circleColor,
    this.withCircle = false,
    this.tooltip,
  });
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: KIcon(
        icon,
        size: size ?? 20,
        color: color,
        withCircle: withCircle,
        circleColor: circleColor,
      ),
    );
  }
}

class KIconsBtnDelete extends StatelessWidget {
  final VoidCallback? onPressed;

  const KIconsBtnDelete({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return KIconButton(
      AppIcons.delete,
      onPressed: onPressed,
      withCircle: true,
      color: AppColors.error,
    );
  }
}

class KIconsBtnEdit extends StatelessWidget {
  final VoidCallback? onPressed;

  const KIconsBtnEdit({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return KIconButton(
      AppIcons.edit,
      onPressed: onPressed,
      withCircle: true,
      color: AppColors.info,
    );
  }
}

class KIconsBtnAdd extends StatelessWidget {
  final VoidCallback? onPressed;

  const KIconsBtnAdd({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return KIconButton(
      AppIcons.add,
      onPressed: onPressed,
      withCircle: true,
      color: AppColors.success,
    );
  }
}

class KIconsBtnDecrease extends StatelessWidget {
  final VoidCallback? onPressed;

  const KIconsBtnDecrease({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return KIconButton(
      AppIcons.remove,
      onPressed: onPressed,
      withCircle: true,
      color: AppColors.error,
    );
  }
}
