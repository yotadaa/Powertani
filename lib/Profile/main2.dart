import 'package:flutter/material.dart';
import 'package:powertani/env.dart'; // Pastikan AppColors didefinisikan di sini

class ProfilePage extends StatelessWidget {
  Map<String, dynamic> user;

  ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Akun',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryGreenDark,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryGreenDark,
                    AppColors.primaryGreenLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: const Text(
                      'MN',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MUKHTADA BILLAH NST',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/bripoin.png', // Path to your BRI logo
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '942',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Promo Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/brimo_promo.png', // Replace with your image path
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '0 Kupon Undian',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Terakhir diperbarui: 31 Oktober 2024',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Settings Section
            _buildSectionTitle('Pengaturan'),
            _buildListTile(
              icon: Icons.menu,
              title: 'Fast Menu',
            ),
            _buildListTile(
              icon: Icons.update,
              title: 'Update Rekening',
            ),
            _buildListTile(
              icon: Icons.credit_card,
              title: 'Pengelolaan Kartu',
            ),
            _buildListTile(
              icon: Icons.qr_code,
              title: 'Sumber Dana QRIS',
            ),
            const SizedBox(height: 16),
            // Security Section
            _buildSectionTitle('Keamanan'),
            _buildListTile(
              icon: Icons.pin,
              title: 'Ubah Pin',
            ),
            _buildListTile(
              icon: Icons.lock,
              title: 'Ubah Password',
            ),
            _buildSwitchTile(
              icon: Icons.fingerprint,
              title: 'Login Fingerprint',
              value: true,
              onChanged: (value) {
                // Handle switch toggle
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildListTile({required IconData icon, required String title}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        // Handle tile tap
      },
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.grey),
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
