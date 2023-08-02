

// Common API class for keeping track of FireStore Paths. Best practice
class APIPath {
  static String job(String uid, String jobId) => '/users/$uid/jobs/$jobId';
}