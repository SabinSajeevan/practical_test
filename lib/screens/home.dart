import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practical_test/helpers.dart';
import 'package:practical_test/models/customers_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Customer> customer_list = new List();
  bool isLoading = true;
  bool isNoData = false;
  String url1 =
      "https://routepro.cloud/demo/bo/api/index/getsyncdata/routeid/1101/userid/15/deviceid/36f238d651dfeaa1/mdate/0/table/1";
  String url2 =
      "https://routepro.cloud/demo/bo/api/index/getsyncdata/routeid/1101/userid/15/deviceid/36f238d651dfeaa1/mdate/0/table/4";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController controller = new TextEditingController();

  List<Customer> _searchResultList = [];

  @override
  void initState() {
    super.initState();
    getCustomers();
  }

  void getCustomers() {
    Helpers().fetchCustomers(url1).then((value) {
      if (value != null && value != "" && value.contains("{")) {
        Helpers().fetchCustomers(url2).then((val) {
          if (value != null && value != "" && value.contains("{")) {
            List jsonResponse = json.decode(val)['CustomerMaster'];
            setState(() {
              customer_list =
                  jsonResponse.map((c) => new Customer.fromJson(c)).toList();
              _searchResultList = customer_list;
              isLoading = false;
              isNoData = false;
              _scaffoldKey.currentState
                  .showSnackBar(new SnackBar(content: new Text("Updated!")));
            });
          } else {
            setState(() {
              isLoading = false;
              isNoData = true;
              _scaffoldKey.currentState.showSnackBar(new SnackBar(
                  content: new Text(
                      "Oops! something went wrong,Please try again.")));
            });
          }
        });
      } else {
        setState(() {
          isLoading = false;
          isNoData = true;
          _scaffoldKey.currentState.showSnackBar(new SnackBar(
              content:
                  new Text("Oops! something went wrong,Please try again.")));
        });
      }
    });
  }

  Future<void> _getData() async {
    setState(() {
      getCustomers();
    });
  }

  void updateList(string) {
    setState(() {
      _searchResultList = customer_list
          .where((u) =>
              (u.customername.toLowerCase().contains(string.toLowerCase()) ||
                  u.customercode.toLowerCase().contains(string.toLowerCase())))
          .toList();
    });
  }

  Widget getListTile(_list, index) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 2.0,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200])),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {},
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(_list[index - 1].customername),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "Address 1 : ${_list[index - 1].customeraddress1}"),
                        Text("Address 2 : ${_list[index - 1].customeraddress2}")
                      ],
                    ),
                    isThreeLine: true,
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Helpers().randomColor(index)),
                      alignment: Alignment.center,
                      child: Text(
                        (_list[index - 1].customername)
                            .substring(0, 1)
                            .toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text("City"),
                              Text(
                                _list[index - 1].customercity,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text("Credit"),
                              Text(
                                _list[index - 1].creditlimit,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text("Code"),
                              Text(
                                _list[index - 1].customercode,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15),
                              )
                            ],
                          )
                        ],
                      ))
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        body: RefreshIndicator(
            onRefresh: _getData,
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50, bottom: 15),
                child: Text(
                  "Flutter Practical",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 24),
                ),
              ),
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: isLoading
                          ? ListView(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 200),
                                  alignment: Alignment.center,
                                  child: CupertinoActivityIndicator(
                                    radius: 20,
                                  ),
                                )
                              ],
                            )
                          : isNoData
                              ? ListView(children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 200),
                                    child: Text("No Data"),
                                  )
                                ])
                              : Column(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      width: 100,
                                      height: 4,
                                      color: Colors.grey[200],
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              _searchResultList.length + 1,
                                          itemBuilder: (context, index) {
                                            return index == 0
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15,
                                                        right: 15,
                                                        top: 5,
                                                        bottom: 20),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    child: InkWell(
                                                        onTap: () {
                                                          updateList(controller
                                                              .text
                                                              .trim());
                                                        },
                                                        child: SizedBox(
                                                          height: 45,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Expanded(
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      controller,
                                                                  onChanged:
                                                                      (val) {
                                                                    updateList(
                                                                        val);
                                                                  },
                                                                  decoration:
                                                                      InputDecoration(
                                                                    contentPadding:
                                                                        EdgeInsets.symmetric(
                                                                            vertical:
                                                                                3),
                                                                    fillColor:
                                                                        Colors
                                                                            .white,
                                                                    filled:
                                                                        true,
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10.0)),
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color: Colors.grey[300]),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10.0)),
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color: Colors.grey[300]),
                                                                    ),
                                                                    prefixIcon:
                                                                        Icon(Icons
                                                                            .search),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            15),
                                                                child: Text(
                                                                  "Search",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )))
                                                : getListTile(
                                                    _searchResultList, index);
                                          }),
                                    )
                                  ],
                                )))
            ])) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
