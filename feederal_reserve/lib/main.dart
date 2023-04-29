import 'dart:html';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'classes.dart';
import 'package:day_picker/day_picker.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
//import 'package:custom_navigator/custom_scaffold.dart';
import 'package:image_picker/image_picker.dart';

String url = 'http://217.180.230.169:8492';
String authorization_token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwdWJsaWNfaWQiOiJmYTgyZjgxZi1kNGNkLTRkM2QtYmE0Yi0xNGVkYzNhODZhZDciLCJleHAiOjE2ODM2ODM5NDJ9.R_IBrgO3RG7HP2UVZr2JopInbRoQd4gooL1ISEgSwsU';

List<Device> global_devices = List.empty(growable: true);
List<Schedule> global_schedules = List.empty(growable: true);
bool finished_fetching_schedules = false;
bool finished_fetching_devices = false;

Schedule? get_Schedule(int schedule_id) {
  if (!global_schedules.isEmpty) {
    for (int i = 0; i < global_schedules.length; i++) {
      if (global_schedules[i].id == schedule_id) {
        return global_schedules[i];
      }
    }
  }
  print('schedule not found');
  return null;
}

// Future<Schedule> fetchSchedule(int schedule_id) async {
//   final response = await http.get(Uri.parse('$url/schedule/$schedule_id'),
//       headers: {'x-access-token': authorization_token});

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     print("Schedule Status code == 200");
//     return Schedule.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     print("Failed to fetch schedule");
//     throw Exception('Failed to fetch a schedule.');
//   }
// }

// Future<Device> fetchDevice(int device_id) async {
//   //
//   final response = await http.get(Uri.parse('$url/device/$device_id'),
//       headers: {'x-access-token': authorization_token});

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     print("Device Status code == 200");
//     return Device.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     print("Failed to fetch Device");
//     throw Exception('Failed to fetch a device.');
//   }
// }

