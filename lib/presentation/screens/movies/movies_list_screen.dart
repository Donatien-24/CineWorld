import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../domain/entities/movie.dart';
import '../../blocs/movies/movie_bloc.dart';
import '../../blocs/movies/movie_event.dart';
import '../../blocs/movies/movie_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../widgets/movie_card.dart';
import '../../widgets/offline_banner.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<MovieBloc>().add(LoadMoreMovies());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    return current >= (max - 400);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MovieBloc>()..add(const LoadMovies()),
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1A),
        body: Builder(
          builder: (context) => NestedScrollView(
            headerSliverBuilder: (context, _) => [
              SliverAppBar(
                backgroundColor: const Color(0xFF0F0F1A),
                expandedHeight: 120,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  title: const Text(
                    'CineVault',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1A)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout_rounded, color: Colors.white70),
                    tooltip: 'Se déconnecter',
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
            body: BlocConsumer<MovieBloc, MovieState>(
              listener: (context, state) {
                if (state is MovieError && state.cachedMovies.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white),
                          const SizedBox(width: 10),
                          Expanded(child: Text(state.message)),
                        ],
                      ),
                      backgroundColor: const Color(0xFFE53935),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is MovieLoading) {
                  return _buildShimmerGrid();
                }

                if (state is MovieError && state.cachedMovies.isEmpty) {
                  return _buildErrorState(context, state.message);
                }

                final movies = state is MovieLoaded
                    ? state.movies
                    : (state is MovieError ? state.cachedMovies : <Movie>[]);
                final isOffline = state is MovieLoaded && state.isOffline;
                final isLoadingMore = state is MovieLoadingMore;

                return Column(
                  children: [
                    if (isOffline) const OfflineBanner(),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<MovieBloc>().add(const LoadMovies(refresh: true));
                          await Future.delayed(const Duration(milliseconds: 800));
                        },
                        color: const Color(0xFF6C63FF),
                        backgroundColor: const Color(0xFF1A1A2E),
                        child: CustomScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.all(16),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.62,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => MovieCard(
                                    movie: movies[index],
                                    onTap: () => Navigator.of(context).pushNamed(
                                      '/movie-detail',
                                      arguments: movies[index],
                                    ),
                                  ),
                                  childCount: movies.length,
                                ),
                              ),
                            ),
                            if (isLoadingMore)
                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.all(24),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF6C63FF),
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNav(context),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: 8,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF1A1A2E),
        ),
        child: const _ShimmerPulse(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  color: Color(0xFF6C63FF), size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              'Connexion impossible',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<MovieBloc>().add(const LoadMovies(refresh: true)),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xFF6C63FF),
        unselectedItemColor: Colors.white38,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) Navigator.of(context).pushReplacementNamed('/tv-shows');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_rounded),
            label: 'Films',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv_rounded),
            label: 'Séries',
          ),
        ],
      ),
    );
  }
}

/// Widget de chargement shimmer animé
class _ShimmerPulse extends StatefulWidget {
  const _ShimmerPulse();

  @override
  State<_ShimmerPulse> createState() => _ShimmerPulseState();
}

class _ShimmerPulseState extends State<_ShimmerPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 0.7).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withValues(alpha: _anim.value * 0.08),
        ),
      ),
    );
  }
}
