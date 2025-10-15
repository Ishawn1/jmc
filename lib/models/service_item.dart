// lib/models/service_item.dart
import 'package:flutter/material.dart'; // Import for IconData

/// A model class that represents a municipal service.
///
/// This class stores information about a service, including its ID, name, icon,
/// and category.
class ServiceItem {
  /// A unique identifier for the service.
  final String id;

  /// The name of the service.
  final String name;

  /// The icon representing the service.
  final IconData icon;

  /// The category to which the service belongs.
  final String category;

  /// Creates an instance of [ServiceItem].
  const ServiceItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
  });
}
