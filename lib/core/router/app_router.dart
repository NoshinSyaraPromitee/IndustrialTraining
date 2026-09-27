import 'package:go_router/go_router.dart';
import '../../domain/entities/story.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/story_detail/story_detail_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/story/:id',
      name: 'storyDetail',
      // `extra` is lost on refresh / pasted URLs, so fall back to home
      // instead of crashing on the `as Story` cast.
      redirect: (context, state) => state.extra is Story ? null : '/',
      builder: (context, state) {
        final story = state.extra as Story;
        final imageIndex =
            int.tryParse(state.uri.queryParameters['imageIndex'] ?? '') ?? 0;
        return StoryDetailScreen(story: story, imageIndex: imageIndex);
      },
    ),
  ],
);