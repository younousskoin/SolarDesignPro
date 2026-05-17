// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectModelAdapter extends TypeAdapter<ProjectModel> {
  @override
  final int typeId = 1;

  @override
  ProjectModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectModel(
      name: fields[0] as String,
      city: fields[1] as String,
      country: fields[2] as String,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
      tilt: fields[5] as double,
      orientation: fields[6] as double,
      autonomyDays: fields[7] as double,
      hourlyConsumption: (fields[8] as List).cast<double>(),
      ghi: (fields[9] as List).cast<double>(),
      dhi: (fields[10] as List).cast<double>(),
      dni: (fields[11] as List).cast<double>(),
      temperature: (fields[12] as List).cast<double>(),
      wind: (fields[37] as List?)?.cast<double>(),
      humidity: (fields[38] as List?)?.cast<double>(),
      windDirection: (fields[39] as List?)?.cast<double>(),
      systemType: fields[13] as String,
      pvSeriesCount: fields[15] as int,
      pvParallelCount: fields[16] as int,
      pvVocString: fields[17] as double,
      pvVmpString: fields[18] as double,
      pvImpString: fields[19] as double,
      pvIscString: fields[20] as double,
      resultPanelCount: fields[21] as int,
      panelRegulatorOK: fields[22] as bool,
      panelInverterOK: fields[23] as bool,
      batteryInverterOK: fields[24] as bool,
      pumpInverterOK: fields[25] as bool,
      socDaily: (fields[26] as List?)?.cast<double>(),
      pvPowerDaily: (fields[27] as List?)?.cast<double>(),
      monthlyProduction: (fields[28] as List?)?.cast<double>(),
      monthlyConsumption: (fields[29] as List?)?.cast<double>(),
      annualProduction: fields[30] as double?,
      annualConsumption: fields[31] as double?,
      energyBalance: fields[32] as double?,
      pvCoverage: fields[33] as double?,
      realAutonomyDays: fields[34] as double?,
      pr: fields[35] as double?,
      totalLossPercent: fields[36] as double?,
      createdAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectModel obj) {
    writer
      ..writeByte(40)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.city)
      ..writeByte(2)
      ..write(obj.country)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.tilt)
      ..writeByte(6)
      ..write(obj.orientation)
      ..writeByte(7)
      ..write(obj.autonomyDays)
      ..writeByte(8)
      ..write(obj.hourlyConsumption)
      ..writeByte(9)
      ..write(obj.ghi)
      ..writeByte(10)
      ..write(obj.dhi)
      ..writeByte(11)
      ..write(obj.dni)
      ..writeByte(12)
      ..write(obj.temperature)
      ..writeByte(37)
      ..write(obj.wind)
      ..writeByte(38)
      ..write(obj.humidity)
      ..writeByte(39)
      ..write(obj.windDirection)
      ..writeByte(13)
      ..write(obj.systemType)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.pvSeriesCount)
      ..writeByte(16)
      ..write(obj.pvParallelCount)
      ..writeByte(17)
      ..write(obj.pvVocString)
      ..writeByte(18)
      ..write(obj.pvVmpString)
      ..writeByte(19)
      ..write(obj.pvImpString)
      ..writeByte(20)
      ..write(obj.pvIscString)
      ..writeByte(21)
      ..write(obj.resultPanelCount)
      ..writeByte(22)
      ..write(obj.panelRegulatorOK)
      ..writeByte(23)
      ..write(obj.panelInverterOK)
      ..writeByte(24)
      ..write(obj.batteryInverterOK)
      ..writeByte(25)
      ..write(obj.pumpInverterOK)
      ..writeByte(26)
      ..write(obj.socDaily)
      ..writeByte(27)
      ..write(obj.pvPowerDaily)
      ..writeByte(28)
      ..write(obj.monthlyProduction)
      ..writeByte(29)
      ..write(obj.monthlyConsumption)
      ..writeByte(30)
      ..write(obj.annualProduction)
      ..writeByte(31)
      ..write(obj.annualConsumption)
      ..writeByte(32)
      ..write(obj.energyBalance)
      ..writeByte(33)
      ..write(obj.pvCoverage)
      ..writeByte(34)
      ..write(obj.realAutonomyDays)
      ..writeByte(35)
      ..write(obj.pr)
      ..writeByte(36)
      ..write(obj.totalLossPercent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
