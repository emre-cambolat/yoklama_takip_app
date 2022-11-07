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
  Widget _loadingIndicator(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          widget.child,
          widget.isLoading ? _loadingIndicator(context) : SizedBox.shrink(),
        ],
      ),
    );
  }
}
