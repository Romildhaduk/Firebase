import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/model_class.dart';
import 'database_helper.dart';

String? lastId;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _insertFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _updateFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController roleController = TextEditingController();


  TextEditingController nameUpdateController = TextEditingController();
  TextEditingController ageUpdateController = TextEditingController();
  TextEditingController cityUpdateController = TextEditingController();
  TextEditingController roleUpdateController = TextEditingController();

  String? name;
  int? age;
  String? city;
  String? role;


  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            icon: const Icon(Icons.power_settings_new),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('employees').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("ERROR=> ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

            int max = int.parse(docs[0].id);

            for (int i = 0; i < docs.length; i++) {
              if (max < int.parse(docs[i].id)) {
                max = int.parse(docs[i].id);
              }
            }

            lastId = (docs.isNotEmpty) ? "$max" : "0";

            return ListView.builder(
              itemBuilder: (context, i) {
                Map<String, dynamic> empData =
                docs[i].data() as Map<String, dynamic>;

                return Card(
                  elevation: 3,
                  child: ListTile(
                    isThreeLine: true,
                    leading: Text(docs[i].id),
                    title: Text("${empData['name']}"),
                    subtitle: Text("${empData['city']}\n${empData['age']}\n${empData['role']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            nameUpdateController.text = empData['name'];
                            ageUpdateController.text =
                                empData['age'].toString();
                            cityUpdateController.text = empData['city'];

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Center(
                                  child: Text("Update Data"),
                                ),
                                content: Form(
                                  key: _updateFormKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "Enter your name first.";
                                          }
                                          return null;
                                        },
                                        onSaved: (val) {
                                          setState(() {
                                            name = val;
                                          });
                                        },
                                        controller: nameUpdateController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("Name"),
                                          hintText: "Enter your name",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "Enter your age first.";
                                          }
                                          return null;
                                        },
                                        onSaved: (val) {
                                          setState(() {
                                            age = int.parse(val!);
                                          });
                                        },
                                        controller: ageUpdateController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("Age"),
                                          hintText: "Enter your age",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "Enter your city first.";
                                          }
                                          return null;
                                        },
                                        onSaved: (val) {
                                          setState(() {
                                            city = val;
                                          });
                                        },
                                        controller: cityUpdateController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("City"),
                                          hintText: "Enter your city",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "Enter your city first.";
                                          }
                                          return null;
                                        },
                                        onSaved: (val) {
                                          setState(() {
                                            role = val;
                                          });
                                        },
                                        controller: roleUpdateController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("City"),
                                          hintText: "Enter your city",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    child: const Text("Update"),
                                    onPressed: () {
                                      if (_updateFormKey.currentState!
                                          .validate()) {
                                        _updateFormKey.currentState!.save();

                                        Employee e = Employee(
                                            name: name, age: age, city: city, role: role);

                                        lastId = "${int.parse(lastId!) + 1}";

                                        FirestoreHelper.firestoreHelper
                                            .updateData(
                                            data: e, id: docs[i].id);

                                        nameController.clear();
                                        ageController.clear();
                                        cityController.clear();
                                        roleController.clear();

                                        setState(() {
                                          name = "";
                                          age = 0;
                                          city = "";
                                          role = "";
                                        });

                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                  OutlinedButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      nameController.clear();
                                      ageController.clear();
                                      cityController.clear();
                                      roleController.clear();

                                      setState(() {
                                        name = "";
                                        age = 0;
                                        city = "";
                                        role = "";
                                      });

                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                      "Are you sure want to delete this record"),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        await FirestoreHelper.firestoreHelper
                                            .deleteData(id: docs[i].id);

                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Delete"),
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: docs.length,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Center(
                child: Text("Insert Data"),
              ),
              content: Form(
                key: _insertFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter your name first.";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Name"),
                        hintText: "Enter your name",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter your age first.";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          age = int.parse(val!);
                        });
                      },
                      controller: ageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Age"),
                        hintText: "Enter your age",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter your city first.";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          city = val;
                        });
                      },
                      controller: cityController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("City"),
                        hintText: "Enter your city",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Enter your role first.";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          role = val;
                        });
                      },
                      controller: roleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("role"),
                        hintText: "Enter your role",
                      ),
                    ),

                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  child: const Text("Insert"),
                  onPressed: () {
                    if (_insertFormKey.currentState!.validate()) {
                      _insertFormKey.currentState!.save();

                      Employee e = Employee(name: name, age: age, city: city, role: role);

                      lastId = "${int.parse(lastId!) + 1}";

                      FirestoreHelper.firestoreHelper
                          .insertData(data: e, i: lastId);

                      nameController.clear();
                      ageController.clear();
                      cityController.clear();
                      roleController.clear();

                      setState(() {
                        name = "";
                        age = 0;
                        city = "";
                        role = "";
                      });

                      Navigator.of(context).pop();
                    }
                  },
                ),
                OutlinedButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    nameController.clear();
                    ageController.clear();
                    cityController.clear();
                    roleController.clear();

                    setState(() {
                      name = "";
                      age = 0;
                      city = "";
                      role = "";
                    });

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ), // showDialog(
    );
  }
}