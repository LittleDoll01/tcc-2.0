import 'package:flutter/material.dart'; // For Flutter components like MaterialApp, Scaffold, etc.
import 'dart:async'; // For using Timer.
import 'package:intl/intl.dart'; // For formatting the time.
import 'package:flutter_screenutil/flutter_screenutil.dart'; // responsiveness
import 'package:flutter/services.dart'; // to not use the landscape mode
import 'redefinir_senha.dart';


void main() {
  SystemChrome.setPreferredOrientations([
    // impedir a rotação para o modo paisagem
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    ScreenUtilInit(
      designSize: Size(390, 844),
      minTextAdapt: true, // adaptar o texto ao tamanho d tela
      splitScreenMode: true, //se precisar lidar com telas divididas
      builder: (context, child) {
        //configurações do screenutil aplicadas à tela inteira
        return MaterialApp(debugShowCheckedModeBanner: false, home: MyApp());
      },
    ),
  ); // Starts the app by calling MyApp.
}

//
//
//
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor for the MyApp class.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner.
      home: LoginScreen(), // Sets the home screen as the login screen.
    );
  }
}

//
// LOGIN SCREEN CLASS
//
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); // Constructor for the LoginScreen class.

  @override
  _LoginScreenState createState() => _LoginScreenState(); // Creates the state for LoginScreen.
}

