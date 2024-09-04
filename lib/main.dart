import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:latintokiril/bloc/convertion_bloc.dart';
import 'package:latintokiril/bloc/convertion_event.dart';
import 'package:latintokiril/bloc/convertion_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Latin-Cyrillic Converter',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => ConversionBloc(),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _isLatinToCyrillic = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Latin-Cyrillic Converter',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicator: BoxDecoration(
              color: Colors.deepPurpleAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            tabs: const [
              Tab(text: 'Latin to Cyrillic'),
              Tab(text: 'Cyrillic to Latin'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.deepPurpleAccent,
            onTap: (int index) {
              setState(() {
                _isLatinToCyrillic = index == 0;
              });
              _convertText();
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple[50]!, Colors.deepPurple[100]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter text',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: Colors.deepPurpleAccent, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: const TextStyle(color: Colors.deepPurpleAccent),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.deepPurple),
                    onPressed: () {
                      _controller.clear();
                      _convertText();
                    },
                  ),
                ),
                onChanged: (text) {
                  _convertText();
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<ConversionBloc, ConversionState>(
                builder: (context, state) {
                  _animationController.forward(from: 0);
                  return FadeTransition(
                    opacity: _animation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                                color: Colors.deepPurpleAccent, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            state.convertedText.isEmpty
                                ? "Converted text will appear here"
                                : state.convertedText,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.deepPurpleAccent),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: state.convertedText.isNotEmpty
                              ? () {
                                  Clipboard.setData(
                                      ClipboardData(text: state.convertedText));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Copied to clipboard'),
                                      backgroundColor: Colors.deepPurple,
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.deepPurpleAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Copy'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _convertText() {
    context.read<ConversionBloc>().add(
          ConvertText(
            text: _controller.text,
            isLatinToCyrillic: _isLatinToCyrillic,
          ),
        );
  }
}
