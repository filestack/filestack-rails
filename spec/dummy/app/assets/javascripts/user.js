// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
console.log(filestack_client);

function logIt(data) {
  console.log('logIt', data.filesUploaded[0].url);
};

function onDone() {
  console.log('onDone');
};

function onClose() {
  console.log('onClose');
};

function onFileUploadFinishedCallback(data) {
  console.log('onFileUploadFinishedCallback', data.url);
};

function attachLogo(data) {
  console.log(data);
};
