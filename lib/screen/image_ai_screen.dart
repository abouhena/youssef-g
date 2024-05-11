
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourism_app/bloc/app_cubit.dart';
import 'package:tourism_app/bloc/app_state.dart';

class ImageAiScreen extends StatefulWidget {
  const ImageAiScreen({Key? key}) : super(key: key);

  @override
  State<ImageAiScreen> createState() => _ImageAiScreenState();
}

class _ImageAiScreenState extends State<ImageAiScreen> {

  @override
  void initState() {
    BlocProvider.of<AppCubit>(context).mainFileOfferDetails ==null;
    BlocProvider.of<AppCubit>(context).imageModel ==null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Upload Image',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
              )),
          centerTitle: true,
          backgroundColor:  const Color(0xffFFBB2B),
          elevation: 0.0,
        ),
        body: BlocBuilder<AppCubit,AppState>(
          builder: (context,state){
            var cubit =AppCubit.get(context);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: InkWell(
                      onTap: (){
                        showDialog(context: context,
                            builder: (context){
                          return AlertDialog(
                            title: Text('Choose Image'),
                            content: Column(
                               mainAxisSize: MainAxisSize.min,
                              children: [


                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Color(0xffFFBB2B))
                                  ),
                                  onPressed: () async{
                                    XFile ? file = await ImagePicker().pickImage(source: ImageSource.gallery,maxWidth: 1080,maxHeight: 1080);
                                    if(file !=null){
                                      cubit.addMainDetails(file.path);
                                    }
                                  },
                                  child: const Text(
                                    'Garllay',
                                    style:
                                    TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 15,),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Color(0xffFFBB2B))
                                  ),
                                  onPressed: () async{
                                    XFile ? file = await ImagePicker().pickImage(source: ImageSource.camera,maxWidth: 1080,maxHeight: 1080);
                                    if(file !=null){
                                      cubit.addMainDetails(file.path);
                                    }
                                  },
                                  child: const Text(
                                    'Camera',
                                    style:
                                    TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          );
                            });
                      },
                      child: Container(
                        height: 300,
                        width: double.infinity,
                        decoration:  BoxDecoration(
                          color: Colors.grey.shade50
                        ),
                        child: cubit.mainFileOfferDetails == null ?
                        const Center(child:Icon(Icons.add)):
                        Image.file(cubit.mainFileOfferDetails!,fit: BoxFit.fill),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20,),
                  (state is LoadingImageAiState)?
                  const CircularProgressIndicator():
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xffFFBB2B))
                    ),
                    onPressed: () {
                     cubit.imageAi();
                    },
                    child: const Text(
                      'Upload',
                      style:
                      TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20,),

                  (state is SuccessImageAiState)?
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            cubit.imageModel?.captionModel?.text??'',
                            style:
                            const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10,),

                          ...(cubit.imageModel?.captionList??[]).map((e){
                            return Text(
                              e.text??'',
                              style:
                              const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          })
                        ],
                      ):Container()





                ],
              ),
            );
          },
        )
    );
  }
}
