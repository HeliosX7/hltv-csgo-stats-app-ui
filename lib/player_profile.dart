import 'package:flutter/material.dart';
import 'classes.dart';
import 'global.dart';
import 'dart:convert';

class PlayerProfilePage extends StatefulWidget {
  final String playerId;

  PlayerProfilePage({Key key, @required this.playerId}) : super(key: key);
  @override
  _PlayerProfilePageState createState() => _PlayerProfilePageState(playerId);
}

class _PlayerProfilePageState extends State<PlayerProfilePage> {
  String _playerId;

  _PlayerProfilePageState(this._playerId);

  Future<PlayerProfile> fetchPlayer(String id) async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/player_profiles.json");
    final playersJson = json.decode(data);

    PlayerProfile playerProfile;

    print("started fetch");
    for (var player in playersJson) {
      print(player['player-id']);
      if (player['player-id'] == id) {
        print(id + "found !");
        playerProfile = PlayerProfile.fromJson(player);
        break;
      }
    }

    return playerProfile;
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
          future: this.fetchPlayer(_playerId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return getPlayerProfile(snapshot.data);
            }
          },
        ),
      ),
    );
  }

  Widget getPlayerProfile(PlayerProfile player) {
    List<String> statValue = [
      player.rating,
      player.dpr,
      player.kast,
      player.impact,
      player.adr,
      player.kpr
    ];
    return Container(
      color: myDarkBlue,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: <Widget>[
                Container(
                  width: 180,
                  padding: EdgeInsets.only(left: 10, right: 15),
                  child: Image(
                    image: AssetImage(
                        'assets/player_images/' + player.playerId + '.jpeg'),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 70,
                            height: 50,
                            //padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Image(
                              image: AssetImage(
                                'assets/team_logos/' + player.teamId + '.png',
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              player.teamName,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          player.nickname,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      columnElement("Name", player.name),
                      columnElement("Age", player.age)
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              //height: 500,
              decoration: BoxDecoration(
                  color: myGrey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  )),
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    //height: 100,
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Statistics",
                      style: TextStyle(
                          fontSize: 20,
                          color: myDarkGrey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 300,
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: List.generate(6, (index) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: getGradColor(
                                    index, double.parse(statValue[index]))),
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                  color: myDarkGrey.withOpacity(.7),
                                  offset: Offset(0.0, 8.0),
                                  blurRadius: 8.0)
                            ],
                          ),
                          //padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                statEntry[index].toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                statValue[index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
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
          padding: EdgeInsets.all(5),
          child: Text(
            entry,
            style: TextStyle(color: Colors.white),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: Text(
            value,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  List<Color> getGradColor(index, double value) {
    List<double> range = statsRange[index];
    if (index == 1) {
      value = -value;
    }

    if (value < range[0]) {
      return gradRed;
    } else if (value > range[1]) {
      return gradGreen;
    } else {
      return gradYellow;
    }
  }
}
