import 'package:flutter/material.dart';
import 'package:flutter_application_3/services/api_service.dart';
import 'package:flutter_application_3/widget/player_form.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService apiService = ApiService();
  List<dynamic> players = [];

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  _fetchPlayers() async {
    try {
      players = await apiService.fetchPlayers();
      setState(() {});
    } catch (e) {
      print("Error fetching players: $e");
    }
  }

  _addPlayer(String name, String position, String country) async {
    Map<String, String> newPlayer = {'name': name, 'position': position, 'country': country};
    try {
      await apiService.addPlayer(newPlayer);
      _fetchPlayers();
    } catch (e) {
      print("Error adding player: $e");
    }
  }

  _updatePlayer(String id, String name, String position, String country) async {
    Map<String, String> updatedPlayer = {'name': name, 'position': position, 'country': country};
    try {
      await apiService.updatePlayer(id, updatedPlayer);
      _fetchPlayers();
    } catch (e) {
      print("Error updating player: $e");
    }
  }

  _deletePlayer(String id) async {
    try {
      await apiService.deletePlayer(id);
      _fetchPlayers(); // Fetch players again to update the list
    } catch (e) {
      print("Error deleting player: $e");
    }
  }

  void _showEditDialog(String id, String name, String position, String country) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Player'),
          content: PlayerForm(
            initialName: name,
            initialPosition: position,
            initialCountry: country,
            onSubmit: (newName, newPosition, newCountry) {
              Navigator.of(context).pop();
              _updatePlayer(id, newName, newPosition, newCountry);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Football Players'),
      ),
      body: players.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(player['name']),
                    subtitle: Text('${player['position']} - ${player['country']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog(player['id'], player['name'], player['position'], player['country']);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deletePlayer(player['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Player'),
                content: PlayerForm(onSubmit: (name, position, country) {
                  Navigator.of(context).pop();
                  _addPlayer(name, position, country);
                }),
              );
            },
          );
        },
      ),
    );
  }
}
