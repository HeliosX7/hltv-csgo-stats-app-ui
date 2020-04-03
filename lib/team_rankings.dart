import 'dart:convert';
import 'package:flutter/material.dart';
import 'classes.dart';
import 'global.dart';
import 'team_profile.dart';

class Rankings extends StatefulWidget {
  @override
  _RankingsState createState() => _RankingsState();
}

class _RankingsState extends State<Rankings> {
  List<Team> _teams = List<Team>();

  Future<List<Team>> fetchTeams() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/teams.json");
    final teamsJson = json.decode(data);

    var teams = List<Team>();

    for (var team in teamsJson) {
      teams.add(Team.fromJson(team));
    }

    return teams;
  }

  @override
  void initState() {
    super.initState();
    fetchTeams().then((value) {
      setState(() {
        _teams.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myDarkBlue,
      appBar: AppBar(
        title: Text(
          "HLTV",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: myDarkBlue,
      ),
      body: Container(
        //height: 600,
        decoration: BoxDecoration(
          color: myGrey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "CS:GO World ranking",
                style: TextStyle(
                    fontSize: 20,
                    color: myDarkGrey,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 640,
              margin: EdgeInsets.only(top: 10),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeamProfilePage(
                                    teamId: _teams[index].teamId.toString(),
                                  )));
                    },
                    child: Card(
                      elevation: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            width: 50,
                            child: Text(
                              '#' + _teams[index].rank.toString(),
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 70,
                            padding: EdgeInsets.all(10),
                            child: Image(
                              image: AssetImage('assets/team_logos/' +
                                  _teams[index].teamId.toString() +
                                  '.png'),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            width: 150,
                            child: Text(
                              _teams[index].teamName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: Text(_teams[index].points.toString()),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: _teams.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
