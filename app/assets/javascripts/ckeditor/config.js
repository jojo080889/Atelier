CKEDITOR.editorConfig = function(config) {
  config.extraPlugins = 'confighelper';

  // Toolbar groups configuration.
  config.toolbarGroups = [
    { name: 'clipboard', groups: [ 'undo' ] },
    { name: 'basicstyles', groups: [ 'basicstyles' ] },
    { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align' ] },
    { name: 'links' },
    { name: 'insert' },
    { name: 'styles' },
    { name: 'colors' },
    { name: 'tools' },
    { name: 'others' },
  ];

  /* Filebrowser routes */
  /* Copied from the ckeditor gem default config.js */
  // The location of an external file browser, that should be launched when "Browse Server" button is pressed.
  config.filebrowserBrowseUrl = "/ckeditor/attachment_files";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
  config.filebrowserFlashBrowseUrl = "/ckeditor/attachment_files";

  // The location of a script that handles file uploads in the Flash dialog.
  config.filebrowserFlashUploadUrl = "/ckeditor/attachment_files";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
  config.filebrowserImageBrowseLinkUrl = "/ckeditor/pictures";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
  config.filebrowserImageBrowseUrl = "/ckeditor/pictures";

  // The location of a script that handles file uploads in the Image dialog.
  config.filebrowserImageUploadUrl = "/ckeditor/pictures";

  // The location of a script that handles file uploads.
  config.filebrowserUploadUrl = "/ckeditor/attachment_files";
}
