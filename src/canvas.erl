%%% @author Tony Rogvall <tony@rogvall.se>
%%% @copyright (C) 2010, Tony Rogvall
%%% @doc
%%%    Canvas actions for nitrogen
%%% @end
%%% Created :  5 Sep 2010 by Tony Rogvall <tony@rogvall.se>

-module(canvas).

-include("../include/wf_canvas.hrl").

-compile(export_all).


%% state
save(Canvas) ->
    command(Canvas, save).

restore(Canvas) ->
    command(Canvas, restore).

%% Extension: Evaluate Fun under a save/restore pair
withState(Canvas, Fun) ->
    save(Canvas),
    try Fun() of
	Result ->
	    Result
    after
	restore(Canvas)
    end.

%% Extension:  beginPath ... fill
pathFill(Canvas, Fun) ->
    beginPath(Canvas),
    Fun(),
    fill(Canvas).

%% Extension:  beginPath ... stroke
pathStroke(Canvas, Fun) ->
    beginPath(Canvas),
    Fun(),
    stroke(Canvas).
    


%% transformation
scale(Canvas, X, Y) when is_number(X), is_number(Y) -> 
    command(Canvas, {scale,X,Y}).
rotate(Canvas, Angle) when is_number(Angle) -> 
    command(Canvas, {rotate, Angle}).
translate(Canvas, X, Y) when is_number(X), is_number(Y) ->
    command(Canvas, {translate,X,Y}).

transform(Canvas, {A, B, C, D, E, F})
  when is_number(A), is_number(B), is_number(C),
       is_number(D), is_number(E), is_number(F) ->    
    command(Canvas, {transform,A,B,C,D,E,F}).
transform(Canvas, A, B, C, D, E, F) 
  when is_number(A), is_number(B), is_number(C),
       is_number(D), is_number(E), is_number(F) ->
    command(Canvas, {transform,A,B,C,D,E,F}).

setTransform(Canvas, A, B, C, D, E, F)
  when is_number(A), is_number(B), is_number(C),
       is_number(D), is_number(E), is_number(F) ->
    command(Canvas, {setTransform,A,B,C,D,E,F}).

setTransform(Canvas, {A, B, C, D, E, F})
  when is_number(A), is_number(B), is_number(C),
       is_number(D), is_number(E), is_number(F) ->
    command(Canvas, {setTransform,A,B,C,D,E,F}).

%% compositing
globalAlpha(Canvas, Alpha) when is_number(Alpha) ->
    command(Canvas, {globalAlpha, Alpha}).
globalCompositeOperation(Canvas, Operation) when is_list(Operation) ->
    command(Canvas, {globalCompositeOperation, Operation}).

%% colors and styles

strokeStyle(Canvas, Style) when is_list(Style); is_atom(Style) ->
    command(Canvas, {strokeStyle,Style}).

fillStyle(Canvas, Style) when is_list(Style); is_atom(Style) ->
    command(Canvas, {fillStyle,Style}).

%% fixme gradiant/pattern
lineWidth(Canvas, Width) when is_number(Width) ->
    command(Canvas, {lineWidth, Width}).

%% Cap = butt | round | square
lineCap(Canvas, Cap) when is_atom(Cap)  ->
    command(Canvas, {lineCap, Cap}).

%% Join = round | bevel | miter
lineJoin(Canvas, Join) when is_atom(Join) ->
    command(Canvas, {lineJoin, Join}).

miterLimit(Canvas, Limit) when is_number(Limit) ->
    command(Canvas, {miterLimit, Limit}).

%% shadows
shadowOffsetX(Canvas,X) when is_number(X) ->
    command(Canvas, {shadowOffsetX, X}).

shadowOffsetY(Canvas,Y) when is_number(Y) ->
    command(Canvas, {shadowOffsetY, Y}).

shadowBlur(Canvas, Blur) when is_number(Blur) ->
    command(Canvas, {shadowBlur, Blur}).

shadowColor(Canvas,Color) when is_list(Color); is_atom(Color) -> 
    command(Canvas, {shadowColor,Color}).

%% rects    
clearRect(Canvas, {X, Y, W, H}) ->
    clearRect(Canvas, X, Y, W, H).
clearRect(Canvas, X, Y, W, H)
  when is_number(X), is_number(Y), is_number(W), is_number(H) ->
    command(Canvas, {clearRect,X,Y,W,H}).
fillRect(Canvas, {X, Y, W, H}) ->
    fillRect(Canvas, X, Y, W, H).
fillRect(Canvas, X, Y, W, H)
  when is_number(X), is_number(Y), is_number(W), is_number(H) ->
    command(Canvas, {fillRect,X,Y,W,H}).
strokeRect(Canvas, {X, Y, W, H}) ->
    strokeRect(Canvas, X, Y, W, H).
strokeRect(Canvas, X, Y, W, H) 
  when is_number(X), is_number(Y), is_number(W), is_number(H) ->
    command(Canvas, {strokeRect,X,Y,W,H}).

%% path API
beginPath(Canvas) ->
    command(Canvas, beginPath).

closePath(Canvas)  ->
    command(Canvas, closePath).

moveTo(Canvas,{X,Y})  ->
    moveTo(Canvas,X,Y).
moveTo(Canvas,X,Y) 
  when is_number(X), is_number(Y) ->
    command(Canvas, {moveTo,X,Y}).

lineTo(Canvas,{X,Y}) ->
    lineTo(Canvas, X, Y).
