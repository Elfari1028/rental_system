class CabinError {
  String className;
  String code;
  String msg;
  CabinError([this.className = "null", this.code = "null", this.msg = "null"]);
  String toString() {
    String ret = "";
    //this.runtimeType.toString();
    if (this.className.length > 0) ret += ":" + this.className;
    if (this.code.length > 0) ret += ":" + this.code;
    if (this.msg.length > 0) ret += ":" + this.msg;
    return ret;
  }
}

class FrontError extends CabinError {
  FrontError([className = "", code = "", msg = ""])
      : super(className, code, msg);
}

class BackError extends CabinError {
  BackError([className = "", code = "", msg = ""])
      : super(className, code, msg);
}
