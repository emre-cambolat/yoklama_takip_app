import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class LoadingListenerUI extends StatefulWidget {
  const LoadingListenerUI(
      {Key? key, required this.child, required this.isLoading})
      : super(key: key);

  final Widget child;
  final bool isLoading;

  @override
  State<LoadingListenerUI> createState() => _LoadingListenerUIState();
}

class _LoadingListenerUIState extends State<LoadingListenerUI> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          widget.child,
          widget.isLoading ? _LoadingIndicator(context: context) : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.3),
      child: CircularProgressIndicator(
        color: AppColors.primaryColor,
      ),
    );
  }
}
