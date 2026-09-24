import 'package:flutter/material.dart';
import '../../domain/entities/tv_show.dart';

class TVShowCard extends StatelessWidget {
  final TVShow tvShow;
  final VoidCallback onTap;

  const TVShowCard({
    super.key,
    required this.tvShow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF1A1A2E),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Poster
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  tvShow.posterUrl != null
                      ? Image.network(
                          tvShow.posterUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                  // Note overlay
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _ratingColor(tvShow.voteAverage ?? 0),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: _ratingColor(tvShow.voteAverage ?? 0),
                            size: 12,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            (tvShow.voteAverage ?? 0).toStringAsFixed(1),
                            style: TextStyle(
                              color: _ratingColor(tvShow.voteAverage ?? 0),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Badge Série
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Série',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Titre & Année
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tvShow.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  if (tvShow.firstAirDate != null && tvShow.firstAirDate!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      tvShow.firstAirDate!.split('-').first,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFF252540),
      child: const Center(
        child: Icon(Icons.tv_rounded, color: Colors.white24, size: 40),
      ),
    );
  }

  Color _ratingColor(double rating) {
    if (rating >= 7.5) return const Color(0xFF4CAF50);
    if (rating >= 5.0) return const Color(0xFFFFC107);
    return const Color(0xFFE53935);
  }
}
