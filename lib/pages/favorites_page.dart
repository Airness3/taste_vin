import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'sommelier_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() =>
      _FavoritesPageState();
}

class _FavoritesPageState
    extends State<FavoritesPage> {
  final SupabaseClient supabase =
      Supabase.instance.client;

  bool _loading = true;

  List<Map<String, dynamic>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final user =
          supabase.auth.currentUser;

      if (user == null) {
        return;
      }

      final List<dynamic> results =
          await supabase
              .from('historique_scans')
              .select()
              .eq(
                'profil_id',
                user.id,
              )
              .eq(
                'favori',
                true,
              )
              .order(
                'date_scan',
                ascending: false,
              );

      final List<Map<String, dynamic>>
          wines = [];

      for (final item in results) {
        final wine =
            Map<String, dynamic>.from(
          item,
        );

        final imagePath =
            wine['image_path']
                ?.toString();

        if (imagePath != null &&
            imagePath.isNotEmpty &&
            !imagePath.startsWith(
              '/data/',
            )) {
          try {
            wine['signed_image_url'] =
                await supabase.storage
                    .from(
                      'scan-images',
                    )
                    .createSignedUrl(
                      imagePath,
                      3600,
                    );
          } catch (_) {}
        }

        wines.add(wine);
      }

      if (!mounted) return;

      setState(() {
        _favorites = wines;
        _loading = false;
      });
    } catch (e) {
      debugPrint(
        'ERREUR FAVORIS : $e',
      );

      setState(() {
        _loading = false;
      });
    }
  }

  void _openSommelier(
    Map<String, dynamic> wine,
  ) {
    if (wine['wine_profile'] == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Cette fiche ne contient pas de profil complet.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SommelierPage(
          wineProfile:
              Map<String, dynamic>.from(
            wine['wine_profile'],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFFFFBF9),
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF0A3D2E),
        title: const Text(
          'Mes favoris',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme:
            const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: _loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : _favorites.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 70,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Aucun favori pour le moment',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  itemCount:
                      _favorites.length,
                  itemBuilder:
                      (context, index) {
                    final wine =
                        _favorites[index];

                    return Card(
                      elevation: 4,
                      margin:
                          const EdgeInsets.only(
                        bottom: 16,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),
                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                        onTap: () {
                          _openSommelier(
                            wine,
                          );
                        },
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            if (wine[
                                    'signed_image_url'] !=
                                null)
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.vertical(
                                  top:
                                      Radius.circular(
                                    20,
                                  ),
                                ),
                                child: Image.network(
                                  wine[
                                      'signed_image_url'],
                                  height: 220,
                                  width: double
                                      .infinity,
                                  fit: BoxFit
                                      .contain,
                                ),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.all(
                                16,
                              ),
                              child:
                                  Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.favorite,
                                        color:
                                            Colors.red,
                                      ),
                                      const SizedBox(
                                        width:
                                            8,
                                      ),
                                      Expanded(
                                        child:
                                            Text(
                                          wine['appellation_nom'] ??
                                              '',
                                          style:
                                              const TextStyle(
                                            fontSize:
                                                19,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height:
                                        8,
                                  ),
                                  Text(
                                    wine['millesime'] !=
                                            null
                                        ? 'Millésime ${wine['millesime']}'
                                        : 'Millésime inconnu',
                                  ),
                                  const SizedBox(
                                    height:
                                        8,
                                  ),
                                  Text(
                                    wine['resume_scan'] ??
                                        '',
                                    maxLines:
                                        2,
                                    overflow:
                                        TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height:
                                        12,
                                  ),
                                  SizedBox(
                                    width: double
                                        .infinity,
                                    child:
                                        ElevatedButton.icon(
                                      onPressed:
                                          () {
                                        _openSommelier(
                                          wine,
                                        );
                                      },
                                      icon:
                                          const Icon(
                                        Icons
                                            .restaurant_menu,
                                      ),
                                      label:
                                          const Text(
                                        'Voir la fiche sommelier',
                                      ),
                                      style:
                                          ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(
                                          0xFF0A3D2E,
                                        ),
                                        foregroundColor:
                                            Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}