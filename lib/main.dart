import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/app/app.dart';
import 'package:taskboard/app/providers.dart';

void main() =>
    runApp(MultiProvider(providers: buildProviders(), child: const App()));
