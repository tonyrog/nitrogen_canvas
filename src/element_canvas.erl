%%% @author Tony Rogvall <tony@rogvall.se>
%%% @copyright (C) 2010, Tony Rogvall
%%% @doc
%%%  Nitrogen canvas
%%% @end
%%% Created :  5 Sep 2010 by Tony Rogvall <tony@rogvall.se>

-module(element_canvas).
-include("wf_canvas.hrl").
-compile(export_all).

reflect() -> record_info(fields, canvas).

render_element(Record) ->
    Attributes = [
		  {class, [canvas, Record#canvas.class]},
		  {style, Record#canvas.style},
		  {width, Record#canvas.width},
		  {height, Record#canvas.height}],
    wf_tags:emit_tag(canvas, Attributes).

