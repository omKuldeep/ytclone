
import 'package:hive/hive.dart';

part "favouriteModel.g.dart";


@HiveType(typeId: 1)
class FavouriteModel extends HiveObject{
  @HiveField(0)
  final String? title;
  @HiveField(1)
  final String? url;
  @HiveField(2)
  final String? channel;
  @HiveField(3)
  final String? thumb;
  @HiveField(4)
  final String? id;
  @HiveField(5)
  final String? duration;
  @HiveField(6)
  final String? desc;
  @HiveField(7)
  final String? chanelUrl;

  FavouriteModel(
      {this.title,
      this.url,
      this.channel,
      this.thumb,
      this.id,
      this.duration,
      this.desc,
      this.chanelUrl});
}