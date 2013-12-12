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
}
