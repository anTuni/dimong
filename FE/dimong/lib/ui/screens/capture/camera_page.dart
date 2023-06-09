import 'dart:io';
import 'package:dimong/ui/screens/capture/data/repository.dart';
import 'package:dimong/ui/screens/capture/logic/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dimong/ui/widgets/camera.dart';
import 'package:dimong/ui/modals/modal.dart';
import 'package:dimong/core/api/api.dart';
import './data/data.dart';
import 'package:dimong/core/api/api.dart';
import './data/repository.dart';
import './loading_image.dart';
import 'package:provider/provider.dart';
import 'package:dimong/ui/screens/dic_detail/dic_detail.dart';
import './camera_modal.dart';
import 'package:dimong/ui/widgets/connect_route.dart';

// Camera Widget을 생성
class CameraPage extends StatefulWidget {
  final File? file;
  CameraPage({Key? key, required this.file}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final picker = ImagePicker();
  File? _image;
  void initState() {
    super.initState();
    _image = widget.file != null ? File(widget.file!.path) : null;
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.83,
      child: _image == null
          ? Center(child: Text('No image selected.'))
          : Image.file(File(_image!.path)),
    );
  }

  void _showModal() async {
    /*await showModalBottomSheet(
       context: context,
       builder: (context) => CameraModal()
     );*/
    await showCupertinoModalPopup(
        context: context, builder: (context) => CameraModal());
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    ConnectRoute _connectRoute = ConnectRoute();
    return Scaffold(
      backgroundColor: Colors.black,
      body: ChangeNotifierProvider(
          create: (_) => CameraViewModel(
              repository: CameraRepository(), imageFile: widget.file!),
          child: Consumer<CameraViewModel>(builder: (_, viewModel, __) {
            return Stack(
              children: [
                // SizedBox(height: 25.0),
                showImage(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          File? imageCamera =
                              await getImageFile(ImageSource.camera);
                          if (imageCamera != null) {
                            _image = File(imageCamera.path);
                            viewModel.analyzeImage(_image);
                          }
                        },
                        child: Text(
                          '다시 찍기',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff6B6B6B), // Set button color
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10) // Set button shape
                              ),
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(
                                0xffACC864), // Set the background color of the button
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10) // Set button shape
                                ), // Set the shape of the button to a circle
                          ),
                          onPressed: () async {
                            if (_image != null) {
                              if (viewModel.isLoading) {
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                          '~/assets/images/analyzing.png'),
                                      SizedBox(height: 16),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                                );
                              } else {
                                print(viewModel.dinosaurs!.dinosaurId);
                                bool foundCheck = viewModel.dinosaurs!.found!;
                                int id = viewModel.dinosaurs!.dinosaurId!;
                                print("found?: $foundCheck");
                                if (viewModel.dinosaurs!.dinosaurId != null) {
                                  if (foundCheck = true && id >= 0) {
                                    print("dinosaur 있어요");
                                    print("found!: $foundCheck");
                                    Navigator.pop(context);
                                    _connectRoute.toDinoDetail(context,
                                        viewModel.dinosaurs!.dinosaurId!);
                                  } else {
                                    print("dinosaur 없어요");
                                    _showModal();
                                  }
                                }
                              }
                              setState(() {
                                _image = widget.file;
                              });
                            }
                          },
                          child: Text('분석하기', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          })),
    );
  }
}
