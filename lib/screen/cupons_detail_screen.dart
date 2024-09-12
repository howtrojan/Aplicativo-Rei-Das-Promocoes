import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:reidaspromocoes/model/cupons_model.dart';
import '../utils/utils.dart';

class CouponDetailScreen extends StatelessWidget {
  final Coupon coupon;

  const CouponDetailScreen({super.key, required this.coupon});

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Acesso'),
          content: const Text('Você deseja ir para a oferta?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                // Navegar para o link do cupom
                Utils.launch(coupon.url);
              },
              child: const Text('Ir para o Cupom'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(coupon.title),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey[400]!, width: 2.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: coupon.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()), // Placeholder enquanto carrega
                  errorWidget: (context, url, error) => 
                      Image.asset(
                        'assets/splash_icon.png', // Imagem de fallback se falhar
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            Text(
              coupon.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Descrição:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              coupon.description,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            if (coupon.couponCode.isNotEmpty)
              Text(
                'Código do Cupom: ${coupon.couponCode}',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            Text(
              'Validade: ${DateFormat('dd/MM/yyyy').format(coupon.dateTime)}',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () => _showConfirmationDialog(context),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.black),
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.yellow),
                  ),
                  child: const Text('Ir para o Cupom'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
