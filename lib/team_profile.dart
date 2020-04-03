import 'package:flutter/material.dart';
import 'global.dart';
import 'classes.dart';
import 'dart:convert';
import 'player_profile.dart';

class TeamProfilePage extends StatefulWidget {
  final String teamId;

  TeamProfilePage({Key key, @required this.teamId}) : super(key: key);

  @override
  _TeamProfilePageState createState() => _TeamProfilePageState(teamId);
}

class _TeamProfilePageState extends State<TeamProfilePage> {
  //TeamProfile _teamProfile;
  String _teamId;

  _TeamProfilePageState(this._teamId);

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: myDarkBlue,
      ),
      body: Container(
        child: FutureBuilder(
          future: this.fetchTeam(_teamId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return getTeamProfile(snapshot.data);
            }
          },
        ),
      ),
    );
  }

  Widget getTeamProfile(TeamProfile team) {
    List<Player> players = team.lineup;
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 15),
      color: myDarkBlue,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            height: 150,
            child: ListView.builder(
                itemCount: players.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlayerProfilePage(
                                    playerId: players[index].playerId,
                                  )));
                    },
                    child: Card(
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 110,
                            padding: EdgeInsets.all(10),
                            child: Image(
                              image: AssetImage('assets/player_images/' +
                                  players[index].playerId +
                                  '.jpeg'),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            //height: 30,
                            child: Text(
                              players[index].nickName,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              height: 500,
              decoration: BoxDecoration(
                  color: myGrey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: 100,
                        padding: EdgeInsets.all(10),
                        child: Image(
                          image: AssetImage(
                              'assets/team_logos/' + team.teamId + '.png'),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            //padding: EdgeInsets.all(5),
                            child: Text(
                              team.teamCountry,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            //padding: EdgeInsets.all(5),
                            child: Text(
                              " " + team.teamName,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  columnElement("World ranking", team.rank),
                  columnElement("Weeks in top30 for core", team.weeks),
                  columnElement("Average player age", team.averageAge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget columnElement(String entry, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          child: Text(entry),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(value),
        ),
      ],
    );
  }
}
