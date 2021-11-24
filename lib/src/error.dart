import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef ErrorStateBuilder = Widget Function(BuildContext context, Object? error);

/// Error state
// ignore: prefer_function_declarations_over_variables
ErrorStateBuilder sduiErrorState = (context, error) =>  const Icon(Icons.error);
