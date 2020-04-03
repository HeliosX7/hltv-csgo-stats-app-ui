class Team {
  String teamName;
  int rank, points, teamId;
  Team(this.teamName, this.rank, this.points, this.teamId);

  Team.fromJson(Map<String, dynamic> json) {
    teamName = json['team-name'];
    rank = json['rank'];
    points = json['points'];
    teamId = json['team-id'];
  }
}

class TeamProfile {
  String teamId, teamName, teamCountry, rank, weeks, averageAge;
  List<Player> lineup = List<Player>();

  TeamProfile(this.teamId, this.teamName, this.teamCountry, this.rank,
      this.weeks, this.averageAge, this.lineup);

  TeamProfile.fromJson(Map<String, dynamic> json) {
    teamId = json['team-id'].toString();
    teamName = json['team-name'];
    teamCountry = json['team-country'];
    rank = json['rank'];
    weeks = json['weeks'];
    averageAge = json['average-age'];

    for (var player in json['lineup']) {
      lineup.add(Player.fromJson(player));
    }
  }
}

class Player {
  String nickName, playerId;

  Player(this.nickName, this.playerId);

  Player.fromJson(Map<String, dynamic> json) {
    nickName = json['nickname'];
    playerId = json['player-id'];
  }
}

class PlayerProfile {
  String nickname,
      name,
      teamName,
      age,
      playerId,
      teamId,
      rating,
      dpr,
      kast,
      impact,
      adr,
      kpr;

  PlayerProfile(
      this.nickname,
      this.name,
      this.teamName,
      this.age,
      this.playerId,
      this.teamId,
      this.rating,
      this.dpr,
      this.kast,
      this.impact,
      this.adr,
      this.kpr);

  PlayerProfile.fromJson(Map<String, dynamic> json) {
    nickname = json['nickname'];
    name = json['name'];
    teamName = json['team-name'];
    age = json['age'];
    playerId = json['player-id'];
    teamId = json['team-id'];
    rating = json['rating'];
    dpr = json['DPR'];
    kast = json['KAST'];
    kast = kast.substring(0, 4);
    impact = json['impact'];
    adr = json['ADR'];
    kpr = json['KPR'];
  }
}
