import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  final String livroId;
  final String livroTitulo;

  const PdfViewer(this.livroId,this.livroTitulo, {Key key}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  //Selecionar Texto e copia-lo
  OverlayEntry _overlayEntry;
  void _showContextMenu(BuildContext context,PdfTextSelectionChangedDetails details) {
    final OverlayState _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion.center.dy - 55,
        left: details.globalSelectedRegion.bottomLeft.dx,
        child:
        ElevatedButton(
          child: Text('Copy',style: TextStyle(fontSize: 17, color: Colors.black)),
          onPressed: (){
            Clipboard.setData(ClipboardData(text: details.selectedText));
            _pdfViewerController.clearSelection();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            elevation: 10,
          ),
        ),
      ),
    );
    _overlayState.insert(_overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
              title: Text(widget.livroTitulo),
              backgroundColor: Colors.black87,
              actions: <Widget>[
                //Bookmark
                IconButton(onPressed: () {
                  _pdfViewerStateKey.currentState.openBookmarkView();
                }, icon: const Icon(Icons.bookmark, color: Colors.white,)),
                //Faz zoom
                IconButton(onPressed: () {
                  _pdfViewerController.zoomLevel=1.60;
                }, icon: const Icon(Icons.zoom_in, color: Colors.white,)),
              ]
          ),
          body: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('Livros').doc(widget.livroId).get(),
            builder:
                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshotpdf) {
              if (snapshotpdf.hasError) {
                return const Text("Algo correu mal!");
              }

              if (snapshotpdf.hasData && !snapshotpdf.data.exists) {
                return const Center(child:Text("Sem nenhum PDF"));
              }

              if (snapshotpdf.connectionState == ConnectionState.done) {
                Map<String, dynamic> datapdf = snapshotpdf.data.data();

                return Container(
                  child: SfPdfViewer.network(
                      datapdf['Pdf'],
                      //Selecionar o texto
                      onTextSelectionChanged:
                          (PdfTextSelectionChangedDetails details) {
                        if (details.selectedText == null && _overlayEntry != null) {
                          _overlayEntry.remove();
                          _overlayEntry = null;
                        } else if (details.selectedText != null && _overlayEntry == null) {
                          _showContextMenu(context, details);
                        }
                      },
                      controller: _pdfViewerController,
                      key: _pdfViewerStateKey),
                );
              }
              return Center(child: Text("A carregar..."));
            },
          ),
        )
    );
  }
}