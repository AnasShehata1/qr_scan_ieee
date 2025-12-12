import 'package:flutter/material.dart';
import 'package:qr_scan_ieee/data/api/api_services.dart';
import '../../constants.dart';
import '../widgets/info_card.dart';

class AbsentsMembersView extends StatelessWidget {
  const AbsentsMembersView({super.key});

  @override
  Widget build(BuildContext context) {
    final apiServices = ApiServices();

    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: const Text("Absent Users"),
      ),
      body: FutureBuilder(
        future: apiServices.getAbsentMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return InfoCard(
                  id: user.id,
                  name: '${user.firstName} ${user.lastName}',
                  email: user.email,
                  date: ' ',
                );
              },
            );
          }
        },
      ),
    );
  }
}