Future<Device> createSchedule(Schedule schedule) async {
  //int temp_id = device.
  final response = await http.post(
    Uri.parse('$url/schedule/new'),
    headers: {
      'x-access-token': authorization_token,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': schedule.name,
      'days': schedule.string_days.toString(),
      'time': schedule.time,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print('Successfully created schedule!!!');
    return Device.fromJson(jsonDecode(response.body));
  } else {
    print(response.statusCode.toString());
    print(response.body);
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to set Schedule.');
  }
}

Future<Device> setSchedule(Device device, Schedule schedule) async {
  //int temp_id = device.
  print('in set schedule');
  String temp_mac = device.mac;
  print(temp_mac);
  String temp_sched_id = schedule.id.toString();
  print(temp_sched_id);
  final response = await http
      .post(Uri.parse('$url/device/$temp_mac/set/$temp_sched_id'), headers: {
    'x-access-token': authorization_token,
    'Content-Type': 'application/json; charset=UTF-8',
  });

  if (response.statusCode == 200) {
    // If the server did return a 200 CREATED response,
    // then parse the JSON.
    return Device.fromJson(jsonDecode(response.body));
  } else {
    print(response.body);
    // If the server did not return a 200 CREATED response,
    // then throw an exception.
    throw Exception('Failed to set Schedule.');
  }
}

Future<Device> enableDevice(Device device) async {
  String temp_mac = device.mac;
  final response = await http.post(
    Uri.parse('$url/device/$temp_mac/enable'),
    headers: {
      'x-access-token': authorization_token,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    // body: jsonEncode(<String, String>{
    //   'device_mac': device.mac, //TODO fix this lol
    // }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Device.fromJson(jsonDecode(response.body));
  } else {
    print(response.body);
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to enable device.');
  }
}

Future<Device> disableDevice(Device device) async {
  String temp_mac = device.mac;

  final response = await http.post(
    Uri.parse('$url/device/$temp_mac/disable'),
    headers: {
      'x-access-token': authorization_token,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    // body: jsonEncode(<String, String>{
    //   'device_mac': device.mac, //TODO fix this lol
    // }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Device.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.body);
    throw Exception('Failed to enable device.');
  }
}

Future<Device> skipDevice(Device device) async {
  String temp_mac = device.mac;

  final response = await http.post(
    Uri.parse('$url/device/$temp_mac/skip'),
    headers: {
      'x-access-token': authorization_token,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    // body: jsonEncode(<String, String>{
    //   'device_mac': device.mac, //TODO fix this lol
    // }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Device.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.body);
    throw Exception('Failed to enable device.');
  }
}

Future<Device> unskipDevice(Device device) async {
  String temp_mac = device.mac;

  final response = await http.post(
    Uri.parse('$url/device/$temp_mac/unskip'),
    headers: {
      'x-access-token': authorization_token,
      'Content-Type': 'application/json; charset=UTF-8',
    },
    // body: jsonEncode(<String, String>{
    //   'device_mac': device.mac, //TODO fix this lol
    // }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Device.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.body);
    throw Exception('Failed to enable device.');
  }
}

Future<List<Device>> fetchAllDevices() async {
  //
  final response = await http.get(Uri.parse('$url/device/all'),
      headers: {'x-access-token': authorization_token});

  if (response.statusCode == 200) {
    print("Devices Status code == 200");
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final json = "[" + response.body + "]";
    List<Device> deviceListTest = List<Device>.empty();
    print(response.body);

    List<Device> list = (jsonDecode(response.body) as List)
        .map((i) => Device.fromJson(i))
        .toList();

    print(list.toString());
    List<Device> deviceList = List<Device>.empty(growable: true);
    int i = 0;
    for (final item in list) {
      deviceList.add(item);
      print(deviceList[i].name);
      print(deviceList[i].schedule_id);
      if (global_schedules.length > 0) {
        for (int j = 0; j < global_schedules.length; j++) {
          if (global_schedules[j].id == deviceList[i].schedule_id)
            deviceList[i].schedule = global_schedules[j];
        }
      }

      i++;
      //deviceList[item].schedule = get_Schedule(deviceList[item].schedule_id)!;
    }
    global_devices = deviceList;
    String temp = global_devices.elementAt(0).mac.toString();
    print("Device: $temp \n");
    return deviceList; //USED TO BE deviceList but everything returned as the default val sooooo
  } else {
    String test = response.statusCode.toString();
    print("Failed to fetch Devices $test");
    print(response.body);
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to fetch devices.');
  }
}

//TODO fix bc it won't be passing
Future<List<Schedule>> fetchAllSchedules() async {
  final response = await http.get(Uri.parse('$url/schedule/all'),
      headers: {'x-access-token': authorization_token});

  if (response.statusCode == 200) {
    print("Schedules Status code == 200");
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    List returnedList = (jsonDecode(response.body) as List)
        .map((i) => Schedule.fromJson(i))
        .toList();

    List<Schedule> scheduleList = [];
    print(returnedList.toString());
    int i = 0;
    if (returnedList.toString() != "[]") {
      for (final item in returnedList) {
        scheduleList.add(item);
        print(scheduleList[i].name);
        i++;
      }
      global_schedules = scheduleList;
      String temp = global_schedules.elementAt(0).name;
      print("Schedule: $temp");
    }
    return scheduleList;
  } else {
    String test = response.statusCode.toString();
    print("Failed to fetch Schedules $test");

    List<Schedule> scheduleList = [];
    Schedule temp_schedule = new Schedule('None');
    scheduleList.add(temp_schedule);
    global_schedules = scheduleList;

    // If the server did not return a 200 OK response,
    // then throw an exception.
    print(response.body);
    throw Exception('Failed to fetch schedules.');
  }
}

Future<Schedule> deleteSchedule(Schedule schedule) async {
  String temp_id = schedule.id.toString();
  final response = await http.post(
    Uri.parse('$url/schedule/$temp_id'),
    headers: {'x-access-token': authorization_token},
    // headers: <String, String>{
    //   'Content-Type': 'application/json; charset=UTF-8',
    // },
    // body: jsonEncode(<String, int>{
    //   'device_mac': schedule.id, //TODO fix this lol
    // }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Schedule.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.body);
    throw Exception('Failed to enable device.');
  }
}

Future<Schedule> createUser(String name, List<String> days, String time) async {
  //String temp_id = schedule.id.toString();
  final response = await http.post(
    Uri.parse('$url/schedule/new'),
    headers: {'x-access-token': authorization_token},
    // headers: <String, String>{
    //   'Content-Type': 'application/json; charset=UTF-8',
    // },
    body: jsonEncode(<String, String>{
      'name': name, //TODO fix this lol
      'days': days.toString(),
      'time': time,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Schedule.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    print(response.body);
    throw Exception('Failed to enable device.');
  }
}

int getScheduleIdFromName(String name) {
  if (global_schedules.length > 0) {
    for (int i = 0; i < global_schedules.length; i++) {
      if (global_schedules[i].name == name) {
        return global_schedules[i].id;
      }
    }
  }
  return -1;
}

Schedule? getScheduleFromId(int id) {
  if (global_schedules.length > 0) {
    for (int i = 0; i < global_schedules.length; i++) {
      if (global_schedules[i].id == id) {
        return global_schedules[i];
      }
    }
  }
  return null;
}

void main() {
  runApp(const MyApp());
}

enum THEME { PURPLE, CARDINAL_GOLD }

THEME CUR_THEME = THEME.PURPLE;

choosePrimarySwatch() {
  //Get user's theme from server
  if (CUR_THEME == THEME.PURPLE) {
    return Colors.deepPurple;
  } else if (CUR_THEME == THEME.CARDINAL_GOLD) {
    return Colors.red;
  }
}

chooseBackgroundColor() {
  if (CUR_THEME == THEME.PURPLE) {
    return Color.fromARGB(255, 132, 31, 214);
  } else if (CUR_THEME == THEME.CARDINAL_GOLD) {
    return Color.fromARGB(255, 160, 35, 35);
  }
}

chooseAccentColor() {
  if (CUR_THEME == THEME.PURPLE) {
    return Color.fromARGB(255, 171, 128, 228);
  } else if (CUR_THEME == THEME.CARDINAL_GOLD) {
    return Color.fromARGB(171, 255, 217, 0);
    //Color.fromARGB(171, 255, 217, 0);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //print('Devices and Schedules\n');
    return MaterialApp(
        //Was Material
        title: 'The Feederal Reserve',
        builder: (context, child) => BaseWidget(child: child!),
        theme: ThemeData(
          // This is the theme of your application.r
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: choosePrimarySwatch(), //.Colors.deepPurple,
          appBarTheme: AppBarTheme(
              backgroundColor:
                  chooseBackgroundColor()), //Color.fromARGB(255, 132, 31, 214)),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        //home: MyHomePage(title: 'Dashboard'),
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(title: 'Dashboard'),
          '/schedules': (context) => SchedulePage(title: 'SchedulePage'),
          '/settings': (context) => SettingsPage(title: 'SettingsPage'),
        });
  }
}

//enum TabItem{dashboard, calendar, settings};

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //TabItem currentTab = TabItem.dashboard;
  int _counter = 0;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;
  bool isChecked = false;

  get_device(Device device) {
    List<String> ScheduleNames =
        List.empty(growable: true); //TODO assign Schedules into list
    print("schedule names adding...");
    print(global_schedules.length.toString());
    if (global_schedules.length > 0) {
      for (int i = 0; i < global_schedules.length; i++) {
        //if (!ScheduleNames.contains(device.schedule.name)) {
        //  print(global_schedules[i].name);
        ScheduleNames.add(global_schedules[i].name);
        //}
      }
    }

    print(ScheduleNames.toString());

    String? _dropdownValue = null;
    if (device.schedule!.name == "UNKNOWN") {
      //_dropdownValue = 'None';
    } else {
      _dropdownValue = device.schedule!.name;
    }

    Color getCheckboxColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return choosePrimarySwatch();
      }
      return choosePrimarySwatch().withOpacity(.5);
    }

    getScheduleDropdowns() {
      List<DropdownMenuItem<String?>> deviceDropDown =
          List.empty(growable: true);
      if (global_schedules.length > 0) {
        print("GLOBAL SCHEDULES NON-NULL");
        //var test = DropdownMenuItem(child: Text('None'), value: 'None');
        //deviceDropDown.add(test);
        for (int j = 0; j < global_schedules.length; j++) {
          String val = global_schedules[j].name;
          //int test = global_schedules[j].id;
          var newItem = DropdownMenuItem(child: Text(val), value: '$val');
          //getScheduleDropdown(global_schedules[j]);
          deviceDropDown.add(newItem);
          print(global_schedules[j].name);
        }
      }
      return deviceDropDown;
    }

    String current_temp = device.cur_temp.toString();
    String current_pH = device.cur_ph.toString();
    String device_name = device.name;
    String device_schedule = device.schedule!.name;
    String device_time = device.schedule!.time;
    String device_next_feed = device.schedule!.next;
    String photo_url = device.img_addr;

    String? temp_device_name = null;
    //print('in get device');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 100.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        shape: BoxShape.rectangle,
        color: chooseAccentColor(),
      ),
      //color: Color.fromARGB(255, 191, 128, 228),
      child: //FutureBuilder<Device>( //TODO figure out this FutureBuilder nonsense
          Column(children: <Widget>[
        Image(
          image: NetworkImage(photo_url), //TODO make this a variable
          //width: 200,
          height: 200,
        ), //Maybe put on the left somehow and have the texts be on the right... Could also differ between iOS and Web looks
        Text(
          'Device: $device_name',
          style: Theme.of(context).textTheme.headline4,
          //
        ),
        Text(
          'pH: $current_pH',
        ),
        Text("Temperature: $current_temp"),
        Text(
          'Feeding Time: $device_time',
        ),
        Text(
          'Current Schedule: $device_schedule',
        ),
        // ElevatedButton(
        //   child: Text("Feed now!"),
        //   onPressed: () {},
        // ),
        ElevatedButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => Dialog(
              insetPadding: EdgeInsets.all(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      const Text('Edit Device'),
                      //const SizedBox(height: 15),
                      TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Device name',
                          ),
                          onSaved: (String? value) {
                            if (value != null) {
                              temp_device_name = value;
                            }
                          }),
                      //TimePickerDialog
                      DropdownButtonFormField<String?>(
                        //DropdownButton<String?>
                        value: _dropdownValue,
                        elevation: 16,
                        onChanged: (String? selectedValue) {
                          setState(() {
                            _dropdownValue = selectedValue!;
                          });
                        },
                        items: getScheduleDropdowns(),
                      ),
                      Row(children: <Widget>[
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.resolveWith(
                              getCheckboxColor),
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!; //TODO FIX THIS :)
                            });
                          },
                        ),
                        const Text('Assign schedule for all devices',
                            textAlign: TextAlign.center),
                      ]),
                      Row(
                        children: [
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              //Doesn't need to make any server calls
                            },
                            child: const Text('Cancel'),
                          )),
                          Expanded(
                              child: TextButton(
                            onPressed: () {
                              String tempName;
                              int temp_sched_id;
                              if (temp_device_name != null) {
                                tempName = temp_device_name!;
                                //TODO THIS NEEDS SOME API CALL SO THAT THE CHANGE STICKS
                              }
                              print("Before reassigning device's schedule id");
                              print(device.schedule_id.toString());
                              temp_sched_id =
                                  getScheduleIdFromName(_dropdownValue!);
                              print("After reassigning device's schedule id");
                              print(device.schedule_id.toString());

                              if (getScheduleFromId(temp_sched_id) != null) {
                                device.schedule =
                                    getScheduleFromId(temp_sched_id)!;
                              }
                              setSchedule(device, device.schedule!);
                              Navigator.pop(context);
                              //TODO Make backend/frontend changes
                            },
                            child: const Text('Accept'),
                          )),
                        ],
                      )
                    ]),
                  ))
                ],
              ),
            ),
          ),
          child: const Text('Edit Device'),
        ),
      ]),
    );
  }

  //int num_devices = devices.length;
  get_devices() {
    List<Widget> devices = [];
    if (global_devices.length > 0) {
      for (int i = 0; i < global_devices.length; i++) {
        devices.add(get_device(global_devices[i]));
      }
    }
    return devices;
  }

  Future<List<Schedule>>? All_Schedules;
  Future<List<Device>>? All_Devices;

  initState() {
    //All_Schedules = fetchAllSchedules();
    super.initState();
    All_Schedules = fetchAllSchedules();
    All_Devices = fetchAllDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: All_Devices, //All_Devices
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasError) {
              // print('inside snapshot check conditional');
              // print(snapshot.data![0].cur_ph.toString());
              // print(global_devices[0].cur_ph.toString());
              // global_devices = snapshot.data!;
              // print(global_devices[0].cur_ph.toString());
              return Column(children: <Widget>[
                Expanded(
                  child: ListView(
                      scrollDirection: Axis.vertical, children: get_devices()),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SchedulePage(title: 'SchedulePage');
                    }));
                  },
                  child: const Text('Schedules'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SettingsPage(title: 'SettingsPage');
                    }));
                  },
                  child: const Text('Settings Page'),
                ),
              ]);
            } else if (snapshot.data == ConnectionState.waiting) {
              print("Data not found");
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              print('Error finding data');
              return const Center(
                child: const Text("Error finding data"),
              );
              // } else if (snapshot.connectionState == ConnectionState.done) {
              //   print("snapshot.data is null (probably)");
              //   print(snapshot.data.toString());
              //   //print("\n");
              //   return const Text("NULL");
            } else {
              print("snapshot.data equals ____ for unknown");
              print(snapshot.data.toString());
              //print("\n");
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SchedulePage> createState() => _SchedulePage();
}

