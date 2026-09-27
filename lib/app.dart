import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/chat/presentation/screens/chat_screen.dart';

class ChatbotApp extends StatelessWidget {
  const ChatbotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chatbot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const ChatScreen(),
    );
  }
}