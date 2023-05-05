import 'package:flutter/material.dart';
import 'package:tracker/controller/api_controller.dart';
import 'package:tracker/pages/trackerPage/specificpage.dart';
import 'package:tracker/widgets/order_exceptions.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchValue = TextEditingController();

  // ignore: prefer_typing_uninitialized_variables
  var dataList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 246),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 215, 20, 102),
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Container(
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 5),
              child: TextField(
                controller: _searchValue,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  // contentPadding: const EdgeInsets.only(left: 3),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search_rounded,
                      color: Color.fromARGB(255, 215, 20, 102),
                    ),
                    onPressed: () => setState(() {
                      var sval = _searchValue.text;
                      if (sval != '') {
                        dataList =
                            ApiController().getData('/searchorder/$sval', true);
                      } else {
                        dataList = null;
                      }
                    }),
                  ),
                ),
              ),
            )),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white, //const Color(0xFFD71466),
        ),
      ),
      body: FutureBuilder(
          future: dataList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data.length >= 1) {
                  return optionList(snapshot.data);
                } else {
                  return noDatafound(snapshot.data.length);
                }
              } else {
                return clearPage();
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 221, 13, 93),
                ),
              );
            } else {
              return clearPage();
            }
          }),
    );
  }

  noDatafound(val) {
    return SingleChildScrollView(
      child: Center(
          child: Column(
        children: [
          const SizedBox(height: 100),
          const Image(
            image: AssetImage('img/error/notfound.png'),
            width: 300,
          ),
          const SizedBox(height: 10),
          const Text(
            'No order found for key word',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          Text(
            '"${_searchValue.text}"',
            style: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 194, 8, 76),
            ),
          )
        ],
      )),
    );
  }

  clearPage() {
    return SingleChildScrollView(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(height: 100),
          Image(
            image: AssetImage('img/error/search.png'),
            width: 250,
          ),
          SizedBox(
            width: 250,
            child: Text(
              'You can search by Order ID or Remarks',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    ));
  }

  optionList(data) {
    try {
      return ListView.builder(
          itemCount: data.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return SpecificOrderPage(
                          id: data[index]['id'],
                          status: data[index]['status'],
                        );
                      }),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.92,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 227, 226, 227)
                              .withOpacity(0.6),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                              color: Color.fromARGB(255, 231, 230, 230),
                              width: 1.0,
                            )),
                          ),
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              const Text(
                                'Order ID',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFD81466),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                data[index]['id'].toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF4B465C),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.place_outlined,
                              color: Color(0xFFD81466),
                            ),
                            const SizedBox(width: 5.0),
                            Flexible(
                              child: Text(
                                data[index]['fromaddress'].toString(),
                                style: const TextStyle(
                                  color: Color(0xFF4B465C),
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.place_sharp,
                              color: Color(0xFFD81466),
                            ),
                            const SizedBox(width: 5.0),
                            Flexible(
                              child: Text(
                                data[index]['address'].toString(),
                                style: const TextStyle(
                                  color: Color(0xFF4B465C),
                                  fontSize: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                            ),
                            color: Color(0xFFF8F8F8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                data[index]['datelabel'] + '  ',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFD71466),
                                ),
                              ),
                              Text(
                                data[index]['add_date'].toString(),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF4B465C),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          });
    } catch (e) {
      return OrderException().noData();
    }
  }
}
