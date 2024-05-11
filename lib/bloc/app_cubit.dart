
import 'dart:convert';
import 'dart:io';

import 'package:tourism_app/bloc/app_state.dart';
import 'package:tourism_app/model/login_model.dart';
import 'package:tourism_app/model/model.dart';
import 'package:tourism_app/screen/chat_bot_screen.dart';
import 'package:tourism_app/services/shared_pref_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;


class AppCubit extends Cubit<AppState> {

  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  final String baseUrl= 'http://tourismapp.somee.com';

  Map<String , String > header={
    'Accept':'application/json',
    'Content-Type':'application/json',
    // 'authorization':'Basic ${base64Encode(utf8.encode('11170315:60-dayfreetrial'))}'
  };

  void login({required String email , required String password})async{
    emit(LoadingLoginState());
    try{
      http.Response response = await http.post(Uri.parse('$baseUrl/api/Auth/Login'),
          body: json.encode({
            'username':email,
            'password':password
          }),headers:header );
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        LoginModel loginModel = LoginModel.jsonData(data);
        SharedPref.setDate(key: 'kToken',value:  loginModel.accessToken??'');
        SharedPref.setDate(key: 'kUserId',value: loginModel.userId.toString());
        SharedPref.setDate(key: 'kLogin',value:  true);
        emit(SuccessLoginState());
      }else{
        emit(ErrorLoginState());
      }
    }catch(e){
      emit(ErrorLoginState());
    }
  }


  void signUp({required String email , required String password , required String phone , required String userName , required String fullName})async{
    emit(LoadingSignUpState());
    try{
      http.Response response = await http.post(Uri.parse('$baseUrl/api/Auth/Register'),
          body: json.encode({
            'username':userName,
            'fullName':fullName,
            'email':email,
            'phone':phone,
            'password':password,
          }),headers:header);
      print('ff');
      if(response.body.isNotEmpty){
        var data = jsonDecode(response.body);
        print(data);
      }
      print(response.statusCode);

      if(response.statusCode==200 || response.statusCode==201){
        emit(SuccessSignUpState());
      }else{
        emit(ErrorSignUpState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorSignUpState());
    }
  }

  int currentIndexNav=0;
  void changeCurrentIndexNav(int index){
    currentIndexNav=index;
    emit(AppInitialState());
  }

  List<TourismPlacesModel> tourismPlacesList =[];
  void getAllTourismPlaces()async{
    emit(LoadingGetTourismPlacesState());
    tourismPlacesList=[];
    try{
      http.Response response = await http.get(Uri.parse('$baseUrl/api/TourismPlaces'),
          headers:header );
      dynamic data = jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        for(int i=0; i < data.length; i++){
          tourismPlacesList.add(TourismPlacesModel.jsonData(data[i]));
        }
        emit(SuccessGetTourismPlacesState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorGetTourismPlacesState());
    }
  }

  void getCategoryTourismPlaces({required String id})async{
    emit(LoadingGetTourismPlacesState());
    tourismPlacesList=[];
    try{
      http.Response response = await http.get(Uri.parse('$baseUrl/api/TourismPlaces/GetPostsByPlaceType/$id'),
          headers:header);
      dynamic data = jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        for(int i=0; i < data.length; i++){
          tourismPlacesList.add(TourismPlacesModel.jsonData(data[i]));
        }
        emit(SuccessGetTourismPlacesState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorGetTourismPlacesState());
    }
  }


  List<Model> placeType =[];
  void getPlaceType()async{
    emit(LoadingPlaceTypeState());
    placeType=[];
    try{
      http.Response response = await http.get(Uri.parse('$baseUrl/api/PlaceTypes'),
          headers:header );
      dynamic data = jsonDecode(response.body);
      if(response.statusCode==200){
        for(int i=0; i < data.length; i++){
          placeType.add(Model.jsonData(data[i]));
        }
        emit(SuccessPlaceTypeState());
      }else{
        emit(ErrorPlaceTypeState());
      }
    }catch(e){
      emit(ErrorPlaceTypeState());
    }
  }

  List<Model> stateList =[];
  void getState()async{
    emit(LoadingStateState());
    stateList=[];
    try{
      http.Response response = await http.get(Uri.parse('$baseUrl/api/State'),
          headers:header );
      dynamic data = jsonDecode(response.body);
      if(response.statusCode==200){
        for(int i=0; i < data.length; i++){
          stateList.add(Model.jsonData(data[i]));
        }
        emit(SuccessStateState());
      }
    }catch(e){
      emit(ErrorStateState());
    }
  }

  List<Model> regionsList =[];
  void getRegions()async{
    emit(LoadingRegionState());
    regionsList=[];
    try{
      http.Response response = await http.get(Uri.parse('$baseUrl/api/Regions'),
          headers:header );
      dynamic data = jsonDecode(response.body);
      if(response.statusCode==200){
        for(int i=0; i < data.length; i++){
          regionsList.add(Model.jsonData(data[i]));
        }
        emit(SuccessRegionState());
      }
    }catch(e){
      emit(ErrorRegionState());
    }
  }

  File ? fileImage;

  void changeFileImage(File file){
    fileImage= file;
    emit(AppInitialState());
  }

  void clearFileImage(){
    fileImage=null;
    emit(AppInitialState());
  }

  ProfileModel? profileModel;
  void getProfile()async{
    emit(LoadingGetProfileState());
    profileModel=null;
    String userId =SharedPref.getDate(key: 'kUserId');
    try{
      http.Response response = await http.get(Uri.parse('$baseUrl/api/Users/GetByID/$userId'),
          headers:header );
      dynamic data = jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        profileModel =ProfileModel.jsonData(data);
        emit(SuccessGetProfileState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorGetProfileState());
    }
  }

  void uploadTourismPlaces({required String description,required String phoneNumber  ,required String placeName , required String placeTypeId , required String stateId , required String regionId , required String location})async{

    try{
      emit(LoadingUploadTourismPlacesState());
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/TourismPlaces'),);
      request.headers.addAll(header);

      if(fileImage!=null){
        request.files.add(http.MultipartFile('image',
            File(fileImage!.path).readAsBytes().asStream(), File(fileImage!.path).lengthSync(),
            filename: fileImage!.path.split("/").last));
      }


      request.fields['placeName'] = placeName;
      request.fields['description'] = description;
      request.fields['location'] = location;
      request.fields['regionId'] = '${int.parse(regionId)}';
      request.fields['stateId'] = '${int.parse(stateId)}';
      request.fields['placeTypeId'] = '${int.parse(placeTypeId)}';
      request.fields['userId'] = '${int.parse(SharedPref.getDate(key:'kUserId'))}';
      request.fields['phoneNumber'] = phoneNumber;

      var res = await request.send();
      var response = await http.Response.fromStream(res);
      if(response.body.isNotEmpty){
        var resData = json.decode(response.body);
        debugPrint(resData.toString());
      }


      debugPrint(request.fields.toString());
      debugPrint(response.body);


        emit(SuccessUploadTourismPlacesState());
        debugPrint('Success Upload');
    }catch(e){
      debugPrint('Error Upload ${e.toString()}');
      emit(ErrorUploadTourismPlacesState());
    }
  }


  List <ChatModel> listChat= [];

  void clearChat(){
    listChat=[];
    emit(AnyAppState());
  }

  void addChat(String msg){
    listChat.add(ChatModel(
        isOwner: true,
        msg: msg
    ));
    emit(AnyAppState());
  }

  void chatBot({required String msg ,})async{
    emit(LoadingChatState());
    print(msg);
    try{
      http.Response response = await http.post(Uri.parse('$baseUrl/api/ChatBot'),
          body: json.encode({
            'promptStr': msg,
          }),headers:header );
      String data = jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        listChat.add(ChatModel(
            isOwner: false,
            msg: data
        ));
        emit(SuccessChatState());
      }
    }catch(e){
      print(e.toString());
      emit(ErrorChatState());
    }
  }

  File? mainFileOfferDetails;
  String? base64Main;
  String? expMainImage;

  void addMainDetails(String imagePath){
    mainFileOfferDetails=File(imagePath);
    base64Main=base64Encode(mainFileOfferDetails!.readAsBytesSync());
    expMainImage=mainFileOfferDetails!.path.split('/').last.split('.').last;
    emit(ImageBaseState());
    print(base64Main);

  }

  ImageModel ? imageModel;
  void imageAi()async{
    emit(LoadingImageAiState());
    imageModel = null;
    try{
      http.Response response = await http.post(Uri.parse('https://vision.astica.ai/describe'),
          body: json.encode({
            "tkn": "4055D18C-A340-4E39-8141-7A073E727E0C278737D4F8A3F1-6767-43F2-95C9-BFD046AEEECB",
            "modelVersion": "2.5_full",
            "input": base64Main,
            "visionParams": "gpt, describe, describe_all, tags, objects",
            "objects_custom_kw": "",
            "gpt_prompt": "",
            "gpt_length": "90"
          }),headers:{
            'Accept':'application/json',
            'Content-Type':'application/json',
          } );
      print(jsonDecode(response.body));
      dynamic data = jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        if((data['status']??'') == 'success'){
          imageModel = ImageModel.jsonData(data);
          emit(SuccessImageAiState());
        }else{
          emit(ErrorImageAiState());
        }
      }
    }catch(e){
      print(e.toString());
      emit(ErrorImageAiState());
    }
  }











}

