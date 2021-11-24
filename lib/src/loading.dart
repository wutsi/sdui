import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef LoadingStateBuilder = Widget Function(BuildContext context);

/// Loading state
// ignore: prefer_function_declarations_over_variables
LoadingStateBuilder sduiLoadingState = (context) =>  const CircularProgressIndicator();
