import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class databaseHelper {
  // -- Singleton DatabaseHelper --
  // _instance adalah instance tunggal (singleton) dari DatabaseHelper. 
  // Singleton memastikan hanya satu instance DatabaseHelper yang digunakan di seluruh aplikasi.
  static final databaseHelper _instance = databaseHelper._init();
  static Database? _database;
  // _internal() adalah constructor private. Ini mencegah pembuatan instance DatabaseHelper dari luar kelas.
  databaseHelper._init();
  // factory adalah constructor factory yang mengembalikan instance singleton, _instance. 
  // Setiap kali kita memanggil DatabaseHelper(), kita akan mendapat instance yang sama.
  factory databaseHelper() {
    return _instance;
  }
  // -- Inisialisasi Database --
  // database adalah getter untuk mengakses database. 
  // Jika database belum diinisialisasi (_database == null), 
  // maka _initDatabase akan dipanggil untuk membuatnya.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  // -- Membuat Database dan Tabel --
  // path: Mendapatkan path untuk database, db_history_kerusakan.db.
  // openDatabase: Membuka atau membuat database di path.
  // onCreate: Memanggil _onCreate untuk membuat tabel jika database baru.
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'db_history_kerusakan.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  // CREATE TABLE nama_tabel(...): Membuat tabel beserata isi kolomnya
  Future<void> _onCreate(Database db, int version) async {
    // Tabel History
    await db.execute('''
      CREATE TABLE log_kerusakan(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deskripsi_error TEXT,
        tgl_kerusakan TEXT
      )
    ''');
  }
  // -- Fungsi read data DB History --
  // Read tabel log_kerusakan
  Future<List<Map<String, dynamic>>> getLogKerusakan() async {
    Database db = await database;
    // return await db.query('log_kerusakan');
    return await db.rawQuery('''
      SELECT log_kerusakan.id, log_kerusakan.deskripsi_error, log_kerusakan.tgl_kerusakan
      FROM log_kerusakan
    ''');
  }
  // Read tabel log_kerusakan dengan periode tertentu
  Future<List<Map<String, dynamic>>> getLogKerusakanPeriode(DateTime startDate, DateTime endDate) async {
    final db = await database;
    // Format tanggal untuk query
    // final f = DateFormat('yyyy-MM-dd');
    // final start = f.format(startDate);
    // final end = f.format(endDate);
    final start = startDate.toIso8601String();
    final end = endDate.toIso8601String();
    // Query mentah selama periode tertentu
    return await db.rawQuery('''
      SELECT log_kerusakan.id, log_kerusakan.deskripsi_error, log_kerusakan.tgl_kerusakan
      FROM log_kerusakan
      WHERE DATE(tgl_kerusakan) BETWEEN ? AND ?
    ''', [start, end]);
  }
  // Fungsi simpan data error ke Database 
  Future<int> insertLogKerusakan(String deskripsi_error) async {
    final db = await database;
    // final f = new DateFormat('dd-MM-yyyy hh:mm');
    return await db.insert('log_kerusakan', {
      'deskripsi_error': deskripsi_error,
      // 'tgl_kerusakan': f.format(DateTime.now()).toString(),
      'tgl_kerusakan': DateTime.now().toIso8601String()
    });
  }
  // Fungsi delete data - jika nantinya butuh
  Future<int> deleteLogKerusakan(int id_log) async {
    Database db = await database;
    return await db.delete(
      'log_kerusakan',
      where: 'id = ?',
      whereArgs: [id_log],
    );
  }
  // -- Fungsi Backup dan restore Database - versi 1.5 --
  Future<void> backupDatabase() async {
    // cek akses storage
    var status1 = await Permission.manageExternalStorage.status;
    if (!status1.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    var status2 = await Permission.storage.status;
    if (!status2.isGranted) {
      await Permission.storage.request();
    }

    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String dbPath = join(appDocDir.path, 'db_history_kerusakan.db');
    // print("Database Location: $dbPath");
    // Directory backupDir = await getExternalStorageDirectory() ?? (await getApplicationDocumentsDirectory());
    // String backupPath = join(backupDir.path, 'backup_db_history_kerusakan.db');
    // print("Backup Location: $backupPath");
    String appDBDir = await getDatabasesPath();
    String dbPath = join(appDBDir, 'db_history_kerusakan.db');
    print("Database Location: $dbPath");
    Directory? backupDir = Directory('/storage/emulated/0/FolderBackupDatabase/');
    String backupPath = join(backupDir.path, 'backup_db_history_kerusakan.db');
    print("Backup Location: $backupPath");

    File dbFile = File(dbPath);
    File backupFile = File(backupPath);
    await backupDir.create();

    if (await Permission.storage.request().isGranted) {
      if (await dbFile.exists()) {
        await dbFile.copy(backupPath);
        print('Database di backup ke $backupPath');
      } else {
        print("File Database tidak ada");
      }
    } else {
      print("izin Storage ditolak");
    }
  }
  // Fungsi Restore Database
  Future<void> restoreDatabase() async {
    // cek akses storage
    var status1 = await Permission.manageExternalStorage.status;
    if (!status1.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    var status2 = await Permission.storage.status;
    if (!status2.isGranted) {
      await Permission.storage.request();
    }
    
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String dbPath = join(appDocDir.path, 'db_history_kerusakan.db');
    // print("Database Location: $dbPath");
    // Directory backupDir = await getExternalStorageDirectory() ?? (await getApplicationDocumentsDirectory());
    // String backupPath = join(backupDir.path, 'backup_db_history_kerusakan.db');
    // print("Backup Location: $backupPath");
    String appDBDir = await getDatabasesPath();
    String dbPath = join(appDBDir, 'db_history_kerusakan.db');
    print("Database Location: $dbPath");
    Directory? backupDir = Directory('/storage/emulated/0/FolderBackupDatabase/');
    String backupPath = join(backupDir.path, 'backup_db_history_kerusakan.db');
    print("Backup Location: $backupPath");

    File dbFile = File(dbPath);
    File backupFile = File(backupPath);

    if (await Permission.storage.request().isGranted) {
      if (await backupFile.exists()) {
        await backupFile.copy(dbPath);
        _database = await _initDatabase(); // Reinisialisasi database setelah restore
        print('Database di restore dari $backupPath');
      } else {
        print("File Backup tidak ada");
      }
    } else {
      print("Izin Storage ditolak");
    }
  }
  //Fungsi delete Database
  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'db_history_kerusakan.db');
    databaseFactory.deleteDatabase(path);
    _database = null; // bugfix buka halaman sejarah setelah hapus database
  }





  // // insertProduct: Fungsi untuk menambahkan data ke tabel produk. 
  // // Parameter product adalah map yang berisi nilai kolom (misalnya: name, description, dll.).
  // Future<int> insertProduct(Map<String, dynamic> produk) async {
  //   Database db = await database;
  //   return await db.insert('produk', produk);
  // }
  // // getProduk: Mengambil semua data dari tabel products dan 
  // // mengembalikannya sebagai List<Map<String, dynamic>>.
  // Future<List<Map<String, dynamic>>> getProduk() async {
  //   Database db = await database;
  //   return await db.query('produk');
  // }
  // // updateProduk: update data produk
  // Future<int> updateProduk(int produk_id, String nama_produk, double harga_produk) async {
  //   Database db = await database;
  //   return await db.update(
  //     'produk', 
  //     {
  //       'nama_produk': nama_produk,
  //       'harga_produk': harga_produk,
  //     },
  //     where: 'id = ?',
  //     whereArgs: [produk_id],
  //   );
  // }
  // // deleteProduk: untuk delete produk
  // Future<int> deleteProduk(int produk_id) async {
  //   Database db = await database;
  //   return await db.delete(
  //     'produk',
  //     where: 'id = ?',
  //     whereArgs: [produk_id],
  //   );
  // }
  // // insertToKeranjang menambahkan produk ke keranjang
  // Future<int> insertToKeranjang(int produk_id, int jumlah_pesanan) async {
  //   Database db = await database;
  //   // Cek apakah sudah ada produk di keranjang
  //   final List<Map<String, dynamic>> produkYangAda = await db.query(
  //     'keranjang',
  //     where: 'produk_id = ?',
  //     whereArgs: [produk_id],
  //   );

  //   if (produkYangAda.isNotEmpty) {
  //     // Jika produk sudah ada, update jumlah
  //     int jumlahPesananSekarang = produkYangAda.first['jumlah_pesanan'];
  //     int jumlahPesananBaru = jumlahPesananSekarang + 1;
  //     return await db.update(
  //       'keranjang', 
  //       {'jumlah_pesanan': jumlahPesananBaru},
  //       where: 'produk_id = ?',
  //       whereArgs: [produk_id],
  //     );
  //   } else {
  //     // Jika produk belum ada, tambahkan produk baru
  //     // jumlah_pesanan = jumlah_pesanan + 1;
  //     return await db.insert(
  //       'keranjang', 
  //       {
  //         'produk_id': produk_id,
  //         'jumlah_pesanan': jumlah_pesanan,
  //       }
  //     );
  //   }
  // }
  // // getItemKeranjang berfungsi untuk mengambil semua item di keranjang
  // // beserta inner join untuk dapat menampilkan nama produk dari tabel produk
  // Future<List<Map<String, dynamic>>> getItemKeranjang() async {
  //   Database db = await database;
  //   return await db.rawQuery('''
  //     SELECT keranjang.id, keranjang.produk_id, keranjang.jumlah_pesanan, produk.nama_produk AS produk_nama
  //     FROM keranjang
  //     INNER JOIN produk ON keranjang.produk_id = produk.id
  //   ''');
  // }
  // // fungsi memperbarui jumlah item di keranjang
  // Future<void> updateJumlahPesanan(int keranjang_id, int jumlah_pesanan) async {
  //   Database db = await database;
  //   await db.update(
  //     'keranjang',
  //     {'jumlah_pesanan': jumlah_pesanan},
  //     where: 'id = ?',
  //     whereArgs: [keranjang_id],
  //   );
  // }
  // // Fungsi untuk menghapus item dari keranjang
  // Future<int> deleteProdukKeranjang(int produk_id) async {
  //   Database db = await database;
  //   return await db.delete(
  //     'keranjang',
  //     where: 'produk_id = ?',
  //     whereArgs: [produk_id],
  //   );
  // }

  // // Fungsi untuk menambah belanja
  // Future<int> insertBelanja(String item_belanja, int quantity_belanja, String satuan, double total_harga_belanja) async {
  //   final db = await database;
  //   // final f = new DateFormat('dd-MM-yyyy hh:mm');
  //   return await db.insert('belanja', {
  //     'item_belanja': item_belanja,
  //     'quantity_belanja': quantity_belanja,
  //     'satuan': satuan,
  //     'total_harga_belanja': total_harga_belanja,
  //     // 'tgl_belanja': f.format(DateTime.now()).toString(),
  //     'tgl_belanja': DateTime.now().toIso8601String()
  //     // 'tgl_belanja': tgl_belanja, // String tgl_belanja
  //   });
  // }
  // // Fungsi untuk mengambil semua belanja
  // Future<List<Map<String, dynamic>>> getBelanja() async {
  //   final db = await database;
  //   return await db.query('belanja');
  // }
  // // Read tabel belanja dengan periode tertentu
  // Future<List<Map<String, dynamic>>> getBelanjaPeriode(DateTime startDate, DateTime endDate) async {
  //   final db = await database;
  //   final start = startDate.toIso8601String();
  //   final end = endDate.toIso8601String();
  //   // Query transaksi selama periode tertentu
  //   return await db.rawQuery('''
  //     SELECT id, item_belanja, quantity_belanja, satuan, total_harga_belanja, tgl_belanja
  //     FROM belanja
  //     WHERE DATE(tgl_belanja) BETWEEN ? AND ?
  //   ''', [start, end]);
  // }
  // // Fungsi untuk menghapus belanja
  // Future<int> deleteBelanja(int id) async {
  //   final db = await database;
  //   return await db.delete(
  //     'belanja',
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  // }

  // // CRUD untuk tabel transaksi
  // // Create
  // Future<int> insertTransaksi(Map<String, dynamic> transaksi) async {
  //   Database db = await database;
  //   return await db.insert('transaksi', transaksi);
  // }
  // // Read tabel transaksi yang di inner join tabel produk untuk bisa query nama produk
  // Future<List<Map<String, dynamic>>> getTransaksi() async {
  //   Database db = await database;
  //   // return await db.query('transaksi');
  //   // return await db.rawQuery('''
  //   //   SELECT transaksi.id, transaksi.produk_id, transaksi.jumlah_item_transaksi, transaksi.total_harga, transaksi.tgl_transaksi, produk.nama_produk AS produk_nama
  //   //   FROM transaksi
  //   //   INNER JOIN produk ON transaksi.produk_id = produk.id
  //   // ''');
  //   return await db.rawQuery('''
  //     SELECT transaksi.id, transaksi.nama_produk, transaksi.jumlah_item_transaksi, transaksi.total_harga, transaksi.tgl_transaksi
  //     FROM transaksi
  //   ''');
  // }
  // // Read tabel transaksi dengan periode tertentu
  // Future<List<Map<String, dynamic>>> getTransaksiPeriode(DateTime startDate, DateTime endDate) async {
  //   final db = await database;
  //   // Format tanggal untuk query
  //   // final f = DateFormat('yyyy-MM-dd');
  //   // final start = f.format(startDate);
  //   // final end = f.format(endDate);
  //   final start = startDate.toIso8601String();
  //   final end = endDate.toIso8601String();
  //   // Query transaksi selama periode tertentu
  //   return await db.rawQuery('''
  //     SELECT transaksi.id, transaksi.nama_produk, transaksi.jumlah_item_transaksi, transaksi.total_harga, transaksi.tgl_transaksi
  //     FROM transaksi
  //     WHERE DATE(tgl_transaksi) BETWEEN ? AND ?
  //   ''', [start, end]);
  // }
  // // Update
  // Future<int> updateTransaksi(Map<String, dynamic> transaksi, int id) async {
  //   Database db = await database;
  //   return await db.update('transaksi', transaksi, 
  //     where: 'id = ?', 
  //     whereArgs: [id]
  //   );
  // }
  // // Delete
  // Future<int> deleteTransaksi(int id) async {
  //   Database db = await database;
  //   return await db.delete('transaksi',
  //     where: 'id = ?',
  //     whereArgs: [id]
  //   );
  // }
  // // fungsi menghitung laporan laba rugi
  // Future<Map<String, dynamic>> getLaporanLabaRugi(DateTime startDate, DateTime endDate) async {
  //   final db = await database;
  //   // final f = new DateFormat('dd-MM-yyyy hh:mm');
  //   // Format tanggal ke string untuk digunakan dalam query
  //   // final start = f.format(startDate);
  //   // final end = f.format(endDate);
  //   final start = startDate.toIso8601String();
  //   final end = endDate.toIso8601String();

  //   // query menghitung total pendapatan dari penjualan
  //   final queryTotalPenjualan = await db.rawQuery('''
  //     SELECT SUM(total_harga) as totalPenjualan
  //     FROM transaksi WHERE DATE(tgl_transaksi) BETWEEN ? AND ?
  //   ''', [start, end]);
  //   // query menghitung total belanja
  //   final queryTotalBelanja = await db.rawQuery('''
  //     SELECT SUM(total_harga_belanja) as totalBelanja
  //     FROM belanja WHERE DATE(tgl_belanja) BETWEEN ? AND ?
  //   ''', [start, end]);
  //   // parsing hasil query
  //   final totalPenjualan = (queryTotalPenjualan.first['totalPenjualan'] as num?)?.toDouble() ?? 0.0;
  //   final totalBelanja = (queryTotalBelanja.first['totalBelanja'] as num?)?.toDouble() ?? 0.0;
  //   // menghitung laba bersih
  //   final labaBersih = totalPenjualan - totalBelanja;
  //   return {
  //     'totalPenjualan': totalPenjualan,
  //     'totalBelanja': totalBelanja,
  //     'labaBersih': labaBersih,
  //   };
  // }
  // // fungsi laporan per hari untuk chart
  // Future<List<Map<String, double>>> getLaporanLabaRugiPerHari(DateTime startDate, DateTime endDate) async {
  //   final db = await database;
  //   final start = startDate.toIso8601String();
  //   final end = endDate.toIso8601String();

  //   // ambil semua hari dalam range
  //   final int days = endDate.difference(startDate).inDays + 1;
  //   List<Map<String, double>> data = [];
  //   for (int i = 0; i < days; i++) {
  //     final date = startDate.add(Duration(days: i));
  //     // Query total penjualan
  //     final queryTotalPenjualan = await db.rawQuery('''
  //       SELECT SUM(total_harga) as totalPenjualan
  //       FROM transaksi WHERE DATE(tgl_transaksi) = ?
  //     ''', [date]);
  //     // Query total belanja
  //     final queryTotalBelanja = await db.rawQuery('''
  //       SELECT SUM(total_harga_belanja) as totalBelanja
  //       FROM belanja WHERE DATE(tgl_pengeluaran) = ?
  //     ''', [date]);
  //     // parsing hasil query
  //     final totalPenjualan = (queryTotalPenjualan.first['totalPenjualan'] as num?)?.toDouble() ?? 0.0;
  //     final totalBelanja = (queryTotalBelanja.first['totalBelanja'] as num?)?.toDouble() ?? 0.0;
  //     // menghitung laba bersih
  //     final labaBersih = totalPenjualan - totalBelanja;
  //     data.add({
  //       'Pendapatan': totalPenjualan,
  //       'Pengeluaran': totalBelanja,
  //       'LabaBersih': labaBersih,
  //     });
  //   }
  //   return data;
  // }

  // // Fungsi transaksi cek out untuk penjualan
  // Future<void> cekOutKeranjang() async {
  //   Database db = await database;
  //   // ambil semua item di keranjang
  //   final List<Map<String, dynamic>> itemKeranjang = await db.rawQuery('''
  //     SELECT keranjang.id, keranjang.produk_id, keranjang.jumlah_pesanan, produk.nama_produk AS produk_nama, produk.harga_produk AS produk_harga
  //     FROM keranjang
  //     INNER JOIN produk ON keranjang.produk_id = produk.id
  //   ''');
  //   for (var item in itemKeranjang) {
  //     String nama_produk = item['produk_nama'];
  //     // int produk_id = item['keranjang.produk_id'];
  //     int jumlah = item['jumlah_pesanan'];
  //     // // mendapatkan harga produk
  //     // final List<Map<String, dynamic>> produk = await db.query(
  //     //   'produk',
  //     //   where: 'id = ?',
  //     //   whereArgs: [produk_id],
  //     // );
  //     // double hargaProduk = produk.first['produk_harga'];
  //     double hargaProduk = item['produk_harga'];
  //     double totalHarga = hargaProduk * jumlah;
  //     // DateTime dateTransaksi = DateTime.now();
  //     // final f = new DateFormat('dd-MM-yyyy hh:mm'); // format tanggal lokal
  //     // Memasukan item ke tabel transaksi
  //     await db.insert('transaksi', {
  //       // 'produk_id': produk_id,
  //       'nama_produk': nama_produk,
  //       'jumlah_item_transaksi': jumlah,
  //       'total_harga': totalHarga,
  //       // 'tgl_transaksi': f.format(DateTime.now()).toString(),
  //       'tgl_transaksi': DateTime.now().toIso8601String(), //backup jika terjadi sesuatu
  //     });
  //     // mengosongkan keranjang setelah cekout
  //     await db.delete('keranjang');
  //   }
  // }

  // // Fungsi Backup dan restore Database - versi 2
  // // untuk bisa dapat lokasi file database
  // getDBPath() async {
  //   String dbPath = await getDatabasesPath();
  //   print(dbPath);
  //   Directory? externalStoragePath = await getExternalStorageDirectory();
  //   print(externalStoragePath);
  // }
  // // Backup database
  // backupDB() async {
  //   // cek akses storage
  //   var status1 = await Permission.manageExternalStorage.status;
  //   if (!status1.isGranted) {
  //     await Permission.manageExternalStorage.request();
  //   }
  //   var status2 = await Permission.storage.status;
  //   if (!status2.isGranted) {
  //     await Permission.storage.request();
  //   }
  //   try {
  //     // path database
  //     File dbFile = File('/data/user/0/com.example.aplikasi_pembukuan/databases/db_history_kerusakan.db');
  //     // path backup database
  //     Directory? folderPathUntukFileDatabase = Directory('/storage/emulated/0/FolderBackupDatabase/');
  //     // create folder backup
  //     await folderPathUntukFileDatabase.create();
  //     // copy database
  //     await dbFile.copy('/storage/emulated/0/FolderBackupDatabase/db_history_kerusakan.db');
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
  // // restore database
  // restoreDB() async {
  //   var status1 = await Permission.manageExternalStorage.status;
  //   if (!status1.isGranted) {
  //     await Permission.manageExternalStorage.request();
  //   }
  //   var status2 = await Permission.storage.status;
  //   if (!status2.isGranted) {
  //     await Permission.storage.request();
  //   }
  //   try {
  //     // restore file database
  //     File dbFileSave = File('/storage/emulated/0/FolderBackupDatabase/db_history_kerusakan.db');
  //     await dbFileSave.copy('/data/user/0/com.example.aplikasi_pembukuan/databases/db_history_kerusakan.db');
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
}
