import 'package:flutter/material.dart';

class RankingsPage extends StatefulWidget {
  const RankingsPage({super.key});

  @override
  State<RankingsPage> createState() => _RankingsPageState();
}

class _RankingsPageState extends State<RankingsPage> {
  bool isNacional = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF081B2E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Rankings",
                    style: TextStyle(color: Colors.white, fontSize: 24)),
              ),

              const SizedBox(height: 20),

              _podio(),

              const SizedBox(height: 20),

              _tabs(),

              const SizedBox(height: 20),

              isNacional 
                ? _listaRanking() 
                : _listaEquipos(),
            ],
          ),
        ),
      ),
    );
  }

  // 🏆 PODIO
  Widget _podio() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("🏆 Podio Nacional",
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _podioItem("2°", "Grace", "7,250 pts", Colors.grey),
              _podioItem("1°", "Dayana", "8,850 pts", Colors.yellow),
              _podioItem("3°", "Sandro", "6,420 pts", Colors.orange),
            ],
          )
        ],
      ),
    );
  }

  Widget _podioItem(String pos, String name, String pts, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: pos == "1°" ? 35 : 28,
          backgroundColor: color,
          child: Text(
            name.substring(0, 2).toUpperCase(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(pos, style: const TextStyle(color: Colors.white)),
              Text(pts, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        )
      ],
    );
  }

  // 🔘 TABS
Widget _tabs() {
  return Container(
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: const Color(0xFF0F2A44),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isNacional = true;
              });
            },
            child: _tab("Nacional", isNacional),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isNacional = false;
              });
            },
            child: _tab("Equipos", !isNacional),
          ),
        ),
      ],
    ),
  );
}

 Widget _tab(String text, bool active) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: active ? Colors.blue.withOpacity(0.3) : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.greenAccent : Colors.white54,
        ),
      ),
    ),
  );
}

  // 📋 LISTA
  Widget _listaRanking(){
    return Column( 
      children: [
        _item("1", "Dayana Agama", "98 ventas • 8,850 pts", true),
        _item("2", "Grace Pilataxi", "87 ventas • 7,250 pts", false),
        _item("3", "Sandro Jaramillo", "76 ventas • 6,420 pts", true, isUser: true),
        _item("4", "Alisson Arias", "72 ventas • 6,100 pts", false),
      ],
    );
  }

  Widget _listaEquipos() {
  return Column(
    children: [
      _itemEquipo("1", "Happy Carapungo 2", "12 vendedores • 48,600 pts", true),
      _itemEquipo("2", "Happy Ventas Digitales Quito", "10 vendedores • 45,300 pts", true, isUser: true),
      _itemEquipo("3", "Happy Chillogallo", "11 vendedores • 42,100 pts", false),
      _itemEquipo("4", "Happy Fun Deporte", "9 vendedores • 39,800 pts", false),
    ],
  );
}

Widget _itemEquipo(String pos, String name, String desc, bool up,
    {bool isUser = false}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: isUser
          ? Colors.blue.withOpacity(0.2)
          : const Color(0xFF0F2A44),
      borderRadius: BorderRadius.circular(14),
      border: isUser
          ? Border.all(color: Colors.blueAccent)
          : null,
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.orange,
          child: Text(pos),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(name,
                      style: const TextStyle(color: Colors.white)),
                  if (isUser)
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Tu tienda",
                          style: TextStyle(fontSize: 10)),
                    )
                ],
              ),
              Text(desc,
                  style: const TextStyle(color: Colors.white54)),
            ],
          ),
        ),
        Icon(
          up ? Icons.trending_up : Icons.trending_down,
          color: up ? Colors.greenAccent : Colors.redAccent,
        )
      ],
    ),
  );
}

  Widget _item(String pos, String name, String desc, bool up,
      {bool isUser = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUser
            ? Colors.blue.withOpacity(0.2)
            : const Color(0xFF0F2A44),
        borderRadius: BorderRadius.circular(14),
        border: isUser
            ? Border.all(color: Colors.blueAccent)
            : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange,
            child: Text(pos),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name,
                        style: const TextStyle(color: Colors.white)),
                    if (isUser)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text("Tú",
                            style: TextStyle(fontSize: 10)),
                      )
                  ],
                ),
                Text(desc,
                    style: const TextStyle(color: Colors.white54)),
              ],
            ),
          ),
          Icon(
            up ? Icons.trending_up : Icons.trending_down,
            color: up ? Colors.greenAccent : Colors.redAccent,
          )
        ],
      ),
    );
  }
}