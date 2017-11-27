/* Taskflow client side API/protocol
 * ---------------------------------
 * Request available tasks from server
 * Request execution of task
 * Request status update/progress
*/
var org;
if(!org){
    org = {};
} else if (typeof org != 'object'){
    throw new Error("org already exists and is not an object.");
}
if(!org.setoc){
    org.setoc = {};
} else if (typeof org.setoc != 'object'){
    throw new Error("org.setoc already exists and is not an object.");
}

org.setoc.taskflow = function(){
    // private data and functions
    var server_name = "localhost";
    // public interface
    return {
        setServer: function(server){server_name = server;},
        getTasks: function(){},
        updatePage: function(){},
        executeTask: function(){},
        resetTask: function(){}
    };
}();