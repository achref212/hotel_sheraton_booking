import 'package:flutter/material.dart';
import 'package:hotel_sheraton_booking/providers/userprovider.dart';
import 'package:hotel_sheraton_booking/utils/constants.dart';
import 'package:provider/provider.dart';
import '../../models/activity_model.dart';
import '../../services/activity_service.dart';
import 'activity_details_screen.dart';

class ActivityListScreen extends StatefulWidget {
  @override
  _ActivityListScreenState createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  final ActivityService _activityService = ActivityService();
  List<ActivityModel> _allActivities = [];
  List<ActivityModel> _filteredActivities = [];
  List<ActivityModel> _recommendedActivities = [];
  List<ActivityModel> _favoriteActivities = [];
  TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchActivities();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    _filterActivities(_searchController.text);
  }

  _fetchActivities() async {
    try {
      var userId = Provider.of<UserProvider>(context, listen: false).user.id;

      // Fetching all activities
      List<ActivityModel> activities =
          await _activityService.getAllActivities();
      print('Fetched activities: ${activities.length}'); // Debugging output

      setState(() {
        _allActivities = activities;
        _filteredActivities = activities; // Display all activities initially
        _favoriteActivities =
            activities.where((activity) => activity.isFavorite).toList();
      });

      // Fetch recommended activities (if user ID exists)
      if (userId.isNotEmpty) {
        try {
          List<ActivityModel> recommendedActivities =
              await _activityService.getActivityRecommendations(userId);

          setState(() {
            _recommendedActivities = recommendedActivities;
          });
        } catch (error) {
          print('Failed to fetch recommendations: $error');
        }
      } else {
        print("User ID is missing!");
      }
    } catch (error) {
      print('Failed to fetch activities: $error');
    }
  }

  _filterActivities(String query) {
    List<ActivityModel> _activities =
        _getCurrentActivityList().where((activity) {
      return activity.name.toLowerCase().contains(query.toLowerCase()) ||
          activity.location.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredActivities = _activities;
    });
  }

  List<ActivityModel> _getCurrentActivityList() {
    if (_selectedIndex == 0) {
      return _allActivities;
    } else if (_selectedIndex == 1) {
      return _recommendedActivities;
    } else {
      return _favoriteActivities;
    }
  }

  // Toggle favorite status of an activity
  void _toggleFavorite(ActivityModel activity) {
    setState(() {
      activity.isFavorite = !activity.isFavorite;
      _favoriteActivities =
          _allActivities.where((activity) => activity.isFavorite).toList();
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
              'Find Activities',
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
                labelText: 'Search Activities',
                hintText: 'Enter activity name or location',
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

            // Horizontal List of Activities
            Text(
              _selectedIndex == 1
                  ? 'Recommended Activities'
                  : 'Popular Activities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _getCurrentActivityList().length,
                itemBuilder: (context, index) {
                  ActivityModel activity = _getCurrentActivityList()[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ActivityDetailsScreen(activity: activity),
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
                              '${Constants.uri}/uploads/${activity.imagePath.split("/").last}',
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
                                activity.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: activity.isFavorite
                                    ? Colors.red
                                    : Colors.white,
                              ),
                              onPressed: () => _toggleFavorite(activity),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity.name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        color: Colors.white, size: 18),
                                    SizedBox(width: 5),
                                    Text(
                                      activity.location,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '\$${activity.price} per person',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
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

            // Vertical List of Activities or Filtered Activities
            Expanded(
              child: ListView.builder(
                itemCount: _filteredActivities.length,
                itemBuilder: (context, index) {
                  ActivityModel activity = _filteredActivities[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ActivityDetailsScreen(activity: activity),
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
                              '${Constants.uri}/uploads/${activity.imagePath.split("/").last}',
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
                                  activity.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  activity.location,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '\$${activity.price} / person',
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
                              activity.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: activity.isFavorite
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () => _toggleFavorite(activity),
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
          _filteredActivities = _getCurrentActivityList();
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
