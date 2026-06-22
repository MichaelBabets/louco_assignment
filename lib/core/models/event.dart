import 'package:equatable/equatable.dart';

class Event extends Equatable {
  const Event({
    required this.id,
    required this.title,
    required this.category,
    required this.venue,
    required this.city,
    required this.dateTime,
    this.imageUrl,
    this.price,
    this.isFree = false,
    this.isFavorited = false,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      venue: json['venue'] as String,
      city: json['city'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      isFree: json['isFree'] as bool? ?? false,
    );
  }

  final String id;
  final String title;
  final String category;
  final String venue;
  final String city;
  final DateTime dateTime;
  final String? imageUrl;
  final double? price;
  final bool isFree;
  final bool isFavorited;

  Event copyWith({bool? isFavorited}) {
    return Event(
      id: id,
      title: title,
      category: category,
      venue: venue,
      city: city,
      dateTime: dateTime,
      imageUrl: imageUrl,
      price: price,
      isFree: isFree,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    venue,
    city,
    dateTime,
    imageUrl,
    price,
    isFree,
    isFavorited,
  ];
}
