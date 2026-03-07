void main() {
  print(run());
}

int maybePanic() {
  throw "Error";
  return 4;
}

int run() {
  try {
    final data = maybePanic();
    return data;
  } catch (e) {
    print(e);
  } finally {
    print("Done");
  }
  return 0;
}