lineTo(Canvas,X,Y)  
  when is_number(X), is_number(Y) -> 
    command(Canvas, {lineTo,X,Y}).

quadraticCurveTo(Canvas,CX1,CY1,X,Y)
    when is_number(CX1), is_number(CY1), is_number(X), is_number(Y) -> 
    command(Canvas, {quadraticCurveTo,CX1,CY1,X,Y}).

bezierCurveTo(Canvas,CX1,CY1,CX2,CY2,X,Y)
    when is_number(CX1), is_number(CY1), is_number(CX2), is_number(CY2),
	 is_number(X), is_number(Y) -> 
    command(Canvas, {bezierCurveTo,CX1,CY1,CX2,CY2,X,Y}).

arcTo(Canvas,X1,Y1,X2,Y2,R)
  when is_number(X1), is_number(Y1), is_number(X2), is_number(Y2),
       is_number(R) ->
    command(Canvas, {arcTo,X1,Y1,X2,Y2,R}).

rect(Canvas, {X, Y, W, H}) ->
    rect(Canvas, X, Y, W, H).
rect(Canvas, X, Y, W, H)
  when is_number(X), is_number(Y), 
       is_number(W), is_number(H) ->
    command(Canvas, {rect,X,Y,W,H}).

arc(Canvas,X,Y,R,A0,A1,ACW) 
  when is_number(X), is_number(Y), is_number(R), 
       is_number(A0), is_number(A1), is_boolean(ACW) ->
    command(Canvas, {arc,X,Y,R,A0,A1,ACW}).

fill(Canvas) ->
    command(Canvas, fill).

stroke(Canvas) ->
    command(Canvas, stroke).

clip(Canvas) -> 
    command(Canvas, clip).

%% bool isPointInPath(X,Y) 
%%  boolean drawFocusRing(in Element element, in double xCaret, in double yCaret, in optional boolean canDrawCustom)
font(Canvas,Font) 
  when is_list(Font); is_atom(Font)  -> 
    command(Canvas, {font, Font}).

textAlign(Canvas,Align)
  when is_atom(Align) ->
    command(Canvas, {textAlign,Align}).

textBaseline(Canvas,Base) 
  when is_atom(Base) -> 
    command(Canvas, {textBaseline,Base}).

fillText(Canvas, Text, X, Y) 
  when is_list(Text), is_number(X), is_number(Y) ->
    command(Canvas,{fillText,Text,X,Y,null}).

fillText(Canvas, Text, X, Y, MaxWidth) 
  when is_list(Text), is_number(X), is_number(Y), is_number(MaxWidth) ->
    command(Canvas,{fillText,Text,X,Y,MaxWidth}).

strokeText(Canvas, Text, X, Y)
  when is_list(Text), is_number(X), is_number(Y) ->
    command(Canvas,{strokeText,Text,X,Y,null}).

strokeText(Canvas, Text, X, Y, MaxWidth) 
  when is_list(Text), is_number(X), is_number(Y), is_number(MaxWidth) ->
    command(Canvas,{strokeText,Text,X,Y,MaxWidth}).

    
%% TextMetrics mesureText(Text)
%%  void drawImage(in HTMLImageElement image, in double dx, in double dy, in optional double dw, in double dh);
drawImage(Canvas, Image, Dx, Dy)
  when is_list(Image), is_number(Dx), is_number(Dy) ->
    command(Canvas,{drawImage2,Image,Dx,Dy}).

drawImage(Canvas, Image, Dx, Dy, Dw, Dh) 
  when is_list(Image), is_number(Dx), is_number(Dy), 
       is_number(Dw), is_number(Dh) ->
    command(Canvas,{drawImage4,Image,Dx,Dy,Dw,Dh}).

drawImage(Canvas, Image, Sx, Sy, Sw, Sh, Dx, Dy, Dw, Dh) 
  when is_list(Image), 
       is_number(Sx), is_number(Sy), 
       is_number(Sw), is_number(Sh),
       is_number(Dx), is_number(Dy), 
       is_number(Dw), is_number(Dh) ->
    command(Canvas,{drawImage8,Image,Sx,Sy,Sw,Sh,Dx,Dy,Dw,Dh}).

%%/ pixel manipulation
%%  ImageData createImageData(in double sw, in double sh);
%%  ImageData createImageData(in ImageData imagedata);
%%  ImageData getImageData(in double sx, in double sy, in double sw, in double sh);
%%  void putImageData(in ImageData imagedata, in double dx, in double dy, in optional double dirtyX, in double dirtyY, in double dirtyWidth, in double dirtyHeight);

%% Image hacks
scroll(Canvas, X, Y, W, H, Dx, Dy)
  when is_number(X), is_number(Y), is_number(W), is_number(H),
       is_number(Dx), is_number(Dy) ->
    command(Canvas,{scroll,X,Y,W,H,Dx,Dy}).

scroll(Canvas, X, Y, W, H, Dx, Dy, Clear)
  when is_number(X), is_number(Y), is_number(W), is_number(H),
       is_number(Dx), is_number(Dy), is_list(Clear) ->
    command(Canvas,{scroll,X,Y,W,H,Dx,Dy,Clear}).

batch(Canvas, Commands) when is_list(Commands) ->
    wf:wire(Canvas, #canvas_action { command={batch,Commands} }). 

command(Canvas, Command) ->
    wf:wire(Canvas, #canvas_action { command=Command }).

%%
%% Loading image
%%
loadImage(Canvas, Name, Url) ->
    command(Canvas,{loadImage,Name,Url}).
