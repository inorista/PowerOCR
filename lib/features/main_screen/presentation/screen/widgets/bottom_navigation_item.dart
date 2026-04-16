import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavigationItem extends StatelessWidget {
  final Function onTap;
  final bool isSelected;
  final String label;
  final String iconPath;
  const BottomNavigationItem({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.label,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => onTap.call(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 26,
            height: 26,
            colorFilter: ColorFilter.mode(
              !isSelected ? theme.colorScheme.primary : theme.colorScheme.error,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              color: !isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
