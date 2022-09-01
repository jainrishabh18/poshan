import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularStepProgressIndicator extends StatelessWidget {
  final CircularDirection circularDirection;
  final int currentStep;
  final int totalSteps;
  final double padding;
  final double? height;
  final double? width;
  final Color Function(int)? customColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double stepSize;
  final double? selectedStepSize;
  final double? unselectedStepSize;
  final double Function(int, bool)? customStepSize;
  final Widget? child;
  final double fallbackHeight;
  final double fallbackWidth;
  final double startingAngle;
  final double arcSize;
  final bool Function(int, bool)? roundedCap;
  final Gradient? gradientColor;
  final bool removeRoundedCapExtraAngle;

  const CircularStepProgressIndicator({
    required this.totalSteps,
    this.child,
    this.height,
    this.width,
    this.customColor,
    this.customStepSize,
    this.selectedStepSize,
    this.unselectedStepSize,
    this.roundedCap,
    this.gradientColor,
    this.circularDirection = CircularDirection.clockwise,
    this.fallbackHeight = 100.0,
    this.fallbackWidth = 100.0,
    this.currentStep = 0,
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.grey,
    this.padding = math.pi / 20,
    this.stepSize = 6.0,
    this.startingAngle = 0,
    this.arcSize = math.pi * 2,
    this.removeRoundedCapExtraAngle = false,
    Key? key,
  })  : assert(totalSteps > 0,
            "Number of total steps (totalSteps) of the CircularStepProgressIndicator must be greater than 0"),
        assert(currentStep >= 0,
            "Current step (currentStep) of the CircularStepProgressIndicator must be greater than or equal to 0"),
        assert(padding >= 0.0,
            "Padding (padding) of the CircularStepProgressIndicator must be greater or equal to 0"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (arcSize > math.pi * 2)
      print(
          "WARNING (step_progress_indicator): arcSize of CircularStepProgressIndicator is greater than 360° (math.pi * 2), this will cause some steps to overlap!");
    final TextDirection textDirection = Directionality.of(context);

    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: height != null
            ? height
            : constraints.maxHeight != double.infinity
                ? constraints.maxHeight
                : fallbackHeight,
        width: width != null
            ? width
            : constraints.maxWidth != double.infinity
                ? constraints.maxWidth
                : fallbackWidth,
        child: CustomPaint(
          painter: _CircularIndicatorPainter(
            totalSteps: totalSteps,
            currentStep: currentStep,
            customColor: customColor,
            padding: padding,
            circularDirection: circularDirection,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            arcSize: arcSize,
            stepSize: stepSize,
            customStepSize: customStepSize,
            maxDefinedSize: maxDefinedSize,
            selectedStepSize: selectedStepSize,
            unselectedStepSize: unselectedStepSize,
            startingAngle: startingAngleTopOfIndicator,
            roundedCap: roundedCap,
            gradientColor: gradientColor,
            textDirection: textDirection,
            removeRoundedCapExtraAngle: removeRoundedCapExtraAngle,
          ),
          child: Padding(
            padding: EdgeInsets.all(maxDefinedSize),
            child: child,
          ),
        ),
      ),
    );
  }

  double get maxDefinedSize {
    if (customStepSize == null) {
      return math.max(
          stepSize, math.max(selectedStepSize ?? 0, unselectedStepSize ?? 0));
    }
    double currentMaxSize = 0;

    for (int step = 0; step < totalSteps; ++step) {
      final customSizeValue =
          math.max(customStepSize!(step, false), customStepSize!(step, true));
      if (customSizeValue > currentMaxSize) {
        currentMaxSize = customSizeValue;
      }
    }

    return currentMaxSize;
  }

  double get startingAngleTopOfIndicator => startingAngle - math.pi / 2;
}

class _CircularIndicatorPainter implements CustomPainter {
  final int totalSteps;
  final int currentStep;
  final double padding;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double stepSize;
  final double? selectedStepSize;
  final double? unselectedStepSize;
  final double Function(int, bool)? customStepSize;
  final double maxDefinedSize;
  final Color Function(int)? customColor;
  final CircularDirection circularDirection;
  final double startingAngle;
  final double arcSize;
  final bool Function(int, bool)? roundedCap;
  final Gradient? gradientColor;
  final TextDirection textDirection;
  final bool removeRoundedCapExtraAngle;

