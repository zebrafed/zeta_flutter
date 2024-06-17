import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../zeta_flutter.dart';

/// Global header component
class ZetaGlobalHeader extends ZetaStatefulWidget {
  /// Constructor for [ZetaGlobalHeader]
  const ZetaGlobalHeader({
    super.key,
    super.rounded,
    required this.title,
    this.tabItems = const [],
    this.actionButtons = const [],
    this.avatar,
    this.searchBar,
    this.onAppsButton,
  });

  /// Header title in top left of header
  final String title;

  /// Tab item buttons
  final List<ZetaGlobalHeaderItem> tabItems;

  /// Action buttons.
  final List<IconButton> actionButtons;

  /// Avatar component.
  final ZetaAvatar? avatar;

  /// Search bar component.
  final ZetaSearchBar? searchBar;

  /// Call back for apps icon button shown before avatar on bar.
  ///
  /// If null, apps button and preceding divider are not rendered.
  final VoidCallback? onAppsButton;

  @override
  State<ZetaGlobalHeader> createState() => _GlobalHeaderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('title', title))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onAppsButton', onAppsButton));
  }
}

extension on DeviceType {
  /// Render buttons along the top menu half
  bool get isLarge {
    return this == DeviceType.desktopL || this == DeviceType.desktopXL;
  }

  /// Render search bar on bottom half of menu
  bool get isSmall {
    return this == DeviceType.mobilePortrait || this == DeviceType.mobileLandscape;
  }
}

class _GlobalHeaderState extends State<ZetaGlobalHeader> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;
    return ZetaRoundedScope(
      rounded: context.rounded,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final deviceType = constraints.deviceType;

          return Container(
            padding: const EdgeInsets.symmetric(vertical: ZetaSpacing.medium, horizontal: ZetaSpacing.large),
            decoration: BoxDecoration(color: colors.surfacePrimary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ZetaSpacing.xl_8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // Top Section
                    children: [
                      Row(
                        children: [
                          Text(widget.title, style: ZetaTextStyles.h4),
                          const SizedBox.square(dimension: ZetaSpacing.medium),
                          if (deviceType.isLarge)
                            // If using large screen, render some tabItems in to section
                            ...renderedChildren(widget.tabItems)
                                .sublist(0, widget.tabItems.length > 4 ? 4 : widget.tabItems.length),
                        ],
                      ),
                      // If screen is not small, render search bar on the top
                      if (!deviceType.isSmall && widget.searchBar != null) Expanded(child: widget.searchBar!),
                      Row(
                        children: [
                          ...widget.actionButtons.map(
                            (e) => IconButton(onPressed: e.onPressed, icon: e.icon, iconSize: ZetaSpacing.xl_2),
                          ),
                          if (widget.onAppsButton != null) ...[
                            Container(
                              color: colors.borderDefault,
                              width: 1,
                              height: ZetaSpacing.xl_2,
                              margin: const EdgeInsets.symmetric(horizontal: ZetaSpacing.minimum),
                            ),
                            IconButton(icon: const Icon(ZetaIcons.apps_round), onPressed: widget.onAppsButton),
                          ],
                          const SizedBox(width: ZetaSpacing.small),
                          if (widget.avatar != null) widget.avatar!.copyWith(size: ZetaAvatarSize.m),
                        ],
                      ),
                    ].gap(ZetaSpacing.medium),
                  ),
                ),
                const SizedBox(height: ZetaSpacing.small),
                Row(
                  children: [
                    if (deviceType.isSmall && widget.searchBar != null) Expanded(child: widget.searchBar!),
                    if (widget.tabItems.isNotEmpty && !deviceType.isSmall)
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            /// Large screen filters some tab items to render on top
                            children: deviceType.isLarge && widget.tabItems.length >= 5
                                ? renderedChildren(widget.tabItems).sublist(5, widget.tabItems.length)
                                : renderedChildren(widget.tabItems),
                          ),
                        ),
                      ),
                  ].gap(ZetaSpacing.medium),
                ),
                if (widget.tabItems.isNotEmpty && deviceType.isSmall)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      // Large screen filters some tab items to render on top
                      children: deviceType.isLarge && widget.tabItems.length > 5
                          ? renderedChildren(widget.tabItems).sublist(5, widget.tabItems.length - 1)
                          : renderedChildren(widget.tabItems),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Extend tab items to register their active states
  List<ZetaGlobalHeaderItem> renderedChildren(List<ZetaGlobalHeaderItem> children) {
    final List<ZetaGlobalHeaderItem> modifiedChildren = [];
    for (final (index, child) in children.indexed) {
      modifiedChildren.add(
        child.copyWith(
          active: _selectedIndex == index,
          dropdown: child.dropdown,
          handlePress: () {
            setState(() {
              _selectedIndex = index;
            });
            child.handlePress!.call();
          },
        ),
      );
    }
    return modifiedChildren;
  }
}
