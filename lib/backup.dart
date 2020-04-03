import 'package:flutter/material.dart';
import 'global.dart';
import 'classes.dart';
import 'dart:convert';

class TeamProfilePage extends StatefulWidget {
  @override
  _TeamProfilePageState createState() => _TeamProfilePageState();
}

class _TeamProfilePageState extends State<TeamProfilePage> {
  TeamProfile _teamProfile;
  String _id = "4608";

  Future<TeamProfile> fetchTeam(String id) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/team_profiles.json");
    final teamsJson = json.decode(data);

    TeamProfile teamProfile;
    //print("started fetch");
    for (var team in teamsJson) {
      print(team['team-id']);
      if (team['team-id'].toString() == id) {
        //print(id + "found !");
        teamProfile = TeamProfile.fromJson(team);
        break;
      }
    }

    return teamProfile;
  }

  @override
  void initState() {
    fetchTeam(_id).then((value) {
      _teamProfile = value;
      print(_teamProfile.teamName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: Text("Team : " + _teamProfile.teamName),
      ),
    );
  }
}