  _CircularIndicatorPainter({
    required this.totalSteps,
    required this.circularDirection,
    required this.customColor,
    required this.currentStep,
    required this.selectedColor,
    required this.unselectedColor,
    required this.padding,
    required this.stepSize,
    required this.selectedStepSize,
    required this.unselectedStepSize,
    required this.customStepSize,
    required this.startingAngle,
    required this.arcSize,
    required this.maxDefinedSize,
    required this.roundedCap,
    required this.gradientColor,
    required this.textDirection,
    required this.removeRoundedCapExtraAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stepLength = arcSize / totalSteps;

    // Define general arc paint
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = maxDefinedSize;

    final rect = Rect.fromCenter(
      // Rect created from the center of the widget
      center: Offset(w / 2, h / 2),
      // For both height and width, subtract maxDefinedSize to fit indicator inside the parent container
      height: h - maxDefinedSize,
      width: w - maxDefinedSize,
    );

    if (gradientColor != null) {
      paint.shader =
          gradientColor!.createShader(rect, textDirection: textDirection);
    }

    // Change color selected or unselected based on the circularDirection
    final isClockwise = circularDirection == CircularDirection.clockwise;

    // Make a continuous arc without rendering all the steps when possible
    if (padding == 0 &&
        customColor == null &&
        customStepSize == null &&
        roundedCap == null) {
      _drawContinuousArc(canvas, paint, rect, isClockwise);
    } else {
      _drawStepArc(canvas, paint, rect, isClockwise, stepLength);
    }
  }

  /// Draw a series of arcs, each composing the full steps of the indicator
  void _drawStepArc(Canvas canvas, Paint paint, Rect rect, bool isClockwise,
      double stepLength) {
    // Draw a series of circular arcs to compose the indicator
    // Starting based on startingAngle attribute
    //
    // When clockwise:
    // - Start drawing counterclockwise so to have the selected steps on top of the unselected
    int step = isClockwise ? totalSteps - 1 : 0;
    double stepAngle = isClockwise ? startingAngle - stepLength : startingAngle;
    for (;
        isClockwise ? step >= 0 : step < totalSteps;
        isClockwise ? stepAngle -= stepLength : stepAngle += stepLength,
        isClockwise ? --step : ++step) {
      // Check if the current step is selected or unselected
      final isSelectedColor = _isSelectedColor(step, isClockwise);

      // Size of the step
      final indexStepSize = customStepSize != null
          // Consider step index inverted when counterclockwise
          ? customStepSize!(_indexOfStep(step, isClockwise), isSelectedColor)
          : isSelectedColor
              ? selectedStepSize ?? stepSize
              : unselectedStepSize ?? stepSize;

      // Use customColor if defined
      final stepColor = customColor != null
          // Consider step index inverted when counterclockwise
          ? customColor!(_indexOfStep(step, isClockwise))
          : isSelectedColor
              ? selectedColor!
              : unselectedColor!;

      // Apply stroke cap to each step
      final hasStrokeCap = roundedCap != null
          ? roundedCap!(_indexOfStep(step, isClockwise), isSelectedColor)
          : false;
      final strokeCap = hasStrokeCap ? StrokeCap.round : StrokeCap.butt;

      // Remove extra size caused by rounded stroke cap
      // https://github.com/SandroMaglione/step-progress-indicator/issues/20#issue-786114745
      final extraCapSize = indexStepSize / 2;
      final extraCapAngle = extraCapSize / (rect.width / 2);
      final extraCapRemove = hasStrokeCap && removeRoundedCapExtraAngle;

      // Draw arc steps of the indicator
      _drawArcOnCanvas(
        canvas: canvas,
        rect: rect,
        startingAngle: stepAngle + (extraCapRemove ? extraCapAngle : 0),
        sweepAngle:
            stepLength - padding - (extraCapRemove ? extraCapAngle * 2 : 0),
        paint: paint,
        color: stepColor,
        strokeWidth: indexStepSize,
        strokeCap: strokeCap,
      );
    }
  }

  void _drawContinuousArc(
      Canvas canvas, Paint paint, Rect rect, bool isClockwise) {
    // Compute color of the selected and unselected bars
    final firstStepColor = isClockwise ? selectedColor : unselectedColor;
    final secondStepColor = !isClockwise ? selectedColor : unselectedColor;

    // Selected and unselected step sizes if defined, otherwise use stepSize
    final firstStepSize = isClockwise
        ? selectedStepSize ?? stepSize
        : unselectedStepSize ?? stepSize;
    final secondStepSize = !isClockwise
        ? selectedStepSize ?? stepSize
        : unselectedStepSize ?? stepSize;

    // Compute length and starting angle of the selected and unselected bars
    final firstArcLength = arcSize * (currentStep / totalSteps);
    final secondArcLength = arcSize - firstArcLength;

    // firstArcStartingAngle = startingAngle
    final secondArcStartingAngle = startingAngle + firstArcLength;

    // Apply stroke cap to both arcs
    // NOTE: For continuous circular indicator, it uses 0 and 1 as index to
    // apply the rounded cap
    final firstArcStrokeCap = roundedCap != null
        ? isClockwise
            ? roundedCap!(0, true)
            : roundedCap!(1, false)
        : false;
    final secondArcStrokeCap = roundedCap != null
        ? isClockwise
            ? roundedCap!(1, false)
            : roundedCap!(0, true)
        : false;
    final firstCap = firstArcStrokeCap ? StrokeCap.round : StrokeCap.butt;
    final secondCap = secondArcStrokeCap ? StrokeCap.round : StrokeCap.butt;

    // When clockwise, draw the second arc first and the first on top of it
    // Required when stroke cap is rounded to make the selected step on top of the unselected
    if (circularDirection == CircularDirection.clockwise) {
      // Second arc, selected when counterclockwise, unselected otherwise
      _drawArcOnCanvas(
        canvas: canvas,
        rect: rect,
        paint: paint,
        startingAngle: secondArcStartingAngle,
        sweepAngle: secondArcLength,
        strokeWidth: secondStepSize,
        color: secondStepColor!,
        strokeCap: secondCap,
      );

      // First arc, selected when clockwise, unselected otherwise
      _drawArcOnCanvas(
        canvas: canvas,
        rect: rect,
        paint: paint,
        startingAngle: startingAngle,
        sweepAngle: firstArcLength,
        strokeWidth: firstStepSize,
        color: firstStepColor!,
        strokeCap: firstCap,
      );
    } else {
      // First arc, selected when clockwise, unselected otherwise
      _drawArcOnCanvas(
        canvas: canvas,
        rect: rect,
        paint: paint,
        startingAngle: startingAngle,
        sweepAngle: firstArcLength,
        strokeWidth: firstStepSize,
        color: firstStepColor!,
        strokeCap: firstCap,
      );

      // Second arc, selected when counterclockwise, unselected otherwise
      _drawArcOnCanvas(
        canvas: canvas,
        rect: rect,
        paint: paint,
        startingAngle: secondArcStartingAngle,
        sweepAngle: secondArcLength,
        strokeWidth: secondStepSize,
        color: secondStepColor!,
        strokeCap: secondCap,
      );
    }
  }

  /// Draw the actual arc for a continuous indicator
  void _drawArcOnCanvas({
    required Canvas canvas,
    required Rect rect,
    required double startingAngle,
    required double sweepAngle,
    required Paint paint,
    required Color color,
    required double strokeWidth,
    required StrokeCap strokeCap,
  }) =>
      canvas.drawArc(
        rect,
        startingAngle,
        sweepAngle,
        false /*isRadial*/,
        paint
          ..color = color
          ..strokeWidth = strokeWidth
          ..strokeCap = strokeCap,
      );

  bool _isSelectedColor(int step, bool isClockwise) => isClockwise
      ? step < currentStep
      : (step + 1) > (totalSteps - currentStep);

  int _indexOfStep(int step, bool isClockwise) =>
      isClockwise ? step : totalSteps - step - 1;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;

  @override
  bool hitTest(Offset position) => false;

  @override
  void addListener(listener) {}

  @override
  void removeListener(listener) {}

  @override
  get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;
}

enum CircularDirection {
  clockwise,
  counterclockwise,
}
