part of 'widgets.dart';

class uiloading{

  static Container loading(){
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: const SpinKitFadingCircle(
        size: 50,
        color: Colors.red,
      ),
    );
  }

}