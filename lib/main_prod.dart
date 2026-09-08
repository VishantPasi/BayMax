import 'package:flutter/material.dart';
import 'package:baymax/main_common.dart';
import 'package:baymax/env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppEnvironment.setUpEnv(Environment.prod);

  mainCommon();
}