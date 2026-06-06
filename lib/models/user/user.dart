import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String phone;
  final int points;

  const User({
    required this.id,
    required this.name,
    required this.phone,
    required this.points,
  });

  @override
  List<Object?> get props => [id, name, phone, points];
}
