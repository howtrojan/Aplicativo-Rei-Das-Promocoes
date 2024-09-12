import 'package:firebase_database/firebase_database.dart';
import 'package:reidaspromocoes/model/cupons_model.dart';

class CouponService {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref('coupons');

  // Método para buscar todos os cupons
  Future<List<Coupon>> fetchCoupons() async {
    try {
      DataSnapshot snapshot = await _databaseReference.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          List<Coupon> coupons = data.entries.map((entry) {
            final json =
                Map<String, dynamic>.from(entry.value as Map<dynamic, dynamic>);
            return Coupon.fromJson(json);
          }).toList();

          return coupons;
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Método para buscar um cupom específico pelo ID
  Future<Coupon?> fetchCouponById(String id) async {
    try {
      DataSnapshot snapshot = await _databaseReference.child(id).get();

      if (snapshot.exists) {
        final json =
            Map<String, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);

        return Coupon.fromJson(json);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Método para adicionar um novo cupom
  Future<void> addCoupon(Coupon coupon) async {
    try {
      await _databaseReference.push().set(coupon.toJson());
    } catch (e) {}
  }

  // Método para atualizar um cupom existente
  Future<void> updateCoupon(String id, Coupon coupon) async {
    try {
      await _databaseReference.child(id).update(coupon.toJson());
    } catch (e) {}
  }

  // Método para excluir um cupom
  Future<void> deleteCoupon(String id) async {
    try {
      await _databaseReference.child(id).remove();
    } catch (e) {}
  }
}
