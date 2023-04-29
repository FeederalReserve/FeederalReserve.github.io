class Device {
  String name = 'Device';
  late String mac = "UNKNOWN";
  late Schedule? schedule = new Schedule('None');
  late int schedule_id = -1;
  late int mac_addr = -1;
  late int skipped = -1;
  late int enabled = 1;
  late String img_addr =
      "https://www.aqueon.com/-/media/project/oneweb/aqueon/us/blog/origin-of-betta-fish-and-facts/betta-fins-large_turning-teal2.jpg?h=400&iar=0&w=400&hash=9821F8D058B0F7A5411A721EB20E043B";
  late double last_ph = -1.0;
  late double last_temperature = -1.0;
  late double cur_ph = -1.0;
  late double cur_temp = -1.0;
  late List<dynamic> cur_time = List.empty(growable: true);
  late String code = "UNKNOWN";

  Device(String id_val, Schedule schedule) {
    this.mac = id_val;
    name = 'Device';
    this.schedule = schedule;
    cur_ph = 7.0;
    cur_temp = 72.0;
    mac_addr = 0;
    img_addr = "";
    skipped = 0;
    enabled = 1;
  }

  Device.import(this.mac, this.schedule_id, this.name, this.cur_ph,
      this.cur_temp, this.enabled, this.skipped, this.cur_time, this.code) {}

  get temp => null;

  set_schedule(Schedule schedule) {
    this.schedule = schedule;
  }

  static Map<String, dynamic> toJson(Device device) => {
        'mac': device.mac,
        'name': device.name,
        'schedule_id': device.schedule_id,
        'ph': device.cur_ph,
        'temp': device.cur_temp,
        'skip': device.skipped,
        'enable': device.enabled,
        'code': device.code,
        'time': device.cur_time,
      };

  factory Device.fromJson(Map<String, dynamic> json) {
    // print(json['ph'].toString());
    // print(json['ph'].runtimeType.toString());

    String temp_mac; // = json['mac'];
    int temp_schedule_id; // = json['schedule_id'];
    String temp_name; // = json['name'];
    double temp_ph; // = json['ph'];
    double temp_temp; // = json['temp'];
    int temp_skip; // = json['skip'];
    int temp_enable; // = json['enabled'];
    String temp_code;
    List<dynamic> temp_time;

    // print("temp_mac NOT in else");
    // print(json['mac'].runtimeType.toString());

    if (json['mac'].runtimeType == Null) {
      temp_mac = "N/A";
      //print('MAC IS NULL AND RESET TO: ');
      //print(temp_mac);
    } else {
      temp_mac = json['mac'];
      // print("temp_mac");
      // print(temp_mac.runtimeType.toString());
    }

    if (json['name'].runtimeType == Null) {
      temp_name = "Unnamed";
    } else {
      temp_name = json['name'];
      // print("temp_name");
      // print(temp_name.runtimeType.toString());
    }

    if (json['schedule_id'].runtimeType == Null) {
      temp_schedule_id = -1;
    } else {
      temp_schedule_id = json['schedule_id'];
      // print("temp_schedule_id");
      // print(temp_schedule_id.runtimeType.toString());
    }

    if (json['ph'].runtimeType == Null) {
      temp_ph = -1.0;
    } else {
      temp_ph = json['ph'];
      // print("temp_ph");
      // print(temp_ph.runtimeType.toString());
    }

    if (json['temp'].runtimeType == Null) {
      temp_temp = -1.0;
    } else {
      temp_temp = json['temp'];
    }

    if (json['skip'].runtimeType == Null) {
      temp_skip = 0;
    } else {
      temp_skip = json['skip'];
      // print("temp_skip");
      // print(temp_skip.runtimeType.toString());
    }

    if (json['enabled'].runtimeType == Null) {
      //temp_enable == null
      temp_enable = 1;
    } else {
      temp_enable = json['enabled'];
      // print("temp_enable");
      // print(temp_enable.runtimeType.toString());
    }

    if (json['code'].runtimeType == Null) {
      //temp_enable == null
      temp_code = "ERROR";
    } else {
      temp_code = json['code'];
      // print("temp_code");
      // print(temp_code.runtimeType.toString());
    }

    if (json['time'].runtimeType == Null) {
      //temp_enable == null
      temp_time = [
        1776,
        7,
        4,
        12,
        00,
        0,
        0,
        0,
      ];
      print("temp_time in NULL");
      print(temp_time.runtimeType.toString());
    } else {
      temp_time = json['time'];
    }

    //print('Testing testing :)');

    return Device.import(temp_mac, temp_schedule_id, temp_name, temp_ph,
        temp_temp, temp_skip, temp_enable, temp_time, temp_code);
  }
}

