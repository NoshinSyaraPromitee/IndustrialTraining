import 'package:flutter/material.dart';
import 'package:taskboard/core/lego/brick.dart';
import 'package:taskboard/features/projects/presentation/projects_panel.dart';

final projectsBrick = PanelBrick(
  id: 'projects',
  label: 'Projects',
  icon: Icons.folder_outlined,
  flex: 3,
  build: (_) => const ProjectsPanel(),
);
