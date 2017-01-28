-module(user_default).

-compile([export_all]).

setup(recon) ->
    set_defaults(recon),
    code:add_path("/Users/sanmiguel/dotfiles/erl/recon/ebin").

set_defaults(recon) ->
    put(recon_limit, 10).


trace(Mod) ->
    recon_trace:calls({Mod, '_', return_trace}, get(recon_limit)).


trace(Mod, Fun) when is_atom(Fun) ->
    trace(Mod, [Fun]);
trace(Mod, Funs) when is_list(Funs) ->
    recon_trace:calls([ {Mod, F, return_trace} || F <- Funs ], get(recon_limit)).

ltrace(Mod, Fun) when is_atom(Fun) ->
    ltrace(Mod, [Fun]);
ltrace(Mod, Funs) when is_list(Funs) ->
    recon_trace:calls([ {Mod, F, return_trace} || F <- Funs ], get(recon_limit), [{scope, local}]).
