-- Copyright 2012-2015 The Howl Developers
-- License: MIT (see LICENSE.md at the top-level directory of the distribution)

{:List, :ListWidget, :Popup} = howl.ui
{:config} = howl

class MenuPopup extends Popup
  new: (@items, @callback) =>
    error('Missing argument #1: items', 3) if not @items
    error('Missing argument #2: callback', 3) if not @callback

    @list = List -> @items
    @list_widget = ListWidget @list, auto_fit_width: true

    @highlight_matches_for = ''
    super @list_widget\to_gobject!
    with @child
      .margin_top = 2
      .margin_left = 2

    @list_widget\show!

  refresh: =>
    @list\update @highlight_matches_for

  show: (...) =>
    @refresh!
    super ...
    @resize!

  resize: =>
    h_margin = @child.margin_left + @child.margin_right
    v_margin = @child.margin_top + @child.margin_bottom
    super @list_widget.width + h_margin, @list_widget.height + v_margin

  choose: =>
    if self.callback @list.selection
      @close!

  keymap: {
    down: => @list\select_next!
    ctrl_n: => @list\select_next!
    up: => @list\select_prev!
    ctrl_p: => @list\select_prev!
    page_down: => @list\next_page!
    page_up: => @list\prev_page!

    on_unhandled: (event, source, translations, self) ->
      unless event.character
        self\close!

    tab: =>
      if config.popup_menu_accept_key == 'tab'
        @choose!
      else
        false

    return: =>
      if config.popup_menu_accept_key == 'enter'
        @choose!
      else
        false
  }
