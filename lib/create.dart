import 'package:basic_mobile/api.dart';
import 'package:basic_mobile/model.dart';
import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  final Blog? blog;

  const CreateScreen({Key? key, this.blog}) : super(key: key);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  bool _isLoading = false;
  late Api _api;
  bool _isFieldTitleValid = false;
  bool _isFieldTitleSubValid = false;
  bool _isFieldKategoriValid = false;
  bool _isFieldDescriptionValid = false;

  late TextEditingController _controllerTitle;
  late TextEditingController _controllerTitleSub;
  late TextEditingController _controllerKategori;
  late TextEditingController _controllerDescription;

  @override
  void initState() {
    super.initState();
    _api = Api();

    _controllerTitle = TextEditingController(text: widget.blog?.title ?? '');
    _controllerTitleSub = TextEditingController(text: widget.blog?.title_sub ?? '');
    _controllerKategori = TextEditingController(text: widget.blog?.category ?? '');
    _controllerDescription = TextEditingController(text: widget.blog?.description ?? '');

    _isFieldTitleValid = widget.blog?.title != null;
    _isFieldTitleSubValid = widget.blog?.title_sub != null;
    _isFieldKategoriValid = widget.blog?.category != null;
    _isFieldDescriptionValid = widget.blog?.description != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.blog == null ? "Tambah Blog" : "Edit Blog",
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldTitle(),
                _buildTextFieldTitleSub(),
                _buildTextFieldKategori(),
                _buildTextFieldDescription(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitBlog,
                    child: Text(
                      "Simpan".toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                    ),
                  ),
                )
              ],
            ),
          ),
          if (_isLoading)
            Stack(
              children: <Widget>[
                Opacity(
                  opacity: 0.3,
                  child: const ModalBarrier(
                    dismissible: false,
                    color: Colors.grey,
                  ),
                ),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _submitBlog() async {
    if (!_isFieldTitleValid ||
        !_isFieldTitleSubValid ||
        !_isFieldKategoriValid ||
        !_isFieldDescriptionValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    Blog blog = Blog(
      id: widget.blog?.id,
      title: _controllerTitle.text,
      title_sub: _controllerTitleSub.text,
      category: _controllerKategori.text,
      description: _controllerDescription.text,
    );

    bool success;
    if (widget.blog == null) {
      success = await _api.createBlog(blog);
    } else {
      success = await _api.updateBlog(blog); // Call update if editing
    }

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.blog == null ? "Blog berhasil dibuat" : "Blog berhasil diubah")),
      );
      Navigator.pop(context, true); // Return success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save blog")),
      );
    }
  }

  Widget _buildTextFieldTitle() {
    return TextField(
      controller: _controllerTitle,
      decoration: InputDecoration(
        labelText: "Judul",
        errorText: _isFieldTitleValid ? null : "Isi judul",
      ),
      onChanged: (value) {
        setState(() {
          _isFieldTitleValid = value.trim().isNotEmpty;
        });
      },
    );
  }

  Widget _buildTextFieldTitleSub() {
    return TextField(
      controller: _controllerTitleSub,
      decoration: InputDecoration(
        labelText: "Sub Judul",
        errorText: _isFieldTitleSubValid ? null : "Isi sub judul",
      ),
      onChanged: (value) {
        setState(() {
          _isFieldTitleSubValid = value.trim().isNotEmpty;
        });
      },
    );
  }

  Widget _buildTextFieldKategori() {
    return TextField(
      controller: _controllerKategori,
      decoration: InputDecoration(
        labelText: "Kategori",
        errorText: _isFieldKategoriValid ? null : "Isi kategori",
      ),
      onChanged: (value) {
        setState(() {
          _isFieldKategoriValid = value.trim().isNotEmpty;
        });
      },
    );
  }

  Widget _buildTextFieldDescription() {
    return TextField(
      controller: _controllerDescription,
      decoration: InputDecoration(
        labelText: "Deskripsi",
        errorText: _isFieldDescriptionValid ? null : "Isi deskripsi",
      ),
      onChanged: (value) {
        setState(() {
          _isFieldDescriptionValid = value.trim().isNotEmpty;
        });
      },
    );
  }
}
