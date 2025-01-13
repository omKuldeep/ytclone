// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favouriteModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavouriteModelAdapter extends TypeAdapter<FavouriteModel> {
  @override
  final int typeId = 1;

  @override
  FavouriteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavouriteModel(
      title: fields[0] as String?,
      url: fields[1] as String?,
      channel: fields[2] as String?,
      thumb: fields[3] as String?,
      id: fields[4] as String?,
      duration: fields[5] as String?,
      desc: fields[6] as String?,
      chanelUrl: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FavouriteModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.channel)
      ..writeByte(3)
      ..write(obj.thumb)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.duration)
      ..writeByte(6)
      ..write(obj.desc)
      ..writeByte(7)
      ..write(obj.chanelUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavouriteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
