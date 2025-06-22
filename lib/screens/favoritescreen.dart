// lib/screens/favoritescreen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uasendemic/providers/favorit_providers.dart';
import 'package:uasendemic/model/endemik.dart';
import 'package:uasendemic/screens/detailsscreen.dart'; // Untuk navigasi ke detail
import 'package:uasendemic/helper/databasehelper.dart'; // Untuk toggle favorit

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // Fungsi toggle favorit untuk FavoriteScreen
  void toggleFavorite(Endemik endemik) async {
    final dbHelper = DatabaseHelper();
    String newFavoriteStatus = endemik.is_favorit == "true" ? "false" : "true";

    try {
      await dbHelper.setFavorit(endemik.id!, newFavoriteStatus);

      // Perbarui status di objek Endemik lokal
      setState(() {
        endemik.is_favorit = newFavoriteStatus;
      });

      // Beritahu FavoriteProvider tentang perubahan
      final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
      if (newFavoriteStatus == "true") {
        favoriteProvider.addFavorite(endemik);
      } else {
        favoriteProvider.removeFavorite(endemik);
      }
    } catch (e) {
      debugPrint("Error toggling favorite from FavoriteScreen: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer untuk hanya me-rebuild bagian tertentu dari widget tree
    // saat favorit berubah.
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        if (favoriteProvider.favorites.isEmpty) {
          return Center(
            child: Text('Tidak ada burung favorit yang ditambahkan.'),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 kolom
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.75, // Sesuaikan rasio
          ),
          itemCount: favoriteProvider.favorites.length,
          itemBuilder: (context, index) {
            Endemik endemik = favoriteProvider.favorites[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(bird: endemik),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.network(
                        endemik.foto,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Icon(Icons.broken_image, size: 50));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            endemik.nama,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            endemik.nama_latin,
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: Icon(
                          endemik.is_favorit == "true" ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          // Karena ini FavoriteScreen, ketika di-toggle, kita akan menghapusnya
                          // dari daftar favorit jika statusnya menjadi "false".
                          toggleFavorite(endemik);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}