import 'package:flutter/material.dart';
import 'package:flutter_midi_pro/flutter_midi_pro.dart';
import 'package:flutter_piano_pro/flutter_piano_pro.dart';
import 'package:flutter_piano_pro/note_model.dart';
import 'package:flutter_piano_pro/note_names.dart';
import 'package:flutter_piano_pro/piano_scrollbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double noteCount = 7;
  double width = 300;
  double buttonWidthRatio = 2;
  double height = 250;
  bool expand = true;
  int firstNote = 0;
  int firstNoteOctave = 3;
  NoteType noteType = NoteType.english;
  bool showNames = true;
  bool showOctaveNumbers = true;
  Map<int, NoteModel> pointerAndNote = {};
  String sf2Path = 'assets/tight_piano.sf2';
  final _midi = MidiPro();
  final scrollBarKey = GlobalKey<PianoScrollbarState>();
  void animateToScrollPosition(double position) {
    scrollBarKey.currentState?.animateToScrollPosition(position);
  }

  void play(int midi, {int velocity = 127}) {
    _midi.playMidiNote(midi: midi, velocity: velocity);
  }

  void stop(int midi) {
    _midi.stopMidiNote(midi: midi);
  }

  @override
  void initState() {
    _midi.loadSoundfont(sf2Path: sf2Path);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> noteNames = noteType.notes;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.white54),
      home: Scaffold(
        appBar: AppBar(actions: [
          IconButton(
              onPressed: () => animateToScrollPosition(400),
              icon: Icon(Icons.abc))
        ], title: const Text('Piano')),
        body: SafeArea(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ListTile(
                title: const Text('Note Names'),
                trailing: SizedBox(
                  width: 250,
                  child: DropdownButton(
                      value: noteType,
                      items: List.generate(NoteType.values.length, (index) {
                        return DropdownMenuItem(
                            value: NoteType.values[index],
                            child: Text(NoteType.values[index].notes.toString()));
                      }),
                      onChanged: (value) => setState(() => noteType = value!)),
                ),
              ),
              const Divider(
                height: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('First Note'),
                      SizedBox(
                        child: DropdownButton(
                            value: firstNote,
                            items: List.generate(noteNames.length, (index) {
                              return DropdownMenuItem(
                                  value: index,
                                  child: Text(noteNames[index].toString()));
                            }),
                            onChanged: (value) =>
                                setState(() => firstNote = value!)),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('First Octave'),
                      SizedBox(
                        child: DropdownButton(
                            value: firstNoteOctave,
                            items: List.generate(noteNames.length, (index) {
                              return DropdownMenuItem(
                                  value: index, child: Text(index.toString()));
                            }),
                            onChanged: (value) =>
                                setState(() => firstNoteOctave = value!)),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                height: 0,
              ),
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Note Count',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(noteCount.round().toInt().toString()),
                  ],
                ),
                trailing: SizedBox(
                  width: 250,
                  child: Slider(
                    divisions: 44,
                    max: 45,
                    min: 1,
                    value: noteCount,
                    onChanged: (value) => setState(() => noteCount = value),
                  ),
                ),
              ),
              const Divider(
                height: 0,
              ),
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Height',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(height.round().toInt().toString()),
                  ],
                ),
                trailing: SizedBox(
                  width: 250,
                  child: Slider(
                    divisions: 27,
                    max: 300,
                    min: 150,
                    value: height,
                    onChanged: (value) => setState(() => height = value),
                  ),
                ),
              ),
              const Divider(
                height: 0,
              ),
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Black Button\nWidth Ratio',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(buttonWidthRatio.toStringAsFixed(2)),
                  ],
                ),
                trailing: SizedBox(
                  width: 250,
                  child: Slider(
                    divisions: 40,
                    max: 3,
                    min: 1,
                    value: buttonWidthRatio,
                    onChanged: (value) =>
                        setState(() => buttonWidthRatio = value),
                  ),
                ),
              ),
              const Divider(
                height: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Width',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(width.round().toInt().toString()),
                    ],
                  ),
                  SizedBox(
                    width: 200,
                    child: Slider(
                      divisions: 50,
                      max: 5000,
                      min: 100,
                      value: width,
                      onChanged: expand
                          ? null
                          : (value) => setState(() => width = value),
                    ),
                  ),
                  Column(
                    children: [
                      const Text('Expand Vertical'),
                      Checkbox(
                          value: expand,
                          onChanged: (value) => setState(() => expand = value!)),
                    ],
                  )
                ],
              ),
              const Divider(
                height: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Names'),
                      Checkbox(
                          value: showNames,
                          onChanged: (value) =>
                              setState(() => showNames = value!)),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Octave'),
                      Checkbox(
                          value: showOctaveNumbers,
                          onChanged: (value) =>
                              setState(() => showOctaveNumbers = value!)),
                    ],
                  ),
                ],
              ),
              PianoPro(
                  scrollBarKey: scrollBarKey,
                  onTapDown: (NoteModel? note, int tapId) {
                    if (note == null) return;
                    play(note.midiNoteNumber);
                    pointerAndNote[tapId] = note;
                  },
                  onTapUpdate: (NoteModel? note, int tapId) {
                    if (note == null) return;
                    if (pointerAndNote[tapId] == note) return;
                    stop(pointerAndNote[tapId]!.midiNoteNumber);
                    play(note.midiNoteNumber);
                    pointerAndNote[tapId] = note;
                  },
                  onTapUp: (int tapId) {
                    stop(pointerAndNote[tapId]!.midiNoteNumber);
                    pointerAndNote.remove(tapId);
                  },
                  noteType: noteType,
                  showNames: showNames,
                  showOctave: showOctaveNumbers,
                  expand: expand,
                  whiteWidth: width,
                  firstNoteIndex: firstNote,
                  firstOctave: firstNoteOctave,
                  whiteHeight: height,
                  blackWidthRatio: buttonWidthRatio,
                  scrollController: ScrollController(),
                  noteCount: noteCount.round().toInt()),
            ],
          ),
        ),
      ),
    );
  }
}