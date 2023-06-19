

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class progress extends StatefulWidget {
  const progress({Key? key}) : super(key: key);

  @override
  State<progress> createState() => _progressState();
}

class _progressState extends State<progress> {


  bool _showProgress = true;

  @override
  void initState() {
    super.initState();

    // Start a timer to hide the progress indicator after a specific duration
    Timer(Duration(seconds: 3), () {
      setState(() {
        _showProgress = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_showProgress)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