//
// LOGIN SCREEN STATE
//
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for the form
  final TextEditingController _emailController =
      TextEditingController(); // Controller for the Email field
  final TextEditingController _senhaController =
      TextEditingController(); // Controller for the Password field
  bool _obscureText = true; // To hide or show the password
  bool _isLoading =
      false; // To show loading indicator while processing the login
  String _horaAtual = DateFormat(
    'HH:mm',
  ).format(DateTime.now()); // Current time formatted as 'HH:mm'
  Timer? _timer; // Timer to update the time every second

  // TIME UPDATE

  @override
  void initState() {
    super.initState();

    // UPDATE TIME EVERY SECOND

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _horaAtual = DateFormat('HH:mm').format(DateTime.now());
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancels the timer when the widget is disposed
    super.dispose();
  }

  // FUNCTION TO ACTIVATE LOGIN

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Activates the loading state
      });

      // SNACK BAR

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false; // Deactivates the loading state
        });

        // Show a success message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login realizado com sucesso!',
            ), // Displays a success message
          ),
        );
      });
    }
  }

  //RESPONSIVENESS MEDIA QUERY AND ORIENTATION BUILDER

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size; // Screen size
    final isLandscape =
        MediaQuery.of(context).orientation ==
        Orientation.landscape; // Checks if the screen is in landscape mode
    final isTablet = screenSize.width > 600; // Checks if the device is a tablet

    double logoSize =
        isTablet ? 230 : 180; // Adjusts the logo size based on the device type
    double containerWidth =
        isTablet
            ? 450
            : 350; // Adjusts the container width based on the device type

    // BACKGROUND BUILD

    return Scaffold(
      body: Stack(
        // Stack para sobrepor widgets
        children: [
          // Container com imagem de fundo e cor azul
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/imagem.png'), // BACKGROUND IMAGE
                fit: BoxFit.cover, // A imagem cobre toda a tela
                colorFilter: ColorFilter.mode(
                  Color.fromARGB(
                    51,
                    0,
                    0,
                    0,
                  ), // A imagem com 20% de opacidade (50 de 255)
                  BlendMode.darken, // Mescla as cores
                ),
              ),
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(
                153,
                155,
                224,
                236,
              ), // Cor azul com opacidade de 30%
            ),
          ),

          //
          //SAFE AREA
          //
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //
                    // STATUS BAR
                    //
                    Padding(
                      padding: EdgeInsets.all(
                        16,
                      ), // Adds padding of 16 pixels on all sides of the widget.
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween, // Aligns children to both ends of the Row with space between them.
                        children: [
                          Text(
                            _horaAtual, // Displays the current time on the left side of the row.
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Row(
                            // Nested Row widget to arrange icons horizontally on the right side.
                            children: [
                              Icon(
                                Icons.wifi,
                                color: Colors.white,
                                size: 18,
                              ), // white WiFi icon
                              SizedBox(
                                width: 5,
                              ), // Adds a 5-pixel horizontal space between the icons.
                              Icon(
                                Icons.signal_cellular_alt,
                                color: Colors.white,
                                size: 18, // white cellular signal icon
                              ),
                              SizedBox(
                                width: 5,
                              ), // Adds a 5-pixel horizontal space between the icons.
                              Icon(
                                Icons.battery_full,
                                color: Colors.white,
                                size: 18, // white battery icon (full)
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    //
                    //CHOOSING BETWEEN A ROW AND A COLUMN BY THE DEVICE SIZE
                    // RESPONSIVENESS
                    //
                   Expanded(
  child: SingleChildScrollView(
    padding: EdgeInsets.symmetric(vertical: 20),
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
                LoginContainer(
                  formKey: _formKey,
                  emailController: _emailController,
                  senhaController: _senhaController,
                  onLogin: _login,
                  obscureText: _obscureText,
                  toggleObscureText: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  isLoading: _isLoading,
                  containerWidth: containerWidth,
                ),
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
                LoginContainer(
                  formKey: _formKey,
                  emailController: _emailController,
                  senhaController: _senhaController,
                  onLogin: _login,
                  obscureText: _obscureText,
                  toggleObscureText: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  isLoading: _isLoading,
                  containerWidth: containerWidth,
                ),
              ],
            ),
    ),
  ),
),
                    // APP VERSION
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            "V 1.0.2",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Container(width: 50, height: 2, color: Colors.white),// linha abaixo
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
}

class LoginContainer extends StatelessWidget {
  // STATELESS - IT DOES NOT CHANGE ONCE BUILT
  final GlobalKey<FormState>
  formKey; // A key used to manage the state of the form inside this container.
  final TextEditingController
  emailController; // Controller for the email input field, used to read and update the text.
  final TextEditingController
  senhaController; // Controller for the password input field, works the same way as emailController.
  final VoidCallback
  onLogin; // Function that will be called when the login button is pressed.
  final bool
  obscureText; // A boolean (true/false) value that controls whether the password is hidden.
  final VoidCallback
  toggleObscureText; // Function that toggles (switches) the obscureText value when the eye icon is tapped.
  final bool
  isLoading; // A boolean that checks if the login process is loading (for example, showing a spinner).
  final double
  containerWidth; // A double value that defines the width of this login container.

  // This is the constructor of the LoginContainer.
  // It initializes all the variables that are required when creating this widget.
  const LoginContainer({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.senhaController,
    required this.onLogin,
    required this.obscureText,
    required this.toggleObscureText,
    required this.isLoading,
    required this.containerWidth,
  });

  //CONTAINER BUILD

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth,
      padding: const EdgeInsets.all(20),

      // Box Decoration
      decoration: BoxDecoration(
        color: const Color.fromARGB(178, 33, 38, 36), // 70% opacity
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(128),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 5),
          ),
        ],
      ),

      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize:
              MainAxisSize
                  .min, // Makes the container take up only the necessary space
          children: [
           const Text(
              "Bem-Vindo",
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
           const  Text(
              "Interação fácil com seu clube",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 20), // Space before fields
            // Email Field
            FractionallySizedBox(
              alignment: Alignment.center,
              widthFactor:
                  0.8, // Makes the field occupy 80% of the container width
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  fillColor: Colors.white, // White background color
                  filled: true,
                  prefixIcon: Icon(Icons.person), // Icon inside field
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu email';
                  }
                  // Email Validation
                  String pattern =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                  RegExp regExp = RegExp(pattern);
                  if (!regExp.hasMatch(value)) {
                    return 'Digite um email válido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10), // Space between fields
            // Password Field
            FractionallySizedBox(
              alignment: Alignment.center,
              widthFactor:
                  0.8, // Makes the field occupy 80% of the container width
              child: TextFormField(
                controller: senhaController,
                decoration: InputDecoration(
                  fillColor: Colors.white, // White background color
                  filled: true,
                  prefixIcon: const Icon(Icons.lock),
                  labelText: "Senha",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: toggleObscureText,
                  ),
                ),
                obscureText: obscureText,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite sua senha';
                  }
                  return null;
                },
              ),               
            ),
            const SizedBox(height: 5), 
             // Forgot Password Link
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector( // capturar o toque de texto
                onTap: (){ // quando usuário toca no texto
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PasswordResetContainer()),
                  );
                },
              
              child: const Text(
                "Esqueceu a senha?",
                style: TextStyle(fontSize: 10,color: Colors.blue,decoration: TextDecoration.underline),
              ),
              ),
            ),
            const SizedBox(height: 20), // Space before button
            // Circular Progress Indicator or Elevated Button
            FractionallySizedBox(
              alignment: Alignment.center,
              widthFactor:
                  0.8, // Makes the button occupy 80% of the container width
              child:
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Blue button
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Rounded corners
                          ),
                        ),
                        onPressed: onLogin,
                        child: const Text("Entrar"),
                      ),
            ),
            const SizedBox(height: 10),

            // Forgot Password Link
             Align(
              alignment: Alignment.center,
              child: Text(
                "Não possui conta? Solicitar acesso",
                style: TextStyle(fontSize: 10,fontWeight:FontWeight.bold,color:Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
