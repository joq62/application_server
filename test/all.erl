%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(all).      
 
-export([start/0]).


-define(LogFileToRead,"./logs/test_application_server/log.logs/test_logfile.1").

%%%
-define(AddTestVm,add_test@c50).
-define(AddTestApp,add_test).
-define(AddTestFileName,"add_test.application").
-define(AddTestRepoDir,"add_test" ).
-define(CatalogDir,"catalog_specs").
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("log.api").
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
start()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME,?LINE}]),
    
    ok=setup(),
    ok=test_application_server:start(),
    


    timer:sleep(2000),
    io:format("Test OK !!! ~p~n",[?MODULE]),
    LogStr=os:cmd("cat "++?LogFileToRead),
    L1=string:lexemes(LogStr,"\n"),
    [io:format("~p~n",[Str])||Str<-L1],

    rpc:call(node(),init,stop,[],5000),
    timer:sleep(4000),
    init:stop(),
    ok.


%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test11()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    %% Clean up
    application_server:stop_app(?AddTestFileName),
    application_server:unload_app(?AddTestFileName),

    %% load_rel test
    {error,["Application is not loaded ","add_test.application"]}=application_server:start_app(?AddTestFileName),
    {error,["Not started ","add_test.application"]}=application_server:stop_app(?AddTestFileName),
    {error,["Not loaded ","add_test.application"]}=application_server:unload_app(?AddTestFileName),
    ok=application_server:load_app(?AddTestFileName),
    %% start_app test
    {error,["Already loaded ","add_test.application"]}=application_server:load_app(?AddTestFileName),
    {error,["Not started ","add_test.application"]}=application_server:stop_app(?AddTestFileName),
     ok=application_server:start_app(?AddTestFileName),
    ApplicationSpecFile=filename:join(?CatalogDir,?AddTestFileName),
    {ok,[Info]}=file:consult(ApplicationSpecFile), 
    Nodename=maps:get(nodename,Info),
    {ok,Hostname}=net:gethostname(),
    AppVm=list_to_atom(Nodename++"@"++Hostname),
    App=maps:get(app,Info),
    42=rpc:call(AppVm,App,add,[20,22],3*5000),
    %% stop_app test 
    {error,["Already loaded ","add_test.application"]}=application_server:load_app(?AddTestFileName),
    {error,[" Application started , needs to be stopped ","catalog_specs","add_test.application"]}=application_server:unload_app(?AddTestFileName),    
    {error,["Already started ","add_test.application"]}=application_server:start_app(?AddTestFileName),
    ok=application_server:stop_app(?AddTestFileName),
    {badrpc,nodedown}=rpc:call(AppVm,App,add,[20,22],3*5000),
    %% unload_app 
    {error,["Already loaded ","add_test.application"]}=application_server:load_app(?AddTestFileName),
    {error,["Not started ","add_test.application"]}=application_server:stop_app(?AddTestFileName),
    ok=application_server:unload_app(?AddTestFileName),  
    
    
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------
test1()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),
    %% Clean up
    lib_application:stop_rel(?CatalogDir,?AddTestFileName),
    lib_application:unload_rel(?CatalogDir,?AddTestFileName),

    %% load_rel test
    {error,["Application is not loaded ","add_test.application"]}=lib_application:start_rel(?CatalogDir,?AddTestFileName),
    {error,["Not started ","add_test.application"]}=lib_application:stop_rel(?CatalogDir,?AddTestFileName),
    {error,["Not loaded ","add_test.application"]}=lib_application:unload_rel(?CatalogDir,?AddTestFileName),
    ok=lib_application:load_rel(?CatalogDir,?AddTestFileName),
    %% start_rel test
    {error,["Already loaded ","add_test.application"]}=lib_application:load_rel(?CatalogDir,?AddTestFileName),
    {error,["Not started ","add_test.application"]}=lib_application:stop_rel(?CatalogDir,?AddTestFileName),
     ok=lib_application:start_rel(?CatalogDir,?AddTestFileName),
    ApplicationSpecFile=filename:join(?CatalogDir,?AddTestFileName),
    {ok,[Info]}=file:consult(ApplicationSpecFile), 
    Nodename=maps:get(nodename,Info),
    {ok,Hostname}=net:gethostname(),
    AppVm=list_to_atom(Nodename++"@"++Hostname),
    App=maps:get(app,Info),
    42=rpc:call(AppVm,App,add,[20,22],3*5000),
    %% stop_rel test 
    {error,["Already loaded ","add_test.application"]}=lib_application:load_rel(?CatalogDir,?AddTestFileName),
    {error,[" Application started , needs to be stopped ","catalog_specs","add_test.application"]}=lib_application:unload_rel(?CatalogDir,?AddTestFileName),    
    {error,["Already started ","add_test.application"]}=lib_application:start_rel(?CatalogDir,?AddTestFileName),
    ok=lib_application:stop_rel(?CatalogDir,?AddTestFileName),
    {badrpc,nodedown}=rpc:call(AppVm,App,add,[20,22],3*5000),
    %% unload_rel 
    {error,["Already loaded ","add_test.application"]}=lib_application:load_rel(?CatalogDir,?AddTestFileName),
    {error,["Not started ","add_test.application"]}=lib_application:stop_rel(?CatalogDir,?AddTestFileName),
    ok=lib_application:unload_rel(?CatalogDir,?AddTestFileName),  
    
    
    ok.

%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------

setup()->
    io:format("Start ~p~n",[{?MODULE,?FUNCTION_NAME}]),


    ok=application:start(log),
    file:make_dir(?MainLogDir),
    [NodeName,_HostName]=string:tokens(atom_to_list(node()),"@"),
    NodeNodeLogDir=filename:join(?MainLogDir,NodeName),
    ok=log:create_logger(NodeNodeLogDir,?LocalLogDir,?LogFile,?MaxNumFiles,?MaxNumBytes),

    ok=application:start(rd),

    ok=application:start(compiler_server),
    pong=rpc:call(node(),compiler_server,ping,[],3*5000),  
    ok=application:start(git_handler),
    pong=rpc:call(node(),git_handler,ping,[],3*5000),  

    %% Application to test
    ok=application:start(application_server),
    pong=rpc:call(node(),application_server,ping,[],3*5000),  
 %   ok=initial_trade_resources(),
    
    ok.


initial_trade_resources()->
    [rd:add_local_resource(ResourceType,Resource)||{ResourceType,Resource}<-[]],
    [rd:add_target_resource_type(TargetType)||TargetType<-[controller,adder3]],
    rd:trade_resources(),
    timer:sleep(3000),
    ok.
