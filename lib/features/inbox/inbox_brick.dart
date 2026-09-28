import 'package:flutter/material.dart';
import 'package:taskboard/core/lego/brick.dart';
import 'package:taskboard/features/inbox/presentation/inbox_panel.dart';

final inboxBrick = PanelBrick(
  id: 'inbox',
  label: 'Inbox',
  icon: Icons.inbox_outlined,
  flex: 3,
  build: (_) => const InboxPanel(),
);
