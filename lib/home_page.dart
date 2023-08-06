import 'dart:math';

import 'package:flutter/material.dart';
import 'package:funny_game/utils/images.dart';

import 'consts/colors.dart';
import 'consts/dimes.dart';
import 'consts/texts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final double cardSize = kCardSize100x;
  late final holeSizeTween = Tween<double>(begin: 0, end: 2 * cardSize);
  late final holeAnimationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: kHoleDuration300ms));

  final TextEditingController textEditingController = TextEditingController();

  String text = kDefaultText;

  double get holeSize => holeSizeTween.evaluate(holeAnimationController);

  late final cardOffsetAnimationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: kCardDuration1000ms));
  late final cardOffsetTween = Tween<double>(begin: 0, end: cardSize * 2)
      .chain(CurveTween(curve: Curves.easeInBack));

  late final cardRotationTween = Tween<double>(begin: 0, end: 0.5)
      .chain(CurveTween(curve: Curves.easeInBack));

  late final cardElevationTween = Tween<double>(begin: 5, end: 50);

  double get cardOffset =>
      cardOffsetTween.evaluate(cardOffsetAnimationController);

  double get cardRotation =>
      cardRotationTween.evaluate(cardOffsetAnimationController);

  double get cardElevation =>
      cardElevationTween.evaluate(cardOffsetAnimationController);

  @override
  void initState() {
    super.initState();
    holeAnimationController.addListener(() => setState(() {}));
    cardOffsetAnimationController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    holeAnimationController.dispose();
    cardOffsetAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              holeAnimationController.forward();
              await cardOffsetAnimationController.forward();

              Future.delayed(const Duration(milliseconds: kDuration200ms),
                  () => holeAnimationController.reverse());
            },
            backgroundColor: kButtonColor,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(
            width: kSP20x,
          ),
          FloatingActionButton(
            onPressed: () {
              cardOffsetAnimationController.reverse();
              holeAnimationController.reverse();
            },
            backgroundColor: kButtonColor,
            child: const Icon(Icons.add),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: kGradientColor,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: kSP20x,
              ),
              SizedBox(
                width: kLogoWidth150x,
                height: kLogoHeight200x,
                child: Image.asset(kLogoPath),
              ),
              const SizedBox(
                height: kSP20x,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(kBorderRadius10x)),
                    border:
                        Border.all(width: kBorderWidth3x, color: kButtonColor)),
                width: kTextFieldWidth300x,
                child: TextField(
                  controller: textEditingController,
                  onSubmitted: (e) {
                    text = textEditingController.text;
                    setState(() {});
                    textEditingController.clear();
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: kHintText),
                ),
              ),
              const SizedBox(
                height: kSP50x,
              ),
              SizedBox(
                height: cardSize * 1.5,
                child: ClipPath(
                  clipper: BlackHoleClipper(),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned(
                        top: kSP20x,
                        child: SizedBox(
                            width: holeSize,
                            child: Image.asset(
                              kBlackHolePath,
                              fit: BoxFit.fill,
                            )),
                      ),
                      Positioned(
                          child: Center(
                        child: Transform.translate(
                            offset: Offset(0, cardOffset),
                            child: Transform.rotate(
                                angle: cardRotation,
                                child: HelloWorldCard(
                                  text: text,
                                  size: cardSize,
                                  elevation: cardElevation,
                                ))),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlackHoleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, size.height / 2);
    path.arcTo(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width,
            height: size.height),
        0,
        pi,
        true);
    path.lineTo(0, -1000);
    path.lineTo(size.width, -1000);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class HelloWorldCard extends StatelessWidget {
  const HelloWorldCard(
      {Key? key,
      required this.size,
      required this.elevation,
      required this.text})
      : super(key: key);

  final double size, elevation;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(kBorderRadius10x),
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadius10x),
              color: kButtonColor),
          child: Center(
              child: Text(
            text,
            style: const TextStyle(color: kWhite, fontWeight: kFontWeightBold),
          )),
        ),
      ),
    );
  }
}
