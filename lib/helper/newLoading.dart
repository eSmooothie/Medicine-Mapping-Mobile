import 'package:flutter/material.dart';

class NewLoading extends StatefulWidget {
  final IconData loadingIcon;
  const NewLoading({Key? key, required this.loadingIcon}) : super(key: key);

  @override
  _NewLoadingState createState() => _NewLoadingState();
}

class _NewLoadingState extends State<NewLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 30.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        child: Icon(
          widget.loadingIcon,
          size: 50,
          color: Colors.white,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(255, 27, 28, 30),
            boxShadow: [
              BoxShadow(
                  color: Colors.blue.shade200,
                  blurRadius: _animation.value,
                  spreadRadius: _animation.value)
            ]),
      ),
    );
  }
}
