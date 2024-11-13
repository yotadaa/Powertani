import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Auth/login_screen_x.dart'; // Import halaman login untuk logout

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? loggedInUserName; // Menyimpan nama pengguna yang sedang login

  @override
  void initState() {
    super.initState();
    fetchLoggedInUserData(); // Panggil untuk mengambil data pengguna yang login
  }

  Future<void> fetchLoggedInUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await users.doc(user.uid).get();
      setState(() {
        loggedInUserName = userData['name']; // Ambil nama pengguna yang login
      });
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) =>
              LoginScreen()), // Arahkan kembali ke halaman login setelah logout
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Simple'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.logout),
      //       onPressed: logout, // Panggil fungsi logout saat tombol ditekan
      //     )
      //   ],
      // ),
      appBar: AppBar(
        title: Text('App Name'),
        leading: IconButton(
          // Tambahkan tombol logout di sebelah kiri (leading)
          icon: Icon(Icons.logout),
          onPressed: logout, // Logout saat tombol logout ditekan
        ),
      ),

      body: Column(
        children: [
          // Bagian untuk menampilkan nama pengguna yang login di atas daftar
          if (loggedInUserName != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome, $loggedInUserName!', // Menampilkan nama pengguna yang login
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: users.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final data = snapshot.requireData;

                return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(
                          8.0), // Add padding around each card
                      child: Card(
                        elevation: 5, // Elevation adds shadow to the card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              15), // Rounded corners for the card
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            // Display an avatar or initial letters
                            child: Text(
                              data.docs[index]['name']
                                  .substring(0, 1)
                                  .toUpperCase(), // First letter of the name
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          title: Text(
                            data.docs[index]['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Larger font for the name
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteUser(
                                data.docs[index].id), // Call deleteUser
                          ),
                          onTap: () {
                            nameController.text = data.docs[index]['name'];
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Update User'),
                                content: TextField(
                                  controller: nameController,
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Update'),
                                    onPressed: () {
                                      updateUser(data.docs[index].id,
                                          nameController.text);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          nameController.clear();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Add User'),
              content: TextField(
                controller: nameController,
              ),
              actions: [
                TextButton(
                  child: Text('Add'),
                  onPressed: () {
                    addUser(nameController.text);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> addUser(String name) {
    return users.add({'name': name});
  }

  Future<void> updateUser(String id, String name) {
    return users.doc(id).update({'name': name});
  }

  Future<void> deleteUser(String id) {
    return users.doc(id).delete();
  }
}
