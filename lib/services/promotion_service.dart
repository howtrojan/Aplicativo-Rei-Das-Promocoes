import 'package:firebase_database/firebase_database.dart';
import '../model/promotion_model.dart';

class PromocaoService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref('promotions');

  Future<List<Promotion>> fetchPromocoes() async {
    DataSnapshot snapshot = await _databaseReference.get();
    
    if (snapshot.exists) {
      // Converte os dados do snapshot para Map e em seguida para a lista de objetos `Promotion`
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      return data.values.map((json) => Promotion.fromJson(Map<String, dynamic>.from(json))).toList();
    } else {
      return [];
    }
  }
}
