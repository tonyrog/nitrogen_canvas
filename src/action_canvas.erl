%%% @author Tony Rogvall <tony@rogvall.se>
%%% @copyright (C) 2010, Tony Rogvall
%%% @doc
%%%      Canvas actions
%%% @end
%%% Created :  5 Sep 2010 by Tony Rogvall <tony@rogvall.se>

-module(action_canvas).
-include("wf_canvas.hrl").
-compile(export_all).

render_action(Record) ->
    %% Anchor = Record#canvas_action.anchor,
    C = Record#canvas_action.target,
    Res = fcmd(C, Record#canvas_action.command),
    %% io:format("canvas:render_action: ~s\n", [Res]),
    Res.

fcmd(Canvas, Method) when is_atom(Method) ->
    fmeth(Canvas,Method, []);
fcmd(Canvas, {batch, Commands}) ->
    Arg = [$[,felems(Commands),$]],
    ["Canvas.batch", $(, fa(Canvas),$,, Arg, $), $\;];
fcmd(Canvas, Call) when is_tuple(Call) ->
    [Method|Args] = tuple_to_list(Call),
    fmeth(Canvas,Method,Args).

fmeth(Canvas,Method,Args) ->
    ["Canvas.", atom_to_list(Method), $(, fas([Canvas|Args]), $), $\;].

fas([A]) -> [fa(A)];
fas([A|As]) -> [fa(A),$,|fas(As)];
fas([]) -> [].

fa(A) when is_integer(A) ->   integer_to_list(A);
fa(A) when is_float(A) -> io_lib_format:fwrite_g(A);
fa(false) -> "false";
fa(true) ->  "true";
fa(null) -> "null"; %% hmmm
fa(A) when is_atom(A) ->  [$', atom_to_list(A), $'];
fa(A) when is_list(A) -> [$", wf:js_escape(A), $"].

%%
%% Batch commands
%%  [ [cmd,args1...], [cmd2,args2...] ...  [cmdN,argsN...] ]
%%
felems([E])    -> [felem(E)];
felems([E|Es]) -> [felem(E),",",felems(Es)];
felems([])     -> [].

felem(E) when is_atom(E) ->
    [$[,fa(E),$]];
felem(E) when is_tuple(E) ->
    [$[, fas(tuple_to_list(E)), $]].
	
	    
