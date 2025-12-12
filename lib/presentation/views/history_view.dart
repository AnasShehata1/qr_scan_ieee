import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:qr_scan_ieee/presentation/widgets/info_card.dart';
import '../../constants.dart';
import '../../data/models/user_model.dart';
import '../../data/api/api_services.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  bool scan = true;
  ApiServices apiServices = ApiServices();

  Future<List<UserModel>> getScannedUsers() async {
    final box = Hive.box<UserModel>(user);
    return box.values.toList();
  }

  Future<List<UserModel>> getAttendedUsers() async {
    final result = await apiServices.getAttendedMembers();
    return result
        .map((memberResponse) => UserModel(
              date: ' ',
              email: memberResponse.email,
              id: memberResponse.id,
              name: '${memberResponse.firstName} ${memberResponse.lastName}',
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("History"),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: 336,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                _toggleButton(
                    title: "Scanned Users",
                    active: scan,
                    onTap: () {
                      setState(() => scan = true);
                    }),
                _toggleButton(
                    title: "Attended Users",
                    active: !scan,
                    onTap: () {
                      setState(() => scan = false);
                    }),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<UserModel>>(
              future: scan ? getScannedUsers() : getAttendedUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
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
                        name: user.name,
                        email: user.email,
                        date: user.date,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(
      {required String title,
      required bool active,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 153.6,
          height: 47.7,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.black,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(color: AppColors.secondary, fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }
}
