import 'package:flutter/material.dart';

class Cargo {
  final String id;
  final String type;
  final String route;
  final String price;
  final String delivery;

  Cargo({
    required this.id,
    required this.type,
    required this.route,
    required this.price,
    required this.delivery,
  });
}

class CargoProvider extends ChangeNotifier {
  final List<Cargo> _cargos = [
    Cargo(
      id: '1',
      type: 'Karayolu',
      route: 'İstanbul → Ankara',
      price: '₺2,450',
      delivery: 'Teslimat: 2 gün',
    ),
    Cargo(
      id: '2',
      type: 'Denizyolu',
      route: 'İzmir → İstanbul',
      price: '₺1,890',
      delivery: 'Teslimat: 3 gün',
    ),
  ];

  List<Cargo> get cargos => _cargos;
}
