import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Note des liens pour l'API:
// API: https://staging.revolvair.org/documentation/?url=https://staging.revolvair.org/documentation/api-docs.json 
// 1.   https://staging.revolvair.org/documentation/?url=https://staging.revolvair.org/documentation/api-docs.json#/RevolvAir/Modules%5CRevo%5CHttp%5CControllers%5CStationController%3A%3Aindex
// 2.   https://staging.revolvair.org/documentation/?url=https://staging.revolvair.org/documentation/api-docs.json#/RevolvAir/Modules%5CRevo%5CHttp%5CControllers%5CStationController%3A%3AshowUsersStation

class Data {
    Data({
      required this.data
    });

    List<Station> data;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
      data: List<Station>.from(json["data"].map((x) => Station.fromJson(x)))
    );
}

class Station {
  final int id;
  final String? name;
  final String? desc;
  final int userId;

  Station({required this.id, required this.name, required this.desc, required this.userId});

  factory Station.fromJson(Map<String, dynamic> json) => Station(
      id: json["id"],
      name: json["name"],
      desc: json["description"],
      userId: json["user_id"]
    );

  @override
  String toString() => '''Station $id (name: $name, desc: $desc, userId: $userId)''';
}

abstract class ReadLine {
  get choice => null;

  bool readChoiceInt(){return false;}
}

class MyReadLine implements ReadLine {
  int _choice = 0;

  @override
  int get choice => _choice;

  @override
  bool readChoiceInt() {
    try {
      var line = stdin.readLineSync();
      if(line != null) {
        _choice = int.parse(line);
        return true;
      }
    } on FormatException {
      return false;
    }
    return false;
  }
}

Data dataFomJson(String str) => Data.fromJson(json.decode(str));

Future<List<Station>> fetchStation(http.Client client, String request) async {
  print("Requête: $request");
  final response = await client.get(Uri.parse(request));
  if(response.statusCode == 200) {
    Data data = dataFomJson(response.body);
    return data.data;
  } else {
    throw Exception("Une erreur est survenu...(${response.statusCode})");
  }
}

void main() async {
  print("");
  print("TP1 - Partie #1");

  bool run = true;
  MyReadLine reader = MyReadLine();

  while(run) {
    print("");
    print("1. Afficher la liste des stations actives contenant leur nom (name), leur description et le ID du propriétaire;");
    print("2. Pour un ID d'un propriétaire, afficher la liste des stations actives qu'il gère (le nom et sa description)(présentement, selement le id 1 donne un résultat);");
    print("3. Quitter.");
    print("");
    print("Entrez votre choix:");

    if(!reader.readChoiceInt()) {
      print("Input invalide...");
      continue;
    } else {
      if(reader.choice == 1) {
        late Future<List<Station>> stations;
        try {
          stations = fetchStation(http.Client(), "https://staging.revolvair.org/api/revolvair/stations/");
          for(Station station in await stations)
          {
            print(station);
          }
        } catch (e) {
          print(e.toString());
        }
      } else if(reader.choice == 2) {
        print("Entrer le id d'un user:");
        if(!reader.readChoiceInt()) {
          print("Input invalide...");
          continue;
        }
        late Future<List<Station>> stations;
        try {
          stations = fetchStation(http.Client(), "https://staging.revolvair.org/api/revolvair/users/${reader.choice}/stations");
          for(Station station in await stations)
          {
            print(station);
          }
        } catch (e) {
          print(e.toString());
        }
      } else if(reader.choice == 3) {
        run = false;
      }
    } 
  }

  print("");
  print("Arrêt en cours...");
}