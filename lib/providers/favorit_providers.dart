import 'package:flutter/material.dart';
import 'package:uasendemic/model/endemik.dart'; // Ubah dari 'endemik.dart' ke 'endemik.dart'

class FavoriteProvider with ChangeNotifier {
  List<Endemik> _favorites = []; // Ubah tipe dari Bird menjadi Endemik

  List<Endemik> get favorites => _favorites; // Ubah tipe

  void addFavorite(Endemik bird) { // Ubah tipe
    if (!_favorites.contains(bird)) { // Tambahkan cek untuk menghindari duplikasi
      _favorites.add(bird);
      bird.is_favorit = "true"; // Perbarui status favorit di objek
      notifyListeners();
    }
  }

  void removeFavorite(Endemik bird) { // Ubah tipe
    if (_favorites.remove(bird)) { // remove mengembalikan true jika berhasil menghapus
      bird.is_favorit = "false"; // Perbarui status favorit di objek
      notifyListeners();
    }
  }

  bool isFavorite(Endemik bird) { // Ubah tipe
    return _favorites.contains(bird);
  }
}