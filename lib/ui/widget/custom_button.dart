// Core Flutter imports
import 'package:flutter/material.dart';

// Third-party package imports
import 'package:smooth_corner/smooth_corner.dart';

// Local project imports
import '../themes/app_theme.dart';

// CustomButton widget definition
class CustomButton extends StatelessWidget {
  // Static constants for default values
  static const double defaultBorderRadius = 14.0;
  static const EdgeInsets defaultTextPadding =
  EdgeInsets.symmetric(horizontal: 56, vertical: 14);

  // Widget properties
  final VoidCallback? onPressed;
  final String text;
  final Color color;
  final double borderRadius;
  final EdgeInsets textPadding;
  final Color textColor;
  final double textSize;
  final double iconSize;
  final IconData? icon;

  // Constructor
  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.color,
    this.textSize = 16,
    this.iconSize = 16,
    this.borderRadius = defaultBorderRadius,
    this.textPadding = defaultTextPadding,
    required this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Theme and color retrieval
    final appColors = AppTheme.colorsOf(context);
    final buttonColor = onPressed == null ? color.withOpacity(0.5) : color;
    final rippleColor = appColors.grey7;

    // Widget tree construction
    return IntrinsicWidth(
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: ShapeDecoration(
            color: buttonColor,
            shape: SmoothRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              smoothness: 1,
            ),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: onPressed != null
                ? rippleColor.withOpacity(0.2)
                : Colors.transparent,
            highlightColor: onPressed != null
                ? rippleColor.withOpacity(0.1)
                : Colors.transparent,
            splashFactory: InkRipple.splashFactory,
            child: Padding(
              padding: textPadding,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon conditional rendering
                    if (icon != null) ...[
                      Icon(
                        icon,
                        color: textColor,
                        size: iconSize,
                      ),
                    ],
                    const SizedBox(
                      width: 8,
                    ),
                    // Text display
                    Text(
                      text,
                      style: TextStyle(
                        fontFamily: 'OpenRunde',
                        fontSize: textSize,
                        height: 1.4,
                        overflow: TextOverflow.ellipsis,
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
