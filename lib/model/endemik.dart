// lib/model/endemik.dart

// Ubah nama kelas dari Bird menjadi Endemik
class Endemik {
  // Properti harus sesuai dengan kolom di database dan data dari API
  final String? id; // Sesuaikan dengan _columnId TEXT PRIMARY KEY di DatabaseHelper
  final String nama; // Sesuai dengan _columnNama
  final String nama_latin; // Sesuai dengan _columnNamaLatin
  final String deskripsi; // Sesuai dengan _columnDeskripsi
  final String asal; // Sesuai dengan _columnAsal
  final String foto; // Sesuai dengan _columnFoto
  final String status; // Sesuai dengan _columnStatus
  String is_favorit; // Sesuai dengan _columnIsFavorit (string "true" / "false")

  Endemik({
    this.id, // ID dari DB adalah TEXT (String)
    required this.nama,
    required this.nama_latin,
    required this.deskripsi,
    required this.asal,
    required this.foto,
    required this.status,
    this.is_favorit = "false", // Default string "false"
  });

  // Factory constructor untuk data dari API (EndemikService.getData())
  factory Endemik.fromJson(Map<String, dynamic> json) {
    return Endemik(
      id: json["id"] as String, // Pastikan ID dari JSON adalah String
      nama: json["nama"] as String,
      nama_latin: json["nama_latin"] as String,
      deskripsi: json["deskripsi"] as String,
      asal: json["asal"] as String,
      foto: json["foto"] as String,
      status: json["status"] as String,
      is_favorit: json["is_favorit"] as String? ?? "false", // Pastikan ini juga string
    );
  }

  // Factory constructor untuk data dari database lokal (DatabaseHelper.fromMap)
  factory Endemik.fromMap(Map<String, dynamic> map) {
    return Endemik(
      id: map['id'] as String, // ID dari DB adalah String
      nama: map['nama'] as String,
      nama_latin: map['nama_latin'] as String,
      deskripsi: map['deskripsi'] as String,
      asal: map['asal'] as String,
      foto: map['foto'] as String,
      status: map['status'] as String,
      is_favorit: map['is_favorit'] as String? ?? "false", // Pastikan ini juga string
    );
  }

  // Metode untuk menyimpan data ke database (DatabaseHelper.insert)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nama_latin': nama_latin,
      'deskripsi': deskripsi,
      'asal': asal,
      'foto': foto,
      'status': status,
      'is_favorit': is_favorit, // Simpan sebagai string "true" atau "false"
    };
  }

  // Metode untuk memeriksa kesamaan objek (penting untuk FavoriteProvider)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Endemik &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}