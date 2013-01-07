%%
%% Canvas elements and actions
%% 
-ifndef(__WF_CANVAS_HRL_).
-define(__WF_CANVAS_HRL_, true).

-include_lib("nitrogen_core/include/wf.hrl").

-record(canvas, {?ELEMENT_BASE(element_canvas), width, height}).
-record(canvas_action, {?ACTION_BASE(action_canvas), command}).

-endif.

