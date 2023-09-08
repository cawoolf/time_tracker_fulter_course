

// Common API class for keeping track of FireStore Paths. Best practice
class APIPath {
  static String job(String uid, String jobId) => 'users/$uid/jobs/$jobId'; //Returns a single target job
  static String jobs(String uid) => 'users/$uid/jobs';  //Returns all jobs for a User
  static String entry(String uid, String entryId) => 'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';

}