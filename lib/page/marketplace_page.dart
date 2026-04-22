import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MarketplacePage extends StatefulWidget {
  @override
  _MarketplacePageState createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  int userPoints = 0;
  List ledger = [];
  List tokens = [];
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
    fetchUserData(); // ✅ tambah ini
    fetchLedger();
    initAll();
  }

  Future<void> fetchItems() async {
    final prefs = await SharedPreferences.getInstance();
    String? loginToken = prefs.getString("token");

    final response = await http.get(
      // Uri.parse("http://10.77.86.197:8000/api/marketplace"),
      Uri.parse("http://192.168.1.5:8000/api/marketplace"),
      headers: {"Authorization": "Bearer $loginToken"},
    );

    if (response.statusCode == 200) {
      setState(() {
        items = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      print("ERROR: ${response.body}");
    }
  }

  Future<void> buyItem(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String? loginToken = prefs.getString("token");

    final response = await http.post(
      // Uri.parse("http://10.77.86.197:8000/api/marketplace/buy/$id"),
      Uri.parse("http://192.168.1.5:8000/api/marketplace/buy/$id"),
      headers: {"Authorization": "Bearer $loginToken"},
    );

    final data = jsonDecode(response.body);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(data['message'])));

    await fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? loginToken = prefs.getString("token");

    // ambil poin
    final pointRes = await http.get(
      // Uri.parse("http://10.77.86.197:8000/api/user/points"),
      Uri.parse("http://192.168.1.5:8000/api/user/points"),
      headers: {"Authorization": "Bearer $loginToken"},
    );

    // ambil token
    final tokenRes = await http.get(
      // Uri.parse("http://10.77.86.197:8000/api/user/tokens"),
      Uri.parse("http://192.168.1.5:8000/api/user/tokens"),
      headers: {"Authorization": "Bearer $loginToken"},
    );

    if (pointRes.statusCode == 200 && tokenRes.statusCode == 200) {
      setState(() {
        userPoints = jsonDecode(pointRes.body)['points'];
        tokens = jsonDecode(tokenRes.body)['tokens'];
      });
    }
  }

  Future<void> fetchLedger() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final res = await http.get(
      // Uri.parse("http://10.77.86.197:8000/api/user/ledger"),
      Uri.parse("http://192.168.1.5:8000/api/user/ledger"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      setState(() {
        ledger = jsonDecode(res.body)['data'];
      });
    }
  }

  Future<void> initAll() async {
    await Future.wait([fetchItems(), fetchUserData(), fetchLedger()]);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text("Dompet Integritas")),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // ✅ HERO SECTION
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    color: Colors.blue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Saldo Poin",
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "$userPoints",
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Level: Disiplin Elite",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  // ✅ TAB BAR DI SINI (PINDAH KE BAWAH HERO)
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      tabs: [
                        Tab(text: "Riwayat"),
                        Tab(text: "Marketplace"),
                        Tab(text: "Inventory"),
                      ],
                    ),
                  ),

                  // ✅ TAB CONTENT
                  Expanded(
                    child: TabBarView(
                      children: [
                        buildRiwayat(),
                        buildMarketplace(),
                        buildInventory(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildRiwayat() {
    return ListView.builder(
      itemCount: ledger.length,
      itemBuilder: (context, index) {
        final item = ledger[index];

        bool isPlus = item['amount'] > 0;

        return ListTile(
          
          title: Text(item['description'] ?? '-'),
          subtitle: Text(item['date']),
          trailing: Text(
            "${item['amount']}",
            style: TextStyle(
              color: isPlus ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget buildMarketplace() {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        bool cukup = userPoints >= item['point_cost'];

        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.card_giftcard, size: 50),
              SizedBox(height: 10),
              Text(item['item_name']),
              Text("${item['point_cost']} poin"),

              SizedBox(height: 10),

              ElevatedButton(
                onPressed: cukup
                    ? () => buyItem(item['id'])
                    : null, // ✅ disable kalau tidak cukup
                child: Text("Tukar"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildInventory() {
    return tokens.isEmpty
        ? Center(child: Text("Tidak ada token"))
        : ListView.builder(
            itemCount: tokens.length,
            itemBuilder: (context, index) {
              final token = tokens[index];

              return ListTile(
                leading: Icon(Icons.confirmation_number),
                title: Text(token['item_name']),
              );
            },
          );
  }
}
