enum Status{loading,error,complete}

class Response<T>{

  Status? status;
  String? message;
  List<T>? data;

  Response(this.status, this.message, this.data);

Response.loading():status=Status.loading;
Response.complete(this.data):status=Status.complete;
Response.error(this.message):status=Status.error;

  @override
  String toString() {
    return "$status $message $data";
  }

}