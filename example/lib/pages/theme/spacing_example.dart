import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:zeta_example/widgets.dart';
import 'package:zeta_flutter/zeta_flutter.dart';

Map<String, double> semanticSpacings = {
  'none': ZetaSpacing.none,
  'minimum': ZetaSpacing.minimum,
  'small': ZetaSpacing.small,
  'medium': ZetaSpacing.medium,
  'large': ZetaSpacing.large,
  'xl': ZetaSpacing.xL,
  '2xl': ZetaSpacing.xL2,
  '3xl': ZetaSpacing.xL3,
  '4xl': ZetaSpacing.xL4,
  '5xl': ZetaSpacing.xL5,
  '6xl': ZetaSpacing.xL6,
  '7xl': ZetaSpacing.xL7,
  '8xl': ZetaSpacing.xL8,
  '9xl': ZetaSpacing.xL9,
  '10xl': ZetaSpacing.xL10,
  '11xl': ZetaSpacing.xL11,
};
Map<String, double> baseSpacings = {
  'x1': ZetaSpacingBase.x1,
  'x2': ZetaSpacingBase.x2,
  'x3': ZetaSpacingBase.x3,
  'x3.5': ZetaSpacingBase.x3_5,
  'x4': ZetaSpacingBase.x4,
  'x5': ZetaSpacingBase.x5,
  'x6': ZetaSpacingBase.x6,
  'x7': ZetaSpacingBase.x7,
  'x8': ZetaSpacingBase.x8,
  'x9': ZetaSpacingBase.x9,
  'x10': ZetaSpacingBase.x10,
  'x11': ZetaSpacingBase.x11,
  'x12': ZetaSpacingBase.x12,
  'x13': ZetaSpacingBase.x13,
  'x14': ZetaSpacingBase.x14,
  'x15': ZetaSpacingBase.x15,
  'x30': ZetaSpacingBase.x30,
  'x50': ZetaSpacingBase.x50,
};

class SpacingExample extends StatelessWidget {
  const SpacingExample({super.key});
  static const String name = 'Spacing';

  @override
  Widget build(BuildContext context) {
    return ExampleScaffold(
      name: name,
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: baseSpacings.entries.map((obj) => _SpacingDemo(obj)).toList(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: semanticSpacings.entries.map((obj) => _SpacingDemo(obj)).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SpacingDemo extends StatelessWidget {
  final MapEntry<String, double> size;

  const _SpacingDemo(this.size);

  @override
  Widget build(BuildContext context) {
    final colors = Zeta.of(context).colors;
    return Container(
      color: colors.blue.shade30,
      margin: EdgeInsets.all(ZetaSpacing.xL2),
      child: CustomPaint(
        painter: _TagPainter(color: colors.pink),
        child: LayoutBuilder(builder: (context, c2) {
          return Container(
            margin: EdgeInsets.all(size.value),
            padding: EdgeInsets.all(ZetaSpacing.medium),
            color: colors.surfacePrimary,
            child: Text(
              'ZetaSpacing.' + size.key,
              style: ZetaTextStyles.titleMedium.apply(
                color: Zeta.of(context).colors.textDefault,
                fontStyle: FontStyle.normal,
                decoration: TextDecoration.none,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TagPainter extends CustomPainter {
  const _TagPainter({
    required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke;

    final horizontal = Path()
      ..moveTo(0, (size.height / 2))
      ..lineTo(size.width, (size.height / 2))
      ..close();

    final vertical = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(dashPath(horizontal, dashArray: CircularIntervalList([2, 3])), paint);
    canvas.drawPath(
      dashPath(vertical, dashArray: CircularIntervalList([2, 3]), dashOffset: DashOffset.absolute(size.height)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