class Schedule {
  late List<Device> devices = List.empty(growable: true);
  late int id = -1;
  List<bool> days = List.filled(7, false);
  late int days_binary = -1;
  List<String> string_days = List.empty(growable: true);
  late String name = "UNKNOWN";
  late String time = "UNKNOWN";
  late String last = "N/A";
  late String next = "N/A";

  Schedule(this.name) {
    devices = List.empty(growable: true);
  }

  Schedule.import(
      this.id, this.days, this.name, this.time, this.last, this.next);

  add_device(Device device) {
    devices.add(device);
    //make http request
  }

  remove_device(Device device) {
    devices.remove(device);
  }

  delete_schedule() {
    //TODO add http request to remove this schedule
  }

  update_date(int day) {
    days[day] = !days[day];
  }

  update_week(List<bool> days) {
    string_days.clear();
    if (days[0]) {
      string_days.add('M');
    }
    if (days[1]) {
      string_days.add('Tu');
    }
    if (days[2]) {
      string_days.add('W');
    }
    if (days[3]) {
      string_days.add('Th');
    }
    if (days[4]) {
      string_days.add('F');
    }
    if (days[5]) {
      string_days.add('Sa');
    }
    if (days[6]) {
      string_days.add('Su');
    }
  }

  static Map<String, dynamic> toJson(Schedule schedule) => {
        'id': schedule.id,
        'name': schedule.name,
        'days': schedule
            .days, //TODO days needs to be reprocessed into a List<bool> --> binary --> decimal representation of the week
        'time': schedule.time,
        'last': schedule.last,
        'next': schedule.next,
      };

  factory Schedule.fromJson(Map<String, dynamic> json) {
    int temp_id;
    int temp_days;
    String temp_days_string;
    List<bool> temp_days_bool = List<bool>.empty(growable: true);
    String temp_name;
    String temp_time;
    String temp_last;
    String temp_next;

    if (json['id'].runtimeType == Null) {
      temp_id = -1;
    } else {
      temp_id = json['id'];
    }

    if (json['days'].runtimeType == Null) {
      temp_days = 0;
    } else {
      temp_days = json['days'];
      String temp_days_string;
      temp_days_string = temp_days.toRadixString(2);
      print(temp_days_string);
      if (temp_days_string.length < 7) {
        int num_days = 7 - temp_days_string.length;
        for (int i = 0; i < num_days; i++) {
          temp_days_string = '0' + temp_days_string;
        }
      }
      print(temp_days_string);
      for (int i = 0; i < 7; i++) {
        if (temp_days_string[i] == '1') {
          temp_days_bool.add(true);
        } else {
          temp_days_bool.add(false);
        }
      }
    }

    if (json['name'].runtimeType == Null) {
      temp_name = "Schedule Unnamed";
    } else {
      temp_name = json['name'];
    }

    if (json['time'].runtimeType == Null) {
      temp_time = "--:--";
    } else {
      temp_time = json['time'];
      //print("temp_time");
      //print(temp_time.runtimeType.toString());
    }

    if (json['last'].runtimeType == Null) {
      temp_last = "--";
    } else {
      temp_last = json['last'];
      //print("temp_last");
      //print(temp_last.runtimeType.toString());
    }

    if (json['next'].runtimeType == Null) {
      temp_next = "--";
    } else {
      temp_next = json['next'];
      //print("temp_next");
      //print(temp_next.runtimeType.toString());
    }

    //print('Testing testing :D');

    return Schedule.import(
        temp_id, temp_days_bool, temp_name, temp_time, temp_last, temp_next);
  }
}
