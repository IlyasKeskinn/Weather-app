import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather/utils/location_helper.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late LocationHelper locationHelper;
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    locationHelper = LocationHelper();
    await locationHelper.getCurrentLocation();

    if (locationHelper.latitude == null || locationHelper.longitude == null) {
      print("Konuma erişilemiyor");
    } else {
      print('Latitude' + locationHelper.latitude.toString());
      print('longitude' + locationHelper.longitude.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [ColorConst.royalBlue, ColorConst.shovelKnigtBlue])),
          child: Column(
            children: [
              const Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.zero,
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: ImagePath().assetImage('logo'))),
                  ),
                ),
              ),
              const Expanded(
                flex: 1,
                child: SpinKitChasingDots(
                  color: Colors.amber,
                  duration: Duration(milliseconds: 1500),
                ),
              )
            ],
          )),
    );
  }
}

class ColorConst {
  static Color royalBlue = const Color(0xff29B2DD);
  static Color shovelKnigtBlue = const Color(0xff2DC8EA);
}

class ImagePath {
  AssetImage assetImage(String imageName) {
    return AssetImage(imagePath(imageName));
  }

  String imagePath(String imageName) {
    return 'assets/png/$imageName.png';
  }
}
