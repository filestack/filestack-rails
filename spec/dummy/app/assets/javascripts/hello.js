// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
console.log(rich_client);

function logIt(data){
    console.log(data.filesUploaded[0].url)
}

function onDoneCallback() {
  console.log('onDoneCallback');
}

function onCloseCallback() {
  console.log('onCloseCallback');
}

function onFileUploadFinishedCallback(data) {
  console.log(data);
}
