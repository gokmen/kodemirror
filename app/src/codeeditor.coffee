kd         = require 'kd.js'
CodeMirror = require 'CodeMirror'

# This is required to make CodeMirror plugins and modes to get work ~ GG
global.CodeMirror = CodeMirror

module.exports = class CodeEditor extends kd.InputView

  constructor: (options = {}, data) ->

    options.type         = 'textarea'
    options.defaultValue = data?.content

    super options, data

    @once 'viewAppended', =>

      mode = (@getOption 'mode') ? 'javascript'
      @cm  = CodeMirror.fromTextArea @getElement(),
        lineNumbers             : yes
        lineWrapping            : yes
        styleActiveLine         : yes
        scrollPastEnd           : yes
        cursorHeight            : 1
        tabSize                 : 2
        mode                    : mode
        autoCloseBrackets       : yes
        matchBrackets           : yes
        showCursorWhenSelecting : yes
        theme                   : 'tomorrow-night-eighties'
        extraKeys               :

          'Tab'                 : (cm) ->
            if cm.somethingSelected()
            then cm.indentSelection 'add'
            else cm.execCommand 'insertSoftTab'

          'Shift-Tab'           : (cm) ->
            cm.indentSelection 'subtract'

          'Cmd-S'               : @bound 'handleSave'
          'Ctrl-S'              : @bound 'handleSave'

          'Cmd-Enter'           : @bound 'runCode'
          'Ctrl-Enter'          : @bound 'runCode'

      @loadMode mode
      @emit 'ready'

  runCode: ->
    eval @cm.getValue()

  handleSave: ->
    console.log '> Save called', @cm.getValue()

  focus: -> @cm.focus()

  loadMode: (mode, force = no) ->

    @removeMode mode  if force

    tagName    = 'script'
    domId      = "lazy-mode-#{mode}"
    attributes =
      type     : 'text/javascript'
      src      : "cm/#{mode}.js"
    bind       = 'load'
    load       = => @cm.setOption 'mode', mode

    global.document.head.appendChild (new kd.CustomHTMLView {
      domId, tagName, attributes, bind, load
    }).getElement()

  removeMode: (mode) ->
    (global.document.getElementById "lazy-mode-#{mode}")?.remove()
