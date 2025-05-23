

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class SenhaRedefinidaScreen extends StatefulWidget {
  const SenhaRedefinidaScreen({super.key});

  @override
  State<SenhaRedefinidaScreen> createState() => _SenhaRedefinidaScreenState();
}

class _SenhaRedefinidaScreenState extends State<SenhaRedefinidaScreen> {
  String _horaAtual = DateFormat('HH:mm').format(DateTime.now());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer){
      if (mounted) {
        setState(() {
          _horaAtual = DateFormat('HH:mm').format(DateTime.now());
        });
      };
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = screenSize.width > 600;
    double logoSize = isTablet ? 230 : 180;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/imagem.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  const Color.fromARGB(51, 0, 0, 0),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(153, 155, 224, 236),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _horaAtual,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Row(
                            children: const [
                              Icon(Icons.wifi, color: Colors.white, size: 18),
                              SizedBox(width: 5),
                              Icon(Icons.signal_cellular_alt, color: Colors.white, size: 18),
                              SizedBox(width: 5),
                              Icon(Icons.battery_full, color: Colors.white, size: 18),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: isLandscape
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 40),
                                    child: Image.asset(
                                      'assets/logo.png',
                                      width: logoSize,
                                    ),
                                  ),
                                  _buildSuccessContainer(),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 40),
                                    child: Image.asset(
                                      'assets/logo.png',
                                      width: logoSize,
                                    ),
                                  ),
                                  _buildSuccessContainer(),
                                ],
                              ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            "V 1.0.2",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(height: 2),
                          SizedBox(width: 50, child: Divider(color: Colors.white, thickness: 1)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContainer() {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(178, 33, 38, 36),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(128),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 80, color: Colors.green),
          const SizedBox(height: 20),
          const Text(
            'Senha redefinida com sucesso!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Voltar ao Login'),
          ),
        ],
      ),
    );
  }
}