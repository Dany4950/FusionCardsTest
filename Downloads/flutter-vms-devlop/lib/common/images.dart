import 'package:vms/manager/api_manager/url.dart';

extension StringEx on String {
  String get png {
    return 'assets/images/$this.png';
  }

  String get svg {
    return 'assets/images/$this.svg';
  }

  String get lottie {
    return 'assets/animation/$this.json';
  }

  String gif(String name) {
    return 'assets/animation/$name.gif';
  }
 
  String get s3Url {
    return '${BaseURL.baseURL}/${EndPoint.stream}?key=$this';
  }
}
