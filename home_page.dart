import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:read_api_assignment/models/corona_virus.dart';
import 'package:read_api_assignment/pages/Search_page.dart';
import 'package:read_api_assignment/pages/corona_reader.dart';
import 'package:read_api_assignment/pages/country_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> country = ['country'];
  List<String> eachcountry;

  @override
  void initState() {
    eachcountry = country;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: _buildBody,
    );
  }
  
  get _buildAppBar {
    return AppBar(
      backgroundColor: Colors.purpleAccent,
      title: Text("COVID-19 TRACKER", style: TextStyle(fontWeight: FontWeight.bold),),
      centerTitle: true,
      actions: <Widget>[
        IconButton(icon: Icon(Icons.search), onPressed: (){
          showSearch(context: context, delegate: Search(country));
        },),
      ],
    );
  }

  get _buildBody {
    return Container(
      child: FutureBuilder(
        future: covid,
        builder: (context, snapshot){
          if (snapshot.hasError){
            print("snapshot.error : ${snapshot.error}");
            return Icon(Icons.error, size: 50,);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildListView(snapshot.data);
          }
          else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
  _buildListView(List<CoronaVirus> postList){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: postList.length,
      itemBuilder: (context, index){
        return _buildItem(postList[index]);
      },
    );
  }

  _buildItem (CoronaVirus item) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CountryPage(item: item)
        ));
      },
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Card(
          child: ListTile(
            leading: Image.network("${item.countryInfo.flag}", height: 50,width: 50,),
            title: Text("${item.country}",style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text("TodayCases: ${item.todayCases}",style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
          ),
          /*Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("${item.country}"),
                  Image.network("${item.countryInfo.flag}", height: 50,width: 50,),
                ],
              ),
            ],
          ),*/
        ),
      ),
    );
  }
}
