import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'sommelier_page.dart';

class CellarPage extends StatefulWidget {
  const CellarPage({
    super.key,
  });

  @override
  State<CellarPage> createState() =>
      _CellarPageState();
}

class _CellarPageState extends State<CellarPage> {
  final SupabaseClient supabase =
      Supabase.instance.client;

  bool _loading = true;
  String? _errorMessage;

  List<Map<String, dynamic>> _wines = [];

  @override
  void initState() {
    super.initState();
    _loadCellar();
  }

  Future<void> _loadCellar() async {
    try {
      if (mounted) {
        setState(() {
          _loading = true;
          _errorMessage = null;
        });
      }

      final User? user =
          supabase.auth.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          _loading = false;
          _errorMessage =
              'Vous devez être connecté pour consulter votre cave.';
        });

        return;
      }

      final List<dynamic> results =
          await supabase
              .from('historique_scans')
              .select()
              .eq('profil_id', user.id)
              .order(
                'date_scan',
                ascending: false,
              );

      final List<Map<String, dynamic>>
          loadedWines = [];

      for (final dynamic item in results) {
        final Map<String, dynamic> wine =
            Map<String, dynamic>.from(
          item as Map,
        );

        final String? imagePath =
            wine['image_path']?.toString();

        wine['signed_image_url'] =
            await _createSignedImageUrl(
          imagePath,
        );

        loadedWines.add(wine);
      }

      if (!mounted) return;

      setState(() {
        _wines = loadedWines;
        _loading = false;
      });
    } catch (e) {
      debugPrint(
        'ERREUR CHARGEMENT CAVE : $e',
      );

      if (!mounted) return;

      setState(() {
        _loading = false;
        _errorMessage =
            'Impossible de charger votre cave.';
      });
    }
  }

  Future<String?> _createSignedImageUrl(
    String? imagePath,
  ) async {
    if (imagePath == null ||
        imagePath.trim().isEmpty) {
      return null;
    }

    // Les anciens scans peuvent contenir un chemin
    // temporaire Android. Ces chemins ne sont pas
    // disponibles dans Supabase Storage.
    if (imagePath.startsWith('/data/') ||
        imagePath.startsWith('file://')) {
      return null;
    }

    try {
      return await supabase.storage
          .from('scan-images')
          .createSignedUrl(
            imagePath,
            3600,
          );
    } catch (e) {
      debugPrint(
        'PHOTO INDISPONIBLE : '
        '$imagePath | $e',
      );

      return null;
    }
  }
Future<void> _confirmDeleteWine(
  Map<String, dynamic> wine,
) async {
  final String appellation =
      wine['appellation_nom']
              ?.toString()
              .trim() ??
          'ce vin';

  final bool? confirmed =
      await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(22),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.delete_outline,
              color: Color(0xFF9A3040),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Supprimer cette fiche ?',
                style: TextStyle(
                  color: Color(0xFF15382E),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          '« $appellation » sera supprimé de votre cave. '
          'Cette action est définitive.',
          style: const TextStyle(
            color: Colors.black87,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                dialogContext,
                false,
              );
            },
            child: const Text(
              'Annuler',
              style: TextStyle(
                color: Color(0xFF5F6965),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(
                dialogContext,
                true,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF9A3040),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(
              Icons.delete_outline,
            ),
            label: const Text(
              'Supprimer',
            ),
          ),
        ],
      );
    },
  );

  if (confirmed != true) {
    return;
  }

  await _deleteWine(wine);
}

