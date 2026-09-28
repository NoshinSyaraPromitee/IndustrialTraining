import 'package:flutter/material.dart';
import 'package:taskboard/core/lego/brick.dart';
import 'package:taskboard/features/map/presentation/map_view.dart';

final mapBrick = ViewBrick(
  id: 'map',
  label: 'Map',
  icon: Icons.place_outlined,
  build: (_, close) => TaskMapView(onClose: close),
);