class _SchedulePage extends State<SchedulePage> {
  //bool isChecked = true;
  //const _SchedulePage({Key? key, required this.title}) : super(key: key);
  //final String title;
  Future<List<Schedule>>? All_Schedules;
  Future<List<Device>>? All_Devices;

  initState() {
    //All_Schedules = fetchAllSchedules();
    super.initState();
    All_Schedules = fetchAllSchedules();
    All_Devices = fetchAllDevices();
  }

  @override
  Widget build(BuildContext context) {
    Color getCheckboxColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return choosePrimarySwatch();
      }
      return choosePrimarySwatch().withOpacity(.5);
    }

    Color getDayContainerBackgroundColor() {
      if (true) {
        //TODO if selected in week, return deep purple, else return the other color
        return choosePrimarySwatch().withOpacity(.5);
      }
      return chooseAccentColor();
    }

    double getOpacityofDay(int index, int day) {
      //SET Values based on the schedule_id (TODO add call to server)
      //var week = [true, false, false, false, false, false, true];
      var week = global_schedules[index].days;
      if (week[day]) {
        return .6;
      } else {
        return .2;
      }
    }

    TimeOfDay? picked = TimeOfDay.now();

    setScheduleTime(TimeOfDay? time) {
      picked = time;
      //TODO make connection to server and update schedule's feeding time
    }

    getScheduleTime() {
      //make connection to server and get either default time or that schedule's specific stored time
      return picked;
    }

    get_schedule(int index) {
      List<bool> week = List.filled(7, false, growable: false);

      String? temp_device_name = '';
      List<String> temp_values = List.empty(growable: true);

      return Row(
        children: <Widget>[
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
              color: chooseAccentColor().withOpacity(.6),
            ),
            child: TextButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
                  insetPadding: EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(children: [
                          const Text('Edit Schedule'),
                          //const SizedBox(height: 15),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Schedule Name',
                            ),
                            onChanged: (String? value) {
                              temp_device_name = value!;
                            },
                          ),
                          //TimePickerDialog
                          Row(
                              //maybe try to get this a little more spread out, it's looking pretty squnchie rn
                              children: [
                                Text(getScheduleTime()
                                    .toString()), //TODO check that this is pulling actual data for initial time
                                TextButton(
                                  //Consider using a Simple Dialog instead!!! :D
                                  onPressed: () async {
                                    picked = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context).copyWith(
                                              alwaysUse24HourFormat: true),
                                          child: child!,
                                        );
                                      },
                                    );
                                    setScheduleTime(picked);
                                  },
                                  child: const Text('Edit Feeding Time'),
                                ),
                              ]),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SelectWeekDays(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              days: [
                                DayInWeek(
                                  "Sun",
                                  isSelected: global_schedules[index].days[0],
                                ),
                                DayInWeek(
                                  "Mon",
                                  isSelected: global_schedules[index].days[1],
                                ),
                                DayInWeek("Tue",
                                    isSelected:
                                        global_schedules[index].days[2]),
                                DayInWeek(
                                  "Wed",
                                  isSelected: global_schedules[index].days[3],
                                ),
                                DayInWeek(
                                  "Thu",
                                  isSelected: global_schedules[index].days[4],
                                ),
                                DayInWeek(
                                  "Fri",
                                  isSelected: global_schedules[index].days[5],
                                ),
                                DayInWeek(
                                  "Sat",
                                  isSelected: global_schedules[index].days[6],
                                ),
                              ],
                              boxDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  // 10% of the width, so there are ten blinds.
                                  colors: [
                                    chooseBackgroundColor(),
                                    choosePrimarySwatch()
                                  ], // whitish to gray
                                  tileMode: TileMode
                                      .repeated, // repeats the gradient over the canvas
                                ),
                              ),
                              onSelect: (values) {
                                temp_values = values;
                                print(values);
                                print(values.runtimeType.toString());
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              )),
                              Expanded(
                                  child: TextButton(
                                onPressed: () {
                                  // if(temp_device_name != null{
                                  //   global_schedules[index].name = temp_device_name;
                                  // })
                                  // int temp_hour = picked!.hour;
                                  //     print(temp_hour.toString());
                                  //     int temp_minute = picked!.minute;
                                  //     print(temp_minute.toString());
                                  //     String temp_time =
                                  //         "$temp_hour:$temp_minute";
                                  // global_schedules[index].time = temp_time;

                                  Navigator.pop(context);
                                },
                                child: const Text('Accept'),
                              )),
                            ],
                          )
                        ]),
                      ))
                    ],
                  ),
                ),
              ),
              //},
              child: Text(
                global_schedules[index].name,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: const Text('Sunday', textAlign: TextAlign.center),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                color: choosePrimarySwatch()
                    .withOpacity(getOpacityofDay(index, 0)),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: const Text('Monday', textAlign: TextAlign.center),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                color: choosePrimarySwatch()
                    .withOpacity(getOpacityofDay(index, 1)),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: const Text('Tuesday', textAlign: TextAlign.center),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                color: choosePrimarySwatch()
                    .withOpacity(getOpacityofDay(index, 2)),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: const Text('Wednesday', textAlign: TextAlign.center),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                color: choosePrimarySwatch()
                    .withOpacity(getOpacityofDay(index, 3)),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: const Text('Thursday', textAlign: TextAlign.center),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                color: choosePrimarySwatch()
                    .withOpacity(getOpacityofDay(index, 4)),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: const Text('Friday', textAlign: TextAlign.center),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                color: choosePrimarySwatch()
                    .withOpacity(getOpacityofDay(index, 5)),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: const Text('Saturday', textAlign: TextAlign.center),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                color: choosePrimarySwatch()
                    .withOpacity(getOpacityofDay(index, 6)),
              ),
            ),
          ),

          // Container(
          //   child: FittedBox(
          //     child: FlutterLogo(),
          //   ),
          //),
        ],
      );
    }

    get_schedules() {
      List<Widget> schedules = [];
      if (global_schedules.length > 0) {
        for (int i = 0; i < global_schedules.length; i++) {
          schedules.add(get_schedule(i));
        }
      }

      return schedules;
    }

    String? temp_device_name = '';
    List<String> temp_values = List.empty(growable: true);

    return Scaffold(
        // appBar: AppBar(
        //   title: Text(title),
        // ),
        body: FutureBuilder(
            future: All_Schedules, //All_Devices
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasError) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                          scrollDirection: Axis.vertical,
                          children: get_schedules()),
                    ),
                    ElevatedButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          insetPadding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 50.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Create Schedule',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                //
                              ),
                              //const SizedBox(height: 15),
                              TextFormField(
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Enter Schedule Name',
                                ),
                                onChanged: (String? value) {
                                  temp_device_name = value!;
                                },
                              ),
                              //TimePickerDialog
                              Row(children: <Widget>[
                                //maybe try to get this a little more spread out, it's looking pretty squnchie rn

                                Text(picked.toString()),
                                TextButton(
                                  //Consider using a Simple Dialog instead!!! :D
                                  onPressed: () async {
                                    picked = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context).copyWith(
                                              alwaysUse24HourFormat: true),
                                          child: child!,
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('Edit Feeding Time'),
                                ),
                              ]),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SelectWeekDays(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  days: [
                                    DayInWeek(
                                      "Sun",
                                      isSelected: false,
                                    ),
                                    DayInWeek(
                                      "Mon",
                                      isSelected: false,
                                    ),
                                    DayInWeek(
                                      "Tue",
                                      isSelected: false,
                                    ),
                                    DayInWeek(
                                      "Wed",
                                      isSelected: false,
                                    ),
                                    DayInWeek(
                                      "Thu",
                                      isSelected: false,
                                    ),
                                    DayInWeek(
                                      "Fri",
                                      isSelected: false,
                                    ),
                                    DayInWeek(
                                      "Sat",
                                      isSelected: false,
                                    ),
                                  ],
                                  boxDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      // 10% of the width, so there are ten blinds.
                                      colors: [
                                        chooseBackgroundColor(),
                                        choosePrimarySwatch()
                                      ], // whitish to gray
                                      tileMode: TileMode
                                          .repeated, // repeats the gradient over the canvas
                                    ),
                                  ),
                                  onSelect: (values) {
                                    //TODO make THIS DO THINGS
                                    print("before temp_values assignment");
                                    temp_values = values;
                                    print(values);
                                    print(values.runtimeType.toString());
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  )),
                                  Expanded(
                                      child: TextButton(
                                    onPressed: () {
                                      //Make backend/frontend changes
                                      print("Beginning of on pressing Accept");
                                      print(temp_device_name.toString());
                                      Schedule new_schedule =
                                          new Schedule(temp_device_name!);
                                      int temp_hour = picked!.hour;
                                      print(temp_hour.toString());
                                      int temp_minute = picked!.minute;
                                      print(temp_minute.toString());
                                      new_schedule.time =
                                          "$temp_hour:$temp_minute";
                                      print(new_schedule.time.toString());
                                      new_schedule.string_days.clear();
                                      print(
                                          new_schedule.string_days.toString());
                                      new_schedule.string_days = temp_values;
                                      print(
                                          new_schedule.string_days.toString());

                                      createSchedule(new_schedule);
                                      //add new schedule to global_schedules
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Accept'),
                                  )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      child: const Text('Create Schedule'),
                    ),

                    /*
              Both Create and Edit Schedule should appear with the exact same Dialog.
              What could potentially happen is that we can pass a sort of schedule object created to the dialog to automatically populate fields.
              When it's Create Schedule, it will be automatically populated with defaults
              When it's Edit Schedule, it will automatically be populated with the current data
          */
                    Text('Select the name of a schedule to edit the schedule'),
                    TextButton(
                      onPressed: () {
                        //Set current schedule to this one
                        Navigator.pop(context); //place holder
                      },
                      child: const Text('Go Back To Main Page'),
                    ),
                  ],
                );
              } else if (snapshot.data == ConnectionState.waiting) {
                print("Data not found");
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                print('Error finding data');
                return const Center(
                  child: const Text("Error finding data"),
                );
                // } else if (snapshot.connectionState == ConnectionState.done) {
                //   print("snapshot.data is null (probably)");
                //   print(snapshot.data.toString());
                //   //print("\n");
                //   return const Text("NULL");
              } else {
                print("snapshot.data equals ____ for unknown");
                print(snapshot.data.toString());
                //print("\n");
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});
  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  bool isChecked1 = true;
  bool isChecked2 = false;

  Color getCheckboxColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return choosePrimarySwatch();
    }
    return choosePrimarySwatch().withOpacity(.5);
  }

  String dropdownValue = 'Purple'; //TODO make this based be based on cur_theme

  List<String> numberList = ['Purple', 'Cardinal and Gold'];

  List<DropdownMenuItem<String?>> dropDown() {
    List<DropdownMenuItem<String?>> dropDownItems = [];

    for (int i = 0; i < numberList.length; i++) {
      //for every currency in the list we create a new dropdownmenu item
      String val = numberList[i];
      var newItem = DropdownMenuItem(
        value: "$val",
        child: Text(val),
      );
      // add to the list of menu item
      dropDownItems.add(newItem);
    }
    return dropDownItems;
  }

  @override
  Widget build(BuildContext context) {
    if (CUR_THEME == THEME.PURPLE) {
      dropdownValue = 'Purple';
    } else {
      dropdownValue = 'Cardinal and Gold';
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(title),
      // ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Setting 1'),
            value: isChecked1,
            onChanged: (bool? value) {
              setState(() {
                isChecked1 = value!;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Setting 2'),
            value: isChecked2,
            onChanged: (bool? value) {
              setState(() {
                isChecked2 = value!;
              });
            },
          ),
          // Container(
          //   child: SpinBox(
          //     max: 7.0,
          //     value: 0.1,
          //     decimals: 1,
          //     step: 0.05,
          //     decoration: InputDecoration(labelText: 'pH Tolerance'),
          //     onChanged: (value) => print(
          //         value), //TODO have this update the server with the update information, when "Accept" has been clicked
          //   ),
          //   padding: EdgeInsets.all(10.0),
          // ),
          // Container(
          //   child: SpinBox(
          //     max: 7.0,
          //     value: 0.5,
          //     decimals: 1,
          //     step: 0.1,
          //     decoration: InputDecoration(labelText: 'Temperature Tolerance'),
          //     onChanged: (value) => print(
          //         value), //TODO have this update the server with the update information, when "Accept" has been clicked
          //   ),
          //   padding: EdgeInsets.all(10.0),
          // ),
          DropdownButtonFormField<String?>(
            value: dropdownValue,
            elevation: 16,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: dropDown(),
          ),
          Row(children: [
            Expanded(
                child: ElevatedButton(
              onPressed: () {},
              child: const Text('Reset'),
            )),
            Expanded(
                child: ElevatedButton(
              onPressed: () {
                if (dropdownValue == 'Cardinal and Gold') {
                  CUR_THEME = THEME.CARDINAL_GOLD;
                } else if (dropdownValue == 'Purple') {
                  CUR_THEME = THEME.PURPLE;
                }
              },
              child: const Text('Accept'),
            )),
          ]),
          TextButton(
            onPressed: () {
              //Set current schedule to this one
              Navigator.pop(context); //place holder
            },
            child: const Text('Go Back To Main Page'),
          ),
        ],
      ),
    );
  }
}

