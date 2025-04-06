// lib/models/service_item.dart
import 'package:flutter/material.dart'; // Import for IconData

class ServiceItem {
  final String id;
  final String name;
  final IconData icon; // Use IconData for Material Icons
  final String category; // Added category for filtering

  const ServiceItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.category, // Make category required
  });
}
