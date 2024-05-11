
class Model{
  int ? id ;
  String ? regionName;
  String ? name;
  String ? tourismPlaces;

  Model({this.name, this.id, this.regionName,this.tourismPlaces});

  factory Model.jsonData(data){
    return Model(
      id: data['id'],
      name: data['name'],
      regionName: data['regionName'],
      tourismPlaces: data['tourismPlaces'],
    );
  }
}


class TourismPlacesModel{
  int ? id;
  String ? placeName;
  String ? description;
  String ? location;
  String ? image;
  int ? userId;
  String ? userName;
  String ? regionName;
  int ? regionId;
  String ? phoneNumber;
  String ? stateName;
  String ? placeTypeName;

  TourismPlacesModel(
      {this.phoneNumber,
      this.description,
      this.placeName,
      this.location,
      this.regionName,
      this.id,
      this.userId,
      this.image,
      this.userName,
        this.regionId,
      this.placeTypeName,
      this.stateName});

  factory TourismPlacesModel.jsonData(data){
    return TourismPlacesModel(
      location: data['location'],
      placeTypeName: data['placeTypeName'],
      description: data['description'],
      phoneNumber: data['phoneNumber'],
      regionName: data['regionName'],
      id: data['id'],
      userName: data['userName'],
      image: data['image'],
      userId: data['userId'],
      regionId: data['regionId'],
      placeName: data['placeName'],
      stateName: data['stateName'],
    );
  }
}

////////////////////////////////////


class ImageModel{
  String ? status;
  CaptionModel? captionModel;
  List<CaptionListModel> ? captionList;

  ImageModel({this.captionModel, this.status, this.captionList});

  factory ImageModel.jsonData(data){
    var ratesList = data['caption_list']!=null?data['caption_list'] as List:[];
    List<CaptionListModel> rates = ratesList.map((tagJson) => CaptionListModel.jsonData(tagJson)).toList();
    return ImageModel(
      status: data['status'],
      captionList: data['caption_list']!= null ? rates: null,
      captionModel: data['caption'] !=null ? CaptionModel.jsonData(data['caption']) : null
    );
  }


}

class CaptionModel{
  String ? text;
  CaptionModel({this.text});
  factory CaptionModel.jsonData(data){
    return CaptionModel(
        text: data['text']
    );
  }



}

class CaptionListModel{
  String ? text;

  CaptionListModel({this.text});

  factory CaptionListModel.jsonData(data){
    return CaptionListModel(
      text: data['text']
    );
  }

}
