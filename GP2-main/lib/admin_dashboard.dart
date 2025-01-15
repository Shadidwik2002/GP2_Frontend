import 'package:flutter/material.dart';
import 'admin_provider_approval.dart'; // Import the provider approval page
import 'login_screen.dart';
import 'admin_manage_accounts.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final List<Map<String, dynamic>> _services = [
    {'name': 'House Cleaning', 'price': '15 JD', 'description': 'Professional house cleaning services'},
    {'name': 'Plumbing', 'price': '8 JD', 'description': 'Fix leaks and other plumbing issues'},
    {'name': 'Electrical', 'price': '15 JD', 'description': 'Electrical repair and maintenance services'},
    {'name': 'Home devices maintenance', 'price': '10 JD', 'description': 'Maintenance of home devices and appliances'},
  ];

  int _currentIndex = 0;

  // Function to delete a service
  void _deleteService(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: const Text('Are you sure you want to delete this service?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _services.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Service deleted!')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Function to edit a service
  void _editService(int index) {
    final TextEditingController nameController = TextEditingController(text: _services[index]['name']);
    final TextEditingController priceController = TextEditingController(text: _services[index]['price']);
    final TextEditingController descriptionController = TextEditingController(text: _services[index]['description']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Service'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Service Name'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _services[index]['name'] = nameController.text;
                _services[index]['price'] = priceController.text;
                _services[index]['description'] = descriptionController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Service updated!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Function to sign out
  void _signOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Description')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: _services
                      .asMap()
                      .entries
                      .map(
                        (entry) => DataRow(cells: [
                          DataCell(Text(entry.value['name'])),
                          DataCell(Text('${entry.value['price']}')),
                          DataCell(Text(entry.value['description'])),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editService(entry.key),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteService(entry.key),
                              ),
                            ],
                          )),
                        ]),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      const ManageAccountsPage(),
      const AdminProviderApproval(), // Added AdminProviderApproval as the third page
    ];

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar color set to white
        elevation: 0, // Remove shadow
        automaticallyImplyLeading: false,
        title: Text(
          _currentIndex == 0
              ? 'Manage Services'
              : _currentIndex == 1
                  ? 'Manage Accounts'
                  : 'Provider Approvals',
          style: const TextStyle(color: Colors.black), // Text color black
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Approvals',
          ),
        ],
      ),
    );
  }
}