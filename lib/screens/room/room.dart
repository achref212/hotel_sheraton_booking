import 'package:flutter/material.dart';
import 'package:hotel_sheraton_booking/providers/userprovider.dart';
import 'package:hotel_sheraton_booking/utils/constants.dart';
import 'package:provider/provider.dart';
import '../../models/room_model.dart';
import '../../services/room_service.dart';
import 'room_details_screen.dart';

class RoomListScreen extends StatefulWidget {
  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  final RoomService _roomService = RoomService();
  List<RoomModel> _allRooms = [];
  List<RoomModel> _filteredRooms = [];
  List<RoomModel> _recommendedRooms = [];
  List<RoomModel> _favoriteRooms = [];
  TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchRooms();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    _filterRooms(_searchController.text);
  }

  _fetchRooms() async {
    try {
      var userId = Provider.of<UserProvider>(context, listen: false).user.id;
      List<RoomModel> rooms = await _roomService.getAllRooms();

      setState(() {
        _allRooms = rooms;
        _filteredRooms = rooms;
        _favoriteRooms = rooms.where((room) => room.isFavorite).toList();
      });

      if (userId.isNotEmpty) {
        try {
          List<RoomModel> recommendedRooms =
              await _roomService.getRoomRecommendations(userId);

          setState(() {
            _recommendedRooms = recommendedRooms;
          });
        } catch (error) {
          print('Failed to fetch recommendations: $error');
        }
      } else {
        print("User ID is missing!");
      }
    } catch (error) {
      print('Failed to fetch rooms: $error');
    }
  }

  _filterRooms(String query) {
    List<RoomModel> _rooms = _getCurrentRoomList().where((room) {
      return room.name.toLowerCase().contains(query.toLowerCase()) ||
          room.location.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredRooms = _rooms;
    });
  }

  List<RoomModel> _getCurrentRoomList() {
    if (_selectedIndex == 0) {
      return _allRooms;
    } else if (_selectedIndex == 1) {
      return _recommendedRooms;
    } else {
      return _favoriteRooms;
    }
  }

  // Toggle favorite status of a room
  void _toggleFavorite(RoomModel room) {
    setState(() {
      room.isFavorite = !room.isFavorite;
      _favoriteRooms = _allRooms.where((room) => room.isFavorite).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'Assets/logo.png',
              width: 90,
              height: 60,
            ),
            SizedBox(width: 10),
            Text(
              'Find your Room',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Rooms',
                hintText: 'Enter room name or location',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),

            // Segmented Control for Filter (All, Recommendations, Favorites)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterButton('All', 0),
                SizedBox(width: 10),
                _buildFilterButton('Recommendations', 1),
                SizedBox(width: 10),
                _buildFilterButton('Favorites', 2),
              ],
            ),
            SizedBox(height: 16),

            // Horizontal List of Rooms (Filtered based on selection)
            Text(
              _selectedIndex == 1 ? 'Recommended Rooms' : 'Popular Rooms',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _getCurrentRoomList().length,
                itemBuilder: (context, index) {
                  RoomModel room = _getCurrentRoomList()[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomDetailsScreen(room: room),
                        ),
                      );
                    },
                    child: Container(
                      width: 180,
                      margin: EdgeInsets.only(right: 10),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              '${Constants.uri}/uploads/${room.imagePath.split("/").last}',
                              fit: BoxFit.cover,
                              width: 180,
                              height: 200,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: IconButton(
                              icon: Icon(
                                room.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    room.isFavorite ? Colors.red : Colors.white,
                              ),
                              onPressed: () => _toggleFavorite(room),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.king_bed,
                                        color: Colors.white, size: 18),
                                    SizedBox(width: 5),
                                    Text(
                                      room.location,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.hotel,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '\$${room.price}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            // Vertical List of All Rooms or Filtered Rooms
            Expanded(
              child: ListView.builder(
                itemCount: _filteredRooms.length,
                itemBuilder: (context, index) {
                  RoomModel room = _filteredRooms[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomDetailsScreen(room: room),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              '${Constants.uri}/uploads/${room.imagePath.split("/").last}',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image_not_supported,
                                    size: 100, color: Colors.grey);
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  room.location,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '\$${room.price} / night',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              room.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: room.isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => _toggleFavorite(room),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // Helper method to create filter buttons
  Widget _buildFilterButton(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          _filteredRooms = _getCurrentRoomList();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _selectedIndex == index
              ? Colors.blueAccent
              : Colors.grey.shade200,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: _selectedIndex == index ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
