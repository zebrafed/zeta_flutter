import 'chip.dart';

/// Zeta Filter Chip.
///
/// Extends [ZetaChip].
class ZetaFilterChip extends ZetaChip {
  /// Creates a [ZetaInputChip].
  const ZetaFilterChip({
    super.key,
    required super.label,
    super.rounded,
    super.selected,
    super.draggable = false,
    super.data,
    super.onDragCompleted,
    // super.onTap - return toggle state on tap. TODO:LUKE
  });

  /// Creates another instance of [ZetaFilterChip].
  ZetaFilterChip copyWith({
    bool? rounded,
  }) {
    return ZetaFilterChip(
      label: label,
      selected: selected,
      rounded: rounded ?? this.rounded,
      // onTap: onTap, TODO:LUKE
    );
  }
}
