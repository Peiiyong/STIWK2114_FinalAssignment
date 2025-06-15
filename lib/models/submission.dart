class Submission {
  int? id;
  int? workId;
  int? workerId;
  String? submissionText;
  String? submittedAt;

  Submission(
      {this.id,
      this.workId,
      this.workerId,
      this.submissionText,
      this.submittedAt});

  Submission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    workId = json['work_id'];
    workerId = json['worker_id'];
    submissionText = json['submission_text'];
    submittedAt = json['submitted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['work_id'] = this.workId;
    data['worker_id'] = this.workerId;
    data['submission_text'] = this.submissionText;
    data['submitted_at'] = this.submittedAt;
    return data;
  }
}