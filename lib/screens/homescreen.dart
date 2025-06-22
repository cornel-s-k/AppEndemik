// lib/screens/homescreen.dart
import 'package:flutter/material.dart';
import 'package:uasendemic/model/endemik.dart';
import 'package:uasendemic/helper/databasehelper.dart';
import 'package:uasendemic/screens/detailsscreen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:uasendemic/services/apiservice.dart';
import 'package:uasendemic/providers/favorit_providers.dart'; // Import FavoriteProvider
import 'package:provider/provider.dart'; // Import provider

// Import halaman favorit
import 'package:uasendemic/screens/favoritescreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Index tab yang aktif: 0 untuk Home, 1 untuk Favorit
  List<Endemik> allEndemiks = []; // Menyimpan semua data endemik
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllEndemiks(); // Muat semua data saat inisialisasi
  }

  // Fungsi untuk memuat semua data endemik dari service
  Future<void> _loadAllEndemiks() async {
    final EndemikService endemikService = EndemikService();
    try {
      final List<Endemik> fetchedEndemiks = await endemikService.getData();
      setState(() {
        allEndemiks = fetchedEndemiks;
        isLoading = false;
      });
      debugPrint("Data berhasil dimuat: ${allEndemiks.length} endemik.");
    } catch (e) {
      debugPrint("Gagal memuat data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk mengubah status favorit di database dan UI
  void toggleFavorite(Endemik endemik) async {
    final dbHelper = DatabaseHelper();
    String newFavoriteStatus = endemik.is_favorit == "true" ? "false" : "true";

    try {
      // Panggil setFavorit dari DatabaseHelper
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
      debugPrint("Error toggling favorite: $e");
      // Handle error, maybe show a snackbar
    }
  }

  // Fungsi untuk menampilkan gambar full screen
  void showFullScreenImage(BuildContext context, String imageUrl) {
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
              imageProvider: NetworkImage(imageUrl),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 1.8,
              initialScale: PhotoViewComputedScale.contained,
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk daftar semua endemik (tab Home)
  Widget _buildHomeContent() {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : allEndemiks.isEmpty
        ? Center(child: Text("Tidak ada data endemik"))
        : GridView.builder( // Mengubah ListView menjadi GridView
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 kolom seperti di gambar
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75, // Sesuaikan rasio agar gambar dan teks pas
      ),
      itemCount: allEndemiks.length,
      itemBuilder: (context, index) {
        Endemik endemik = allEndemiks[index];
        return Card(
          clipBehavior: Clip.antiAlias, // Untuk memastikan gambar pas di Card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 4,
          child: InkWell( // Tambahkan InkWell agar seluruh Card bisa di-tap
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(bird: endemik), // Mengirim objek Endemik
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => showFullScreenImage(context, endemik.foto), // Gunakan endemik.foto
                    child: Image.network(
                      endemik.foto, // Gunakan endemik.foto
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Icon(Icons.broken_image, size: 50));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        endemik.nama, // Gunakan endemik.nama
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        endemik.nama_latin, // Gunakan endemik.nama_latin
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
                      endemik.is_favorit == "true" // Cek status string "true"/"false"
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
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
  }

  // Mengelola pemilihan tab di BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EndemicDB')),
      body: _selectedIndex == 0
          ? _buildHomeContent() // Konten untuk tab Home
          : FavoriteScreen(), // Konten untuk tab Favorit

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor, // Warna aktif
        onTap: _onItemTapped,
      ),
    );
  }
}