import 'package:flutter/material.dart';
import 'package:uasendemic/model/endemik.dart';
import 'package:uasendemic/providers/favorit_providers.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';

class DetailsScreen extends StatelessWidget {
  final Endemik bird; // Tetap Endemik

  const DetailsScreen({Key? key, required this.bird}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(bird.nama)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      backgroundColor: Colors.black,
                      appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      body: Center(
                        child: PhotoView(
                          imageProvider: NetworkImage(bird.foto),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Image.network(
                bird.foto,
                height: 250, // Tetapkan tinggi agar tidak terlalu panjang
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/placeholder.png', // Pastikan path ini benar
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bird.nama,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    bird.nama_latin,
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Deskripsi:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(bird.deskripsi ?? 'Deskripsi tidak tersedia.'),
                  SizedBox(height: 16),
                  Text(
                    'Asal:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(bird.asal ?? 'Asal tidak tersedia.'),
                  SizedBox(height: 16),
                  Text(
                    'Status:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(bird.status ?? 'Status tidak tersedia.'),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          bird.is_favorit == "true" ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 30,
                        ),
                        onPressed: () {
                          // Toggle favorit di provider
                          // Kita tidak memanggil toggleFavorite di sini secara langsung lagi
                          // Karena perubahan is_favorit akan dihandle oleh HomeScreen
                          // dan FavoriteProvider akan otomatis bereaksi.
                          if (bird.is_favorit == "true") {
                            favoriteProvider.removeFavorite(bird);
                          } else {
                            favoriteProvider.addFavorite(bird);
                          }
                          // Penting: panggil setState pada objek bird (jika mutable) atau
                          // markNeedsBuild() untuk me-render ulang tampilan ini.
                          // Karena bird adalah final, kita harus memaksa render.
                          (context as Element).markNeedsBuild(); // Memaksa rebuild widget
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}