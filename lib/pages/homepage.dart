import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_lost_n_found/widgets/ItemCard.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({Key? key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> searchHistory = [];

  bool _isSearchBarFocused = false;
  bool _isSearchBarVisible = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_updateSearchResults);
    loadSearchHistory();
  }

  @override
  void dispose() {
    _searchController.removeListener(_updateSearchResults);
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearchResults() {
    setState(() {});
  }

  void _onSearchSubmitted(String value) {
    _updateSearchHistory(value);
  }

  void _clearSearchHistory() async {
    if (widget.user != null) {
      await _firestore.collection('users').doc(widget.user!.uid).update({
        'searchHistory': [],
      });
      setState(() {
        searchHistory.clear();
      });
    }
  }

  void loadSearchHistory() async {
    if (widget.user != null) {
      var snapshot =
          await _firestore.collection('users').doc(widget.user!.uid).get();
      var data = snapshot.data();
      if (data != null && data['searchHistory'] != null) {
        setState(() {
          searchHistory = List<String>.from(data['searchHistory']);
        });
      }
    }
  }

  void _updateSearchHistory(String searchTerm) async {
    if (widget.user != null && searchTerm.isNotEmpty) {
      await _firestore.collection('users').doc(widget.user!.uid).update({
        'searchHistory': FieldValue.arrayUnion([searchTerm]),
      });
      setState(() {
        searchHistory.add(searchTerm);
      });
    }
  }

  void _deleteSearchTerm(String searchTerm) async {
    if (widget.user != null) {
      await _firestore.collection('users').doc(widget.user!.uid).update({
        'searchHistory': FieldValue.arrayRemove([searchTerm]),
      });
      setState(() {
        searchHistory.remove(searchTerm);
      });
    }
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.popAndPushNamed(context, '/login');
    } catch (error) {
      print("Error signing out: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth ~/ 200;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CampusFind',
          style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
        titleSpacing: screenWidth * 0.20,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset(
                'assets/images/CampusFind Logo.png',
                width: 54,
                height: 54,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearchBarVisible = !_isSearchBarVisible;
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[800],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: widget.user?.photoURL != null
                        ? NetworkImage(widget.user!.photoURL!)
                        : AssetImage('assets/default_user_image.png')
                            as ImageProvider<Object>?,
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '${widget.user != null ? widget.user!.displayName ?? "Guest" : "Guest"}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 0),
            Container(
              color: Colors.red,
              child: ListTile(
                title: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                leading: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onTap: () {
                  _signOut(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (_isSearchBarVisible)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextFormField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          labelText: "Search",
                        ),
                        onFieldSubmitted: _onSearchSubmitted,
                        onTap: () {
                          setState(() {
                            _isSearchBarFocused = true;
                          });
                        },
                      ),
                      if (_isSearchBarFocused)
                        IconButton(
                          icon: const Icon(Icons.arrow_drop_down),
                          onPressed: () {
                            setState(() {
                              _isSearchBarFocused = false;
                            });
                          },
                        ),
                    ],
                  ),
                  if (_isSearchBarFocused) _buildSearchHistoryDropdown(),
                ],
              ),
            ),
          const SizedBox(height: 20.0),
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('items').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final List<DocumentSnapshot> documents = snapshot.data!.docs;

                final filteredItems = documents.where((doc) {
                  var item = doc.data() as Map<String, dynamic>;
                  String itemName = item['name'].toString().toLowerCase();
                  String searchTerm = _searchController.text.toLowerCase();
                  return itemName.contains(searchTerm);
                }).toList();

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    var item =
                        filteredItems[index].data() as Map<String, dynamic>;
                    return ItemCard(
                      name: item['name'],
                      category: item['category'],
                      locationFound: item['location_found'],
                      timeFound: item['time_found'],
                      claimed: item['claimed'],
                      image: item['image'],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistoryDropdown() {
    final limitedSearchHistory = searchHistory.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your search history',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: _clearSearchHistory,
              child: const Text(
                'Clear History',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        for (String term in limitedSearchHistory)
          ListTile(
            title: Text(
              term,
              style: const TextStyle(fontSize: 12.0),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.clear, size: 16.0),
              onPressed: () {
                _deleteSearchTerm(term);
              },
            ),
            onTap: () {
              _searchController.text = term;
              _updateSearchHistory(term);
            },
          ),
      ],
    );
  }
}
