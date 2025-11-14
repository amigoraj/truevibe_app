import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../utils/location_helper.dart';

class CreatePostScreen extends StatefulWidget {
  final ApiClient api;
  const CreatePostScreen({super.key, required this.api});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _textCtrl = TextEditingController();
  bool loading = false;
  String selectedFeedType = 'growth';

  Future<void> createPost() async {
    setState(() => loading = true);
    final text = _textCtrl.text.trim();
    final pos = await LocationHelper.getCurrentLocation();
    final lat = pos?.latitude;
    final lng = pos?.longitude;

    final body = {
      'text': text,
      'feedType': selectedFeedType,
      if (lat != null && lng != null) 'location': {'lat': lat, 'lng': lng},
    };

    final res = await widget.api.post('/api/posts', body);
    setState(() => loading = false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error ${res.statusCode}: ${res.body}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedFeedType,
              items: ['growth','local','mindset','fun','learning']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase())))
                  .toList(),
              onChanged: (v) => setState(() => selectedFeedType = v!),
            ),
            TextField(
              controller: _textCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Write something...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text("Post"),
                    onPressed: createPost,
                  ),
          ],
        ),
      ),
    );
  }
}
