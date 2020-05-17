import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:githubflutters/manager/contact_manager.dart';
import 'package:githubflutters/model/contact.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final ContactManager manager = ContactManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          'Github Users',
          style: TextStyle(fontSize: 20.0),
        ),
        actions: <Widget>[
          StreamBuilder<int>(
            stream: manager.contactCounter,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Chip(
                  label: Text(
                    (snapshot.data ?? 0).toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.white,
                ),
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: manager.containListView,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            //return Loader(loaderName: 'No Internet');
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Loader(loaderName: 'loading');
            case ConnectionState.done:
              List<Contact> contacts = snapshot.data;
              return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  Contact _contact = contacts[index];
                  //print('URL ####: ${_contact.url.location}');
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.network(
                                _contact.avatar,
                                height: 100.0,
                              ),
                            ),
                            title: Text(
                              _contact.login.toUpperCase(),
                            ),
                            subtitle: Text(
                              'Github',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: OutlineButton(
                            onPressed: () {
                              _launchInBrowser(_contact.html);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'View Profile',
                                  style: TextStyle(fontSize: 10.0),
                                ),
                                SizedBox(width: 10.0),
                                FaIcon(
                                  FontAwesomeIcons.github,
                                  size: 18.0,
                                ),
                              ],
                            ),
                            borderSide: BorderSide(
                                style: BorderStyle.solid, width: 2.0),
                            shape: StadiumBorder(),
                          ),
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  thickness: 1.0,
                ),
                itemCount: contacts?.length ?? 0,
              );
          }
          return Container();
        },
      ),
    );
  }
}

//url launcher
Future<void> _launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  } else {
    throw 'Could not launch $url';
  }
}

class Loader extends StatelessWidget {
  final String loaderName;
  const Loader({@required this.loaderName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Card(
          color: Colors.black87,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(width: 35),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  loaderName,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6.0,
                      fontSize: 15.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
