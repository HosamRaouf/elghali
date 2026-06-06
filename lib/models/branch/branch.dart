import 'package:equatable/equatable.dart';

class Branch extends Equatable {
  final String id;
  final String name;
  final String city;
  final String address;
  final String hours;
  final String phone;
  final bool isOpen;
  final String waitTime;
  final double x;
  final double y;

  const Branch({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.hours,
    required this.phone,
    required this.isOpen,
    required this.waitTime,
    required this.x,
    required this.y,
  });

  @override
  List<Object?> get props =>
      [id, name, city, address, hours, phone, isOpen, waitTime, x, y];
}
