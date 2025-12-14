// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_classification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryClassificationModelAdapter
    extends TypeAdapter<HistoryClassificationModel> {
  @override
  final int typeId = 0;

  @override
  HistoryClassificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryClassificationModel(
      id: fields[0] as String?,
      imagePath: fields[1] as String?,
      svmPrediction: fields[2] as String,
      svmProbability: (fields[3] as List).cast<double>(),
      knnPrediction: fields[4] as String,
      knnProbability: (fields[5] as List).cast<double>(),
      createdAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryClassificationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.svmPrediction)
      ..writeByte(3)
      ..write(obj.svmProbability)
      ..writeByte(4)
      ..write(obj.knnPrediction)
      ..writeByte(5)
      ..write(obj.knnProbability)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryClassificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
