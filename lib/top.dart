class TopController {
  TopController({this.onCreate});

  Function()? onCreate;

  void create() {
    onCreate?.call();
  }
}
