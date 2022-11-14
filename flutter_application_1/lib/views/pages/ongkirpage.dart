part of 'pages.dart';

class Ongkirpage extends StatefulWidget {
  const Ongkirpage({Key? key}) : super(key: key);

  @override
  _OngkirpageState createState() => _OngkirpageState();
}

class _OngkirpageState extends State<Ongkirpage> {
  bool isLoading = false;
  String selectedCourier = 'jne';
  var kurir = ['jne', 'pos', 'tiki'];

  final ctrlBerat = TextEditingController();

  dynamic provId;
  dynamic provinceData;
  dynamic selectedProvOrigin;
  dynamic selectedProvDestination;
  Future<List<Province>> getProvinces() async {
    dynamic listProvince;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        listProvince = value;
      });
    });
    return listProvince;
  }

  dynamic cityIdOrigin;
  dynamic cityIdDestination;
  dynamic cityDataOrigin;
  dynamic cityDataDestination;
  dynamic selectedCityOrigin;
  dynamic selectedCityDestination;
  Future<List<City>> getCities(dynamic provId) async {
    dynamic listCity;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        listCity = value;
      });
    });
    return listCity;
  }

  bool isProvinceOriginSelected = false;
  bool isCityOriginSelected = false;

  bool isProvinceDestinationSelected = false;
  bool isCityDestinationSelected = false;

  List<Costs> listCosts = [];
  Future<dynamic> getCostsData() async {
    await RajaOngkirServices.getMyOngkir(cityIdOrigin, cityIdDestination,
            int.parse(ctrlBerat.text), selectedCourier)
        .then((value) {
      setState(() {
        listCosts = value;
      });
      print(listCosts.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    provinceData = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Hitung Ongkir"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 1400,
          child: Stack(
            children: [
              Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      //Flexible untuk form
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            Lottie.asset(
                              "assets/lottie/courier.json",
                            ),
                            const Padding(
                                //Origin---------------------------------------------------
                                padding: EdgeInsets.all(16.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Courier",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DropdownButton(
                                      value: selectedCourier,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      items: kurir.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedCourier = newValue!;
                                        });
                                      }),
                                  SizedBox(
                                      width: 200,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: ctrlBerat,
                                        decoration: const InputDecoration(
                                          labelText: 'Berat (gr)',
                                        ),
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          return value == null || value == 0
                                              ? 'Berat harus diisi atau tidak boleh 0!'
                                              : null;
                                        },
                                      ))
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Padding(
                                //Origin---------------------------------------------------
                                padding: EdgeInsets.all(16.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Origin",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                )),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 150,
                                      child: FutureBuilder<List<Province>>(
                                          future: provinceData,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return DropdownButton(
                                                  isExpanded: true,
                                                  value: selectedProvOrigin,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  hint: selectedProvOrigin ==
                                                          null
                                                      ? Text('Pilih provinsi')
                                                      : Text(selectedProvOrigin
                                                          .province),
                                                  items: snapshot.data!.map<
                                                          DropdownMenuItem<
                                                              Province>>(
                                                      (Province value) {
                                                    return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(value
                                                            .province
                                                            .toString()));
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedProvOrigin =
                                                          newValue;
                                                      provId =
                                                          selectedProvOrigin
                                                              .provinceId;
                                                      isProvinceOriginSelected =
                                                          true;
                                                    });
                                                    selectedCityOrigin = null;
                                                    cityDataOrigin =
                                                        getCities(provId);
                                                  });
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  "Tidak ada data.");
                                            }

                                            return uiloading.loadingDD();
                                          }),
                                    ),
                                    Container(
                                      width: 150,
                                      child: FutureBuilder<List<City>>(
                                          future: cityDataOrigin,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return DropdownButton(
                                                  isExpanded: true,
                                                  value: selectedCityOrigin,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  hint: selectedCityOrigin ==
                                                          null
                                                      ? Text('Pilih kota')
                                                      : Text(selectedCityOrigin
                                                          .cityName),
                                                  items: snapshot.data!.map<
                                                      DropdownMenuItem<
                                                          City>>((City value) {
                                                    return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(value
                                                            .cityName
                                                            .toString()));
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedCityOrigin =
                                                          newValue;
                                                      isCityOriginSelected =
                                                          true;
                                                      cityIdOrigin =
                                                          selectedCityOrigin
                                                              .cityId;
                                                    });
                                                  });
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  "Tidak ada data.");
                                            }

                                            if (isProvinceOriginSelected ==
                                                false) {
                                              return Text(
                                                  "Silahkan pilih provinsi");
                                            } else {
                                              return uiloading.loadingDD();
                                            }
                                          }),
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              height: 24,
                            ),
                            const Padding(
                                // Destination ----------------------------------------------------
                                padding: EdgeInsets.all(16.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Destination",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                )),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 150,
                                      child: FutureBuilder<List<Province>>(
                                          future: provinceData,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return DropdownButton(
                                                  isExpanded: true,
                                                  value:
                                                      selectedProvDestination,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  hint: selectedProvDestination ==
                                                          null
                                                      ? Text('Pilih provinsi')
                                                      : Text(
                                                          selectedProvDestination
                                                              .province),
                                                  items: snapshot.data!.map<
                                                          DropdownMenuItem<
                                                              Province>>(
                                                      (Province value) {
                                                    return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(value
                                                            .province
                                                            .toString()));
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedProvDestination =
                                                          newValue;
                                                      provId =
                                                          selectedProvDestination
                                                              .provinceId;
                                                      isProvinceDestinationSelected =
                                                          true;
                                                    });
                                                    selectedCityDestination =
                                                        null;
                                                    cityDataDestination =
                                                        getCities(provId);
                                                  });
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  "Tidak ada data.");
                                            }
                                            return uiloading.loadingDD();
                                          }),
                                    ),
                                    Container(
                                      width: 150,
                                      child: FutureBuilder<List<City>>(
                                          future: cityDataDestination,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return DropdownButton(
                                                  isExpanded: true,
                                                  value:
                                                      selectedCityDestination,
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 16,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  hint: selectedCityDestination ==
                                                          null
                                                      ? Text('Pilih kota')
                                                      : Text(
                                                          selectedCityDestination
                                                              .cityName),
                                                  items: snapshot.data!.map<
                                                      DropdownMenuItem<
                                                          City>>((City value) {
                                                    return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(value
                                                            .cityName
                                                            .toString()));
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedCityDestination =
                                                          newValue;
                                                      isCityDestinationSelected =
                                                          true;
                                                      cityIdDestination =
                                                          selectedCityDestination
                                                              .cityId;
                                                    });
                                                  });
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                  "Tidak ada data.");
                                            }

                                            if (isProvinceDestinationSelected ==
                                                false) {
                                              return Text(
                                                  "Silahkan pilih provinsi");
                                            } else {
                                              return uiloading.loadingDD();
                                            }
                                          }),
                                    ),
                                  ],
                                )),
                            SizedBox(height: 50),
                            ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ))),
                                onPressed: () {
                                  if (isProvinceDestinationSelected == true &&
                                      isProvinceOriginSelected == true &&
                                      isCityDestinationSelected == true &&
                                      isCityOriginSelected == true &&
                                      selectedCourier.isNotEmpty &&
                                      ctrlBerat.text.isNotEmpty) {
                                    getCostsData();

                                    // Fluttertoast.showToast(
                                    //     msg: "ORIGIN: " +
                                    //         selectedCityOrigin.cityName
                                    //             .toString() +
                                    //         ", DESTINATION: " +
                                    //         selectedCityDestination.cityName
                                    //             .toString(),
                                    //     backgroundColor: Colors.green);

                                  } else {
                                    UiToast.toastErr("Semua field harus diisi");

                                    // Fluttertoast.showToast(
                                    //     msg:
                                    //         "ORIGIN dan atau DESTINATION masih belum diset",
                                    //     backgroundColor: Colors.red);
                                  }
                                },
                                child: Text("Hitung Estimasi Harga"))
                          ],
                        ),
                      ),

                      //Felxible untuk nampilin data
                      Flexible(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: listCosts.isEmpty
                              ? const Align(
                                  alignment: Alignment.center,
                                  child: Text("Tidak ada data"))
                              : ListView.builder(
                                  itemCount: listCosts.length,
                                  itemBuilder: (context, index) {
                                    return LazyLoadingList(
                                        initialSizeOfItems: 10,
                                        loadMore: () {},
                                        child: CardOngkir(listCosts[index]),
                                        index: index,
                                        hasMore: true);
                                  },
                                ),
                        ),
                      ),
                    ],
                  )),
              isLoading == true ? uiloading.loadingBlock() : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