Future<void> _deleteWine(
  Map<String, dynamic> wine,
) async {
  try {
    final dynamic scanId = wine['id'];
    final String? imagePath =
        wine['image_path']?.toString();

    if (scanId == null) {
      throw Exception(
        'Identifiant de la fiche introuvable.',
      );
    }

    // Suppression de la ligne dans historique_scans.
    await supabase
        .from('historique_scans')
        .delete()
        .eq('id', scanId);

    // Suppression de la photo persistante.
    // Les anciens chemins Android temporaires sont ignorés.
    if (imagePath != null &&
        imagePath.isNotEmpty &&
        !imagePath.startsWith('/data/') &&
        !imagePath.startsWith('file://')) {
      try {
        await supabase.storage
            .from('scan-images')
            .remove([
          imagePath,
        ]);
      } catch (storageError) {
        debugPrint(
          'PHOTO NON SUPPRIMÉE : $storageError',
        );
      }
    }

    if (!mounted) return;

    setState(() {
      _wines.removeWhere(
        (item) => item['id'] == scanId,
      );
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Fiche supprimée de votre cave.',
        ),
      ),
    );
  } catch (e) {
    debugPrint(
      'ERREUR SUPPRESSION CAVE : $e',
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          'Impossible de supprimer la fiche : $e',
        ),
      ),
    );
  }
}
  Future<void> _toggleFavorite(
  Map<String, dynamic> wine,
) async {
  try {
    final bool newValue =
        !(wine['favori'] ?? false);

    await supabase
        .from('historique_scans')
        .update({
      'favori': newValue,
    })
        .eq(
      'id',
      wine['id'],
    );

    setState(() {
      wine['favori'] = newValue;
    });
  } catch (e) {
    debugPrint(
      'ERREUR FAVORI : $e',
    );
  }
}
  void _openSommelier(
    Map<String, dynamic> wine,
  ) {
    final dynamic storedProfile =
        wine['wine_profile'];

    if (storedProfile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Cette bouteille a été enregistrée '
            'avant la sauvegarde des fiches complètes.',
          ),
        ),
      );

      return;
    }

    if (storedProfile is! Map) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'La fiche sommelier enregistrée '
            'ne peut pas être ouverte.',
          ),
        ),
      );

      return;
    }

    final Map<String, dynamic> wineProfile =
        Map<String, dynamic>.from(
      storedProfile,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SommelierPage(
          wineProfile: wineProfile,
        ),
      ),
    );
  }

  String _formatDate(dynamic value) {
    if (value == null) {
      return 'Date inconnue';
    }

    final DateTime? date =
        DateTime.tryParse(
      value.toString(),
    )?.toLocal();

    if (date == null) {
      return 'Date inconnue';
    }

    final String day =
        date.day.toString().padLeft(2, '0');

    final String month =
        date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  String _colorName(dynamic colorId) {
    switch (colorId) {
      case 1:
        return 'Blanc';
      case 2:
        return 'Rouge';
      case 3:
        return 'Rosé';
      case 4:
        return 'Effervescent';
      case 5:
        return 'Orange';
      default:
        return 'Couleur non renseignée';
    }
  }

  IconData _colorIcon(dynamic colorId) {
    switch (colorId) {
      case 4:
        return Icons.bubble_chart;
      default:
        return Icons.wine_bar;
    }
  }

  Color _colorAccent(dynamic colorId) {
    switch (colorId) {
      case 1:
        return const Color(0xFFD4AF37);
      case 2:
        return const Color(0xFF7A1734);
      case 3:
        return const Color(0xFFE9868C);
      case 4:
        return const Color(0xFFC8A84E);
      case 5:
        return const Color(0xFFE87828);
      default:
        return const Color(0xFF0A3D2E);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFFFFBF9),
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF0A3D2E),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Ma Cave',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed:
                _loading ? null : _loadCellar,
            tooltip: 'Actualiser',
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF0A3D2E),
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_wines.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      color: const Color(0xFF0A3D2E),
      onRefresh: _loadCellar,
      child: CustomScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              4,
              16,
              28,
            ),
            sliver: SliverList(
              delegate:
                  SliverChildBuilderDelegate(
                (context, index) {
                  return _buildWineCard(
                    _wines[index],
                  );
                },
                childCount: _wines.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final int count = _wines.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        18,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF0A3D2E),
              borderRadius:
                  BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF0A3D2E,
                  ).withOpacity(0.20),
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: const Icon(
              Icons.wine_bar,
              color: Color(0xFFD9A15B),
              size: 27,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vos bouteilles',
                  style: TextStyle(
                    color: Color(0xFF0A3D2E),
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  count > 1
                      ? '$count vins enregistrés'
                      : '$count vin enregistré',
                  style: const TextStyle(
                    color: Color(0xFF6B746F),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWineCard(
    Map<String, dynamic> wine,
  ) {
    final String appellation =
        wine['appellation_nom']
                ?.toString()
                .trim() ??
            'Vin non identifié';

    final String? millesime =
        wine['millesime']?.toString();

    final String resume =
        wine['resume_scan']
                ?.toString()
                .trim() ??
            '';

    final String? imageUrl =
        wine['signed_image_url']
            ?.toString();

    final dynamic colorId =
        wine['couleur_id'];

    final Color accent =
        _colorAccent(colorId);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color: const Color(
            0xFF0A3D2E,
          ).withOpacity(0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.08,
            ),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _buildPhoto(
              wine: wine,
              imageUrl: imageUrl,
              accent: accent,
            ),
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                18,
                17,
                18,
                18,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      IconButton(
  onPressed: () {
    _toggleFavorite(wine);
  },
  icon: Icon(
    wine['favori'] == true
        ? Icons.favorite
        : Icons.favorite_border,
    color:
        wine['favori'] == true
            ? Colors.red
            : Colors.grey,
  ),
),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color:
                              accent.withOpacity(
                            0.12,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            13,
                          ),
                        ),
                        child: Icon(
                          _colorIcon(colorId),
                          color: accent,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              appellation,
                              style:
                                  const TextStyle(
                                color:
                                    Color(0xFF15382E),
                                fontSize: 19,
                                height: 1.18,
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                _buildInfoChip(
                                  icon:
                                      Icons.calendar_month,
                                  text: millesime !=
                                          null
                                      ? 'Millésime $millesime'
                                      : 'Millésime inconnu',
                                ),
                                _buildInfoChip(
                                  icon: Icons
                                      .local_drink_outlined,
                                  text: _colorName(
                                    colorId,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (resume.isNotEmpty &&
                      resume != appellation) ...[
                    const SizedBox(height: 13),
                    Text(
                      resume,
                      maxLines: 3,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF68726D),
                        height: 1.4,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(
                        Icons.history,
                        color: Color(0xFF89918D),
                        size: 17,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Ajouté le ${_formatDate(wine['date_scan'])}',
                        style: const TextStyle(
                          color:
                              Color(0xFF89918D),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
  children: [
    Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton.icon(
          onPressed: () {
            _openSommelier(wine);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFF0A3D2E),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(15),
            ),
          ),
          icon: const Icon(
            Icons.restaurant_menu,
            size: 19,
          ),
          label: const Text(
            'Voir la fiche',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ),
    const SizedBox(width: 10),
    SizedBox(
      width: 52,
      height: 50,
      child: OutlinedButton(
        onPressed: () {
          _confirmDeleteWine(wine);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor:
              const Color(0xFF9A3040),
          side: const BorderSide(
            color: Color(0xFF9A3040),
          ),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15),
          ),
        ),
        child: const Icon(
          Icons.delete_outline,
          size: 22,
        ),
      ),
    ),
  ],
),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto({
    required Map<String, dynamic> wine,
    required String? imageUrl,
    required Color accent,
  }) {
    return Material(
      color: const Color(0xFFF0EEE9),
      child: InkWell(
        onTap: () {
          _openSommelier(wine);
        },
        child: Stack(
          children: [
            Container(
  width: double.infinity,
  height: 260,
  color: const Color(0xFFF1EEE8),
  padding: const EdgeInsets.all(10),
  child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (
                        context,
                        child,
                        progress,
                      ) {
                        if (progress == null) {
                          return child;
                        }

                        return const Center(
                          child:
                              CircularProgressIndicator(
                            color:
                                Color(0xFF0A3D2E),
                          ),
                        );
                      },
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return _buildImageFallback(
                          accent,
                        );
                      },
                    )
                  : _buildImageFallback(
                      accent,
                    ),
            ),
            Positioned(
              top: 13,
              right: 13,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(
                    0.62,
                  ),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Ouvrir la fiche',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageFallback(
    Color accent,
  ) {
    return Container(
      width: double.infinity,
      height: 260,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0A3D2E),
            accent.withOpacity(0.88),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wine_bar,
            color: Colors.white,
            size: 54,
          ),
          SizedBox(height: 10),
          Text(
            'Photo non disponible',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F3),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color(0xFF4A625A),
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF4A625A),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      color: const Color(0xFF0A3D2E),
      onRefresh: _loadCellar,
      child: ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(28),
        children: [
          const SizedBox(height: 90),
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: const Color(
                0xFF0A3D2E,
              ).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wine_bar_outlined,
              color: Color(0xFF0A3D2E),
              size: 55,
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Votre cave est vide',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF0A3D2E),
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Scannez une bouteille puis utilisez '
            'le bouton « Ajouter à ma cave ».',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6B746F),
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Color(0xFF8C2E36),
              size: 55,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ??
                  'Une erreur est survenue.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF513F40),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadCellar,
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF0A3D2E),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(
                Icons.refresh,
              ),
              label: const Text(
                'Réessayer',
              ),
            ),
          ],
        ),
      ),
    );
  }
}