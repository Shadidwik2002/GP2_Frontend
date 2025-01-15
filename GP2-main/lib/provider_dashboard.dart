import 'package:flutter/material.dart';
import 'provider_profile.dart';
import 'provider_schedule.dart';

class ServiceProviderDashboard extends StatefulWidget {
  const ServiceProviderDashboard({super.key});

  @override
  _ServiceProviderDashboardState createState() => _ServiceProviderDashboardState();
}

class _ServiceProviderDashboardState extends State<ServiceProviderDashboard> {
  int _currentIndex = 0;

  final List<Map<String, String>> requests = [
    {
      'id': '1',
      'service': 'Electrician',
      'customerName': 'Zaid',
      'details': 'Flickering Lights all over the house.',
      'time': '2025-1-13 9:00 AM',
      'location': 'Abdoun',
    },
    {
      'id': '2',
      'service': 'Plumbing',
      'customerName': 'Zaid',
      'details': 'Leaky faucet in the Bathroom',
      'time': '2025-1-15 11:00 AM',
      'location': 'Abdoun',
    },
  ];

  final List<Map<String, String>> acceptedRequests = [];
  final List<Map<String, String>> serviceHistory = [];
  String providerStatus = 'Available';

  bool _canAcceptRequest() {
    // Allow accepting multiple requests without time restrictions
    return providerStatus == 'Available';
  }

  void handleRequest(String id, bool accepted) {
    final request = requests.firstWhere((element) => element['id'] == id, orElse: () => {});
    if (request.isNotEmpty) {
      if (accepted && !_canAcceptRequest()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot accept orders when status is Busy.')),
        );
        return;
      }

      setState(() {
        request['status'] = accepted ? 'Accepted' : 'Declined';
        request['cost'] = accepted ? '50' : '0';
        serviceHistory.add(request);

        if (accepted) {
          acceptedRequests.add(request);
          providerStatus = 'Busy'; // Set status to Busy when accepting a request
        }

        requests.removeWhere((request) => request['id'] == id);
      });
    }
  }

  void handleRequestConfirmation(String id, bool accepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(accepted ? 'Accept Request' : 'Decline Request'),
          content: Text(
            accepted ? 'Are you sure you want to accept this request?' : 'Are you sure you want to decline this request?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                handleRequest(id, accepted);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void toggleStatus() {
    setState(() {
      providerStatus = providerStatus == 'Available' ? 'Busy' : 'Available';
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      Container(
        color: Colors.white,
        child: requests.isEmpty
            ? const Center(
                child: Text(
                  'No new requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Service: ${request['service']}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text('Customer: ${request['customerName']}'),
                          const SizedBox(height: 5),
                          Text('Details: ${request['details']}'),
                          const SizedBox(height: 5),
                          Text('Time: ${request['time']}'),
                          const SizedBox(height: 5),
                          Text('Location: ${request['location']}'),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () => handleRequestConfirmation(request['id']!, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text(
                                  'Accept',
                                  style: TextStyle(color: Colors.white), // Set text color to white
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => handleRequestConfirmation(request['id']!, false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text(
                                  'Decline',
                                  style: TextStyle(color: Colors.white), // Set text color to white
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      ProviderSchedulePage(acceptedRequests: acceptedRequests),
      ProviderProfilePage(serviceHistory: serviceHistory),
    ];

    final List<String> titles = ['Dashboard', 'Schedule', 'Profile'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(titles[_currentIndex]),
        centerTitle: true,
        elevation: 0,
        actions: _currentIndex == 0
            ? [
                GestureDetector(
                  onTap: toggleStatus,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: providerStatus == 'Available' ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      providerStatus,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: Container(
        color: Colors.white,
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Schedule',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
