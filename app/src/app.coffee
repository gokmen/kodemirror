kd         = require 'kd.js'
CodeEditor = require './codeeditor'

do ->

  mainView = new kd.View
  mainView.appendToDomBody()

  editor = new CodeEditor
    mode     : 'javascript'
  , content  : """
    // Tip: Hit Cmd+Enter to run this code right now!

    var foo;
    foo = 'This is KodeMirror (kd.js) with CodeMirror!';

    alert(foo);
  """

  kd.utils.defer editor.bound 'focus'

  mainView.addSubView editor
