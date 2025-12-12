import 'package:flutter/material.dart';
import '../../constants.dart';

class InfoCard extends StatelessWidget {
  final String id;
  final String name;
  final String email;
  final String date;

  const InfoCard({
    super.key,
    required this.id,
    required this.name,
    required this.email,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.qr_code,
            size: 40,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID: $id",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary)),
                const SizedBox(height: 8),
                Text("Name: $name", style: TextStyle(color: AppColors.success)),
                Text("Email: $email", style: TextStyle(color: AppColors.success)),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    date,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
