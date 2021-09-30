import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mynewsapp/NewsView.dart';
import 'package:mynewsapp/model.dart';

class Category extends StatefulWidget {

  String Query;
  Category({required this.Query});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  bool isLoading = true;

  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];

  getNewsByQuery(String query) async {
    String url="";

    if(query=="Top News"){
       url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=41dd062857f9477ebc0ebe295c896f32";

    }else if(query=="India"){
      url="https://newsapi.org/v2/top-headlines?country=in&apiKey=41dd062857f9477ebc0ebe295c896f32";
    }else  if (query=="Finance"){
       url = "https://newsapi.org/v2/everything?q=finance&from=2021-09-13&to=2021-09-13&sortBy=popularity&apiKey=41dd062857f9477ebc0ebe295c896f32";
    }else if(query=="Politics"){
      url="https://newsapi.org/v2/everything?q=politics&from=2021-09-13&to=2021-09-13&sortBy=popularity&apiKey=41dd062857f9477ebc0ebe295c896f32";
    } else if(query=="Sports"){
      url="https://newsapi.org/v2/top-headlines?country=in&category=sports&apiKey=41dd062857f9477ebc0ebe295c896f32";
    }else if(query=="Entertainment"){
      url="https://newsapi.org/v2/top-headlines?country=in&category=entertainment&apiKey=41dd062857f9477ebc0ebe295c896f32";
    }else if(query=="LATEST NEWS"){
      url="https://newsapi.org/v2/everything?domains=aajtak.in&apiKey=41dd062857f9477ebc0ebe295c896f32";
      //url="https://newsapi.org/v2/top-headlines?country=in&apiKey=41dd062857f9477ebc0ebe295c896f32";
    }else{
      url="https://newsapi.org/v2/everything?q=$query&from=2021-09-13&to=2021-09-13&sortBy=popularity&apiKey=41dd062857f9477ebc0ebe295c896f32";
    }


    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        try{
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
        }catch(e){print(e);}
      });
    });

  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery(widget.Query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NEWS UPDATES"),
        centerTitle: true,
      ),
      body:  SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin : EdgeInsets.fromLTRB(15, 25, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 12,),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Text(widget.Query, style: TextStyle(  fontSize: 39
                      ),),
                    ),
                  ],
                ),
              ),
              isLoading ?  Container(height:MediaQuery.of(context).size.height-450,child: Center(child: CircularProgressIndicator())) :
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: newsModelList.length,
                  itemBuilder: (context, index) {
                    try{
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsView(newsModelList[index].newsUrl)));
                        },
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 1.0,
                            child: Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(newsModelList[index].newsImg ,fit: BoxFit.fitHeight, height: 230,width: double.infinity, )),

                                Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(

                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12.withOpacity(0),
                                                  Colors.black
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter
                                            )
                                        ),
                                        padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              newsModelList[index].newsHead,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(newsModelList[index].newsDes.length > 50 ? "${newsModelList[index].newsDes.substring(0,50)}...." : newsModelList[index].newsDes , style: TextStyle(color: Colors.white , fontSize: 12))
                                          ],
                                        )))
                              ],
                            )),
                      ),
                    );
                    }catch(e){print(e); return Container();}
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
