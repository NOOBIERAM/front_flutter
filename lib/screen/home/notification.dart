import 'package:flutter/material.dart';
import 'package:flutt_mobile/service/friend_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notif extends StatefulWidget {
  const Notif({super.key});
  @override
  State<Notif> createState() => _Notification();
}

class _Notification extends State<Notif> {
  List pending = [];
  List friends = [];
  int id = 0;

  @override
  void initState() {
    super.initState();
    get();
  }
  void refresh(){
    get();
  }
  void get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('id')!;
    });

    Friend.getPending(id).then((value) {
      setState(() {
        pending = value;
      });
    });
    Friend.getSuggest(id).then((value) {
      setState(() {
        friends = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              const InvitationsTexte(),
              for(var element in pending)...[
                InvitationList(name: element['name'], firstname: element['firstname'], id : element['id'], onRefresh: refresh,),
              ],
              const SuggestionTexte(),
              for(var element in friends)...[
                SuggestionList(name: element['name'], firstname: element['firstname'], id : element['id'],userId: id,onRefresh: refresh,),
              ],
            ],
          ))
        ],
      ),
    );
  }
}

class InvitationsTexte extends StatelessWidget {
  const InvitationsTexte({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Invitations',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          )
        ],
      ),
    );
  }
}

class InvitationList extends StatelessWidget {
  final String name;
  final String firstname;
  final int id;
  final VoidCallback onRefresh;
  const InvitationList(
      {super.key, required this.name, required this.firstname, required this.id,required this.onRefresh,});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 21,
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            children: [
              Text(
                firstname,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              Text(
                name,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
              ),
              onPressed: () async {
                  await Friend.accept(id);
                  onRefresh();
                  
              },
              child:  const Text('Accept',
                  style: TextStyle(
                    color: Color.fromARGB(220, 2, 1, 1),
                    fontSize: 15,
                  )),
            ),
          )
        ],
      ),
    );
  }
}

class SuggestionTexte extends StatelessWidget {
  const SuggestionTexte({super.key});
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Suggestions',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          )
        ],
      ),
    );
  }
}

class SuggestionList extends StatelessWidget {
  final String name;
  final String firstname;
  final int id;
  final int userId;
  final VoidCallback onRefresh;
  const SuggestionList(
      {super.key, required this.name, required this.firstname, required this.id, required this.userId, required this.onRefresh});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 21,
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            children: [
              Text(
                firstname,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
              Text(
                name,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ],
          ),
           Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: ElevatedButton(
              style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Color.fromARGB(255, 2, 211, 2)),
              ),
              onPressed: ()async{
                await Friend.follow(userId, id);
                onRefresh();
              },
              child: const Text('Suivre',
                  style: TextStyle(
                    color: Color.fromARGB(220, 2, 1, 1),
                    fontSize: 15,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