//Whole Screen
//comprised of NavBar and "child" widget, which is the current page we're navigated to
class BaseWidget extends StatelessWidget {
  final Widget child;
  const BaseWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Feederal Reserve'),
      ),
      body: Row(
        children: [
          //NavigationBarWidget(), //
          Expanded(child: child),
        ],
      ),
    );
  }
}

class NavigationBarWidget extends StatefulWidget {
  @override
  _NavigationBarWidget createState() => _NavigationBarWidget();
}

class _NavigationBarWidget extends State<NavigationBarWidget> {
  //const PersistentWidget({super.key});
  int _counter = 0;
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _selectedIndex,
          backgroundColor: choosePrimarySwatch().withOpacity(.2),
          groupAlignment: groupAlignment,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
              //Navigator.pop(context);
              if (index == 0) {
                Navigator.pushNamed(context, '/');
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             const MyHomePage(title: 'Dashboard')));
              } else if (index == 1) {
                Navigator.pushNamed(context, '/schedules');
                // Navigator.of(context).push(
                //     //context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             const SchedulePage(title: 'Schedule')));
              } else if (index == 2) {
                Navigator.pushNamed(context, '/settings');
              }
            });
          },
          labelType: labelType,
          leading: showLeading
              ? FloatingActionButton(
                  elevation: 0,
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  child: const Icon(Icons.add),
                )
              : const SizedBox(),
          trailing: showTrailing
              ? IconButton(
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  icon: const Icon(Icons.more_horiz_rounded),
                )
              : const SizedBox(),
          destinations: const <NavigationRailDestination>[
            NavigationRailDestination(
              icon: Icon(Icons.home),
              selectedIcon: Icon(Icons.home),
              label: Text('Dashboard'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.calendar_month_rounded),
              selectedIcon: Icon(Icons.calendar_month_rounded),
              label: Text('Schedules'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.settings),
              selectedIcon: Icon(Icons.settings),
              label: Text('Settings'),
            ),
          ],
        ),
      ],
    );
  }
}
