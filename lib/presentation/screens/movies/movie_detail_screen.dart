import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../domain/entities/movie.dart';
import '../../blocs/movie_detail/movie_detail_bloc.dart';
import '../../blocs/movie_detail/movie_detail_event.dart';
import '../../blocs/movie_detail/movie_detail_state.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return BlocProvider(
      create: (_) => getIt<MovieDetailBloc>()..add(LoadMovieDetail(movie)),
      child: _MovieDetailView(movie: movie),
    );
  }
}

class _MovieDetailView extends StatelessWidget {
  final Movie movie;

  const _MovieDetailView({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      body: BlocConsumer<MovieDetailBloc, MovieDetailState>(
        listener: (context, state) {
          if (state is MovieDetailLoaded) {
            // Optionnel: feedback si toggle
          }
        },
        builder: (context, state) {
          final isFavorite = state is MovieDetailLoaded && state.isFavorite;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context, isFavorite),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildHeaderInfo(context),
                      const SizedBox(height: 24),
                      _buildKeyStats(context),
                      const SizedBox(height: 28),
                      _buildActionButtons(context),
                      const SizedBox(height: 32),
                      _buildSynopsisSection(),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isFavorite) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: const Color(0xFF0F0F1A),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                color: isFavorite ? const Color(0xFFFFB800) : Colors.white,
                size: 22,
              ),
              onPressed: () {
                context.read<MovieDetailBloc>().add(ToggleFavoriteMovie(movie));
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite
                          ? 'Retiré de vos favoris'
                          : 'Ajouté à vos favoris !',
                    ),
                    backgroundColor: const Color(0xFF1A1A2E),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (movie.backdropUrl != null || movie.posterUrl != null)
              Image.network(
                movie.backdropUrl ?? movie.posterUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1A1A2E)),
              )
            else
              Container(color: const Color(0xFF1A1A2E)),
            // Dégradé supérieur pour la lisibilité des boutons
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                ),
              ),
            ),
            // Dégradé inférieur vers la couleur de fond
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFF0F0F1A).withValues(alpha: 0.8),
                    const Color(0xFF0F0F1A),
                  ],
                  stops: const [0.4, 0.8, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Poster miniature
        Container(
          width: 95,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: movie.posterUrl != null
              ? Image.network(
                  movie.posterUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPosterPlaceholder(),
                )
              : _buildPosterPlaceholder(),
        ),
        const SizedBox(width: 18),
        // Titre et métadonnées
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 10),
              if (movie.releaseDate != null && movie.releaseDate!.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        color: Color(0xFF6C63FF), size: 14),
                    const SizedBox(width: 6),
                    Text(
                      movie.releaseDate!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                  ),
                ),
                child: const Text(
                  'Film TMDB',
                  style: TextStyle(
                    color: Color(0xFF8B85FF),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPosterPlaceholder() {
    return Container(
      color: const Color(0xFF252540),
      child: const Center(
        child: Icon(Icons.movie_rounded, color: Colors.white24, size: 36),
      ),
    );
  }

  Widget _buildKeyStats(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.star_rounded,
            iconColor: const Color(0xFFFFB800),
            label: 'Score TMDB',
            value: movie.formattedRating,
          ),
          Container(width: 1, height: 35, color: Colors.white.withValues(alpha: 0.1)),
          _buildStatItem(
            icon: Icons.how_to_vote_rounded,
            iconColor: const Color(0xFF3B82F6),
            label: 'Votes',
            value: movie.voteCount != null ? '${movie.voteCount}' : 'N/A',
          ),
          Container(width: 1, height: 35, color: Colors.white.withValues(alpha: 0.1)),
          _buildStatItem(
            icon: Icons.hd_rounded,
            iconColor: const Color(0xFF10B981),
            label: 'Qualité',
            value: 'Full HD',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 16),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lecture de la bande-annonce pour "${movie.title}"'),
                    backgroundColor: const Color(0xFF1A1A2E),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded, size: 22),
              label: const Text(
                'Bande-annonce',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white70),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lien de partage copié pour ${movie.title}'),
                  backgroundColor: const Color(0xFF1A1A2E),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSynopsisSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Synopsis',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          movie.overview != null && movie.overview!.isNotEmpty
              ? movie.overview!
              : 'Aucun synopsis disponible pour ce film.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14.5,
            height: 1.6,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
