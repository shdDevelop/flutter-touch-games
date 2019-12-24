/// Created by weicheng.fu on 2019/11/07
class ResultData<T> {
  dynamic status;
  String message;
  T _model;
  String data;

  ResultData(
    this.status,
    this.message,
    this.data,
  );

  T get model => _model;

  set model(T value) {
    _model = value;
  }


}
