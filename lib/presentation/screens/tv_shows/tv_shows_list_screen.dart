import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../domain/entities/tv_show.dart';
import '../../blocs/tv_shows/tv_show_bloc.dart';
import '../../blocs/tv_shows/tv_show_event.dart';
import '../../blocs/tv_shows/tv_show_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../widgets/tv_show_card.dart';
import '../../widgets/offline_banner.dart';

class TVShowsListScreen extends StatefulWidget {
  const TVShowsListScreen({super.key});

  @override
  State<TVShowsListScreen> createState() => _TVShowsListScreenState();
}

class _TVShowsListScreenState extends State<TVShowsListScreen> {
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
      context.read<TVShowBloc>().add(LoadMoreTVShows());
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
      create: (_) => getIt<TVShowBloc>()..add(const LoadTVShows()),
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
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                  title: const Text(
                    'Séries TV',
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
            body: BlocConsumer<TVShowBloc, TVShowState>(
              listener: (context, state) {
                if (state is TVShowError && state.cachedTVShows.isEmpty) {
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
                if (state is TVShowLoading) {
                  return _buildShimmerGrid();
                }

                if (state is TVShowError && state.cachedTVShows.isEmpty) {
                  return _buildErrorState(context, state.message);
                }

                final tvShows = state is TVShowLoaded
                    ? state.tvShows
                    : (state is TVShowError ? state.cachedTVShows : <TVShow>[]);
                final isOffline = state is TVShowLoaded && state.isOffline;
                final isLoadingMore = state is TVShowLoadingMore;

                return Column(
                  children: [
                    if (isOffline) const OfflineBanner(),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<TVShowBloc>().add(const LoadTVShows(refresh: true));
                          await Future.delayed(const Duration(milliseconds: 800));
                        },
                        color: const Color(0xFF3B82F6),
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
                                  (context, index) => TVShowCard(
                                    tvShow: tvShows[index],
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(tvShows[index].title),
                                          backgroundColor: const Color(0xFF1A1A2E),
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                  ),
                                  childCount: tvShows.length,
                                ),
                              ),
                            ),
                            if (isLoadingMore)
                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.all(24),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF3B82F6),
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
                  color: Color(0xFF3B82F6), size: 40),
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
                  context.read<TVShowBloc>().add(const LoadTVShows(refresh: true)),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
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
        currentIndex: 1,
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: Colors.white38,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) Navigator.of(context).pushReplacementNamed('/home');
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
