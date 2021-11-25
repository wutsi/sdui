import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef LoadingStateBuilder = Widget Function(BuildContext context);

/// Loading state
// ignore: prefer_function_declarations_over_variables
LoadingStateBuilder sduiLoadingState = (context) =>
    Scaffold(
      appBar: AppBar(
        title: const Text('Loading...'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: CircularProgressIndicator()
      )
    );
